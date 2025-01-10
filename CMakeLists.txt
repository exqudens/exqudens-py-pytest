cmake_minimum_required(VERSION "3.25" FATAL_ERROR)

message(STATUS "CMAKE_VERSION: '${CMAKE_VERSION}'")
message(STATUS "PRESET_NAME: '${PRESET_NAME}'")
message(STATUS "PYTHON_ENV_REL_PATH: '${PYTHON_ENV_REL_PATH}'")
message(STATUS "MAIN_ENV_REL_PATH: '${MAIN_ENV_REL_PATH}'")
message(STATUS "TEST_ENV_REL_PATH: '${TEST_ENV_REL_PATH}'")

# get project name
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/pyproject.toml" CONTENT)
string(REGEX MATCH "name = \"[^\"]+\"" NAME "${CONTENT}")
string(REGEX REPLACE "name = \"(.+)\"" "\\1" NAME "${NAME}")
string(STRIP "${NAME}" NAME)

# get project version
file(READ "${CMAKE_CURRENT_SOURCE_DIR}/src/main/py/exqudens/pytest/__init__.py" CONTENT)
string(REGEX MATCH "__version__ = \"[0-9.]+\"" VERSION "${CONTENT}")
string(REGEX REPLACE "__version__ = \"(.+)\"" "\\1" VERSION "${VERSION}")
string(STRIP "${VERSION}" VERSION)

project("${NAME}" VERSION "${VERSION}" LANGUAGES "NONE")
message(STATUS "project: '${PROJECT_NAME}-${PROJECT_VERSION}'")
message(STATUS "PROJECT_SOURCE_DIR: '${PROJECT_SOURCE_DIR}'")
message(STATUS "PROJECT_BINARY_DIR: '${PROJECT_BINARY_DIR}'")

find_program(PYTHON_COMMAND NAMES "py.exe" "python" PATHS ENV PYTHON_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)
message(STATUS "PYTHON_COMMAND: '${PYTHON_COMMAND}'")

set(MAIN_PYTHON_FILE "${PROJECT_BINARY_DIR}/${MAIN_ENV_REL_PATH}/${PYTHON_ENV_REL_PATH}")
set(TEST_PYTHON_FILE "${PROJECT_BINARY_DIR}/${TEST_ENV_REL_PATH}/${PYTHON_ENV_REL_PATH}")

message(STATUS "MAIN_PYTHON_FILE: '${MAIN_PYTHON_FILE}'")
message(STATUS "TEST_PYTHON_FILE: '${TEST_PYTHON_FILE}'")

add_custom_command(
    OUTPUT "${MAIN_PYTHON_FILE}"
    COMMAND "${PYTHON_COMMAND}" "-m" "venv" "--copies" "${PROJECT_BINARY_DIR}/${MAIN_ENV_REL_PATH}"
    COMMAND "${MAIN_PYTHON_FILE}" "-m" "pip" "download" "-d" "${PROJECT_BINARY_DIR}/${MAIN_ENV_REL_PATH}/dependencies" ".[app]"
    #COMMAND "${MAIN_PYTHON_FILE}" "-m" "pip" "uninstall" "-y" "${PROJECT_NAME}"
    COMMENT "main env create"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("main-env"
    DEPENDS "${MAIN_PYTHON_FILE}"
)

add_custom_command(
    OUTPUT "${TEST_PYTHON_FILE}"
    COMMAND "${PYTHON_COMMAND}" "-m" "venv" "--copies" "${PROJECT_BINARY_DIR}/${TEST_ENV_REL_PATH}"
    COMMAND "${TEST_PYTHON_FILE}" "-m" "pip" "download" "-d" "${PROJECT_BINARY_DIR}/${TEST_ENV_REL_PATH}/dependencies" ".[test]"
    #COMMAND "${MAIN_PYTHON_FILE}" "-m" "pip" "uninstall" "-y" "${PROJECT_NAME}"
    COMMENT "test env create"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("test-env"
    DEPENDS "${TEST_PYTHON_FILE}"
)

add_custom_target("vscode"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/cmake/vscode.cmake" "--" "vscode"
            PROJECT_SOURCE_DIR "${PROJECT_SOURCE_DIR}"
            PROJECT_BINARY_DIR "${PROJECT_BINARY_DIR}"

            MAIN_PYTHON_FILE "${MAIN_PYTHON_FILE}"
            MAIN_PY_DIR "${PROJECT_SOURCE_DIR}/src/main/py"

            TEST_PYTHON_FILE "${TEST_PYTHON_FILE}"
            TEST_PY_DIR "${PROJECT_SOURCE_DIR}/src/test/py"

            PYTEST_LOG_LEVEL "DEBUG"
            PYTEST_LOG_FORMAT "%(levelname).4s %(asctime)s.%(msecs)03d [%(threadName)s] (%(name)s:%(filename)s:%(lineno)d) [%(funcName)s]: %(message)s"
            PYTEST_LOG_DATE_FORMAT "%Y-%n-%d %H:%M:%S"
            PYTEST_LOG_FILE "${PROJECT_BINARY_DIR}/test/log/txt/log.txt"
            PYTEST_JUNIT_FILE "${PROJECT_BINARY_DIR}/test/report/xml/report.xml"

            SETTINGS_GENERATE "true"
            SETTINGS_TEMPLATE_FILE "${PROJECT_SOURCE_DIR}/src/test/resources/.vscode/settings.json"
            SETTINGS_FILE_OVERWRITE "true"

            LAUNCH_GENERATE "true"
            LAUNCH_TEMPLATE_FILE "${PROJECT_SOURCE_DIR}/src/test/resources/.vscode/launch.json"
            LAUNCH_FILE_OVERWRITE "true"
    DEPENDS "${MAIN_PYTHON_FILE}" "${TEST_PYTHON_FILE}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    VERBATIM
    USES_TERMINAL
)

add_custom_target("main-build"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-f" "${PROJECT_BINARY_DIR}/main/dist/*.whl"
    COMMAND "${MAIN_PYTHON_FILE}" "-m" "pip" "wheel" "--no-deps" "-w" "${PROJECT_BINARY_DIR}/main/dist" "."
    DEPENDS "${MAIN_PYTHON_FILE}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("main-build-app"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-rf" "${PROJECT_BINARY_DIR}/main/work"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-rf" "${PROJECT_BINARY_DIR}/main/dist/exqudens-pytest"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-f" "${PROJECT_SOURCE_DIR}/exqudens_pytest_spec.py"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-f" "${PROJECT_SOURCE_DIR}/exqudens-pytest.spec"
    COMMAND "${CMAKE_COMMAND}" "-E" "copy" "src/main/resources/spec/exqudens_pytest_spec.py" "${PROJECT_SOURCE_DIR}"
    COMMAND "${CMAKE_COMMAND}" "-E" "rename" "exqudens_pytest_spec.py" "exqudens-pytest.spec"
    COMMAND "${MAIN_PYTHON_FILE}" "-m" "PyInstaller" "--clean" "--workpath" "${PROJECT_BINARY_DIR}/main/work" "--distpath" "${PROJECT_BINARY_DIR}/main/dist" "${PROJECT_SOURCE_DIR}/exqudens-pytest.spec"
    DEPENDS "${MAIN_PYTHON_FILE}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

set("${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES"
    "${PROJECT_BINARY_DIR}/main"
    "${PROJECT_BINARY_DIR}/test"
    "${PROJECT_SOURCE_DIR}/exqudens_pytest_spec.py"
    "${PROJECT_SOURCE_DIR}/exqudens-pytest.spec"
)
set_directory_properties(PROPERTIES
    ADDITIONAL_CLEAN_FILES "${${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES}"
)
