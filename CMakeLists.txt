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
message(STATUS "PROJECT_NAME: '${PROJECT_NAME}'")
message(STATUS "PROJECT_VERSION: '${PROJECT_VERSION}'")
message(STATUS "PROJECT_SOURCE_DIR: '${PROJECT_SOURCE_DIR}'")
message(STATUS "PROJECT_BINARY_DIR: '${PROJECT_BINARY_DIR}'")

string(REPLACE "-" "_" WHL_FILE_NAME "${PROJECT_NAME}")
set(WHL_FILE_NAME "${WHL_FILE_NAME}-${PROJECT_VERSION}-py3-none-any.whl")
message(STATUS "WHL_FILE_NAME: '${WHL_FILE_NAME}'")

set(EXECUTABLE_FILE_NAME "${PROJECT_NAME}")
if("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
    set(EXECUTABLE_FILE_NAME "${EXECUTABLE_FILE_NAME}.exe")
endif()
message(STATUS "EXECUTABLE_FILE_NAME: '${EXECUTABLE_FILE_NAME}'")

find_program(PYTHON_COMMAND NAMES "py.exe" "python" PATHS ENV PYTHON_PATH ENV PATH REQUIRED NO_CACHE NO_DEFAULT_PATH)
message(STATUS "PYTHON_COMMAND: '${PYTHON_COMMAND}'")

set(MAIN_PYTHON_COMMAND "${PROJECT_BINARY_DIR}/${MAIN_ENV_REL_PATH}/${PYTHON_ENV_REL_PATH}")
set(TEST_PYTHON_COMMAND "${PROJECT_BINARY_DIR}/${TEST_ENV_REL_PATH}/${PYTHON_ENV_REL_PATH}")

message(STATUS "MAIN_PYTHON_COMMAND: '${MAIN_PYTHON_COMMAND}'")
message(STATUS "TEST_PYTHON_COMMAND: '${TEST_PYTHON_COMMAND}'")

add_custom_command(
    OUTPUT "${MAIN_PYTHON_COMMAND}"
    COMMAND "${PYTHON_COMMAND}" "-m" "venv" "--copies" "${PROJECT_BINARY_DIR}/${MAIN_ENV_REL_PATH}"
    COMMAND "${MAIN_PYTHON_COMMAND}" "-m" "pip" "install" ".[app]"
    COMMAND "${MAIN_PYTHON_COMMAND}" "-m" "pip" "uninstall" "-y" "${PROJECT_NAME}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("main-env"
    DEPENDS "${MAIN_PYTHON_COMMAND}"
)

add_custom_command(
    OUTPUT "${PROJECT_BINARY_DIR}/main/dist/${WHL_FILE_NAME}"
    COMMAND "${MAIN_PYTHON_COMMAND}" "-m" "pip" "wheel" "--no-deps" "-w" "${PROJECT_BINARY_DIR}/main/dist" "."
    DEPENDS "${MAIN_PYTHON_COMMAND}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("main-build"
    DEPENDS "${PROJECT_BINARY_DIR}/main/dist/${WHL_FILE_NAME}"
)

add_custom_command(
    OUTPUT "${PROJECT_BINARY_DIR}/main/dist/${PROJECT_NAME}/${EXECUTABLE_FILE_NAME}"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-rf" "${PROJECT_BINARY_DIR}/main/work"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-rf" "${PROJECT_BINARY_DIR}/main/dist/${PROJECT_NAME}"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-f" "${PROJECT_SOURCE_DIR}/exqudens_pytest_spec.py"
    COMMAND "${CMAKE_COMMAND}" "-E" "rm" "-f" "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.spec"
    COMMAND "${CMAKE_COMMAND}" "-E" "copy" "src/main/resources/spec/exqudens_pytest_spec.py" "${PROJECT_SOURCE_DIR}"
    COMMAND "${CMAKE_COMMAND}" "-E" "rename" "exqudens_pytest_spec.py" "${PROJECT_NAME}.spec"
    COMMAND "${MAIN_PYTHON_COMMAND}" "-m" "PyInstaller" "--clean" "--workpath" "${PROJECT_BINARY_DIR}/main/work" "--distpath" "${PROJECT_BINARY_DIR}/main/dist" "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.spec"
    DEPENDS "${MAIN_PYTHON_COMMAND}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("main-build-app"
    DEPENDS "${PROJECT_BINARY_DIR}/main/dist/${PROJECT_NAME}/${EXECUTABLE_FILE_NAME}"
)

add_custom_command(
    OUTPUT "${TEST_PYTHON_COMMAND}"
    COMMAND "${PYTHON_COMMAND}" "-m" "venv" "--copies" "${PROJECT_BINARY_DIR}/${TEST_ENV_REL_PATH}"
    COMMAND "${TEST_PYTHON_COMMAND}" "-m" "pip" "install" ".[test]"
    COMMAND "${TEST_PYTHON_COMMAND}" "-m" "pip" "uninstall" "-y" "${PROJECT_NAME}"
    COMMAND "${TEST_PYTHON_COMMAND}" "-m" "pip" "install" "--force-reinstall" "${PROJECT_BINARY_DIR}/main/dist/${WHL_FILE_NAME}"
    COMMAND "${TEST_PYTHON_COMMAND}" "-m" "pytest" "--rootdir=src/test/py" "--conftest-collect-file=${PROJECT_BINARY_DIR}/test/test-list.json" "-q" "--co" "src/test/py"
    DEPENDS "${PROJECT_BINARY_DIR}/main/dist/${WHL_FILE_NAME}"
            "${PROJECT_BINARY_DIR}/main/dist/${PROJECT_NAME}/${EXECUTABLE_FILE_NAME}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    USES_TERMINAL
    VERBATIM
)

add_custom_target("test-env"
    DEPENDS "${TEST_PYTHON_COMMAND}"
)

add_custom_target("vscode"
    COMMAND "${CMAKE_COMMAND}" "-P" "${PROJECT_SOURCE_DIR}/cmake/vscode.cmake" "--" "vscode"
            #SOURCE_DIR "${PROJECT_SOURCE_DIR}"
            #BINARY_DIR "${PROJECT_BINARY_DIR}"

            #MAIN_PYTHON_COMMAND "${MAIN_PYTHON_COMMAND}"
            #MAIN_PY_DIR "${PROJECT_SOURCE_DIR}/src/main/py"

            #TEST_PYTHON_COMMAND "${TEST_PYTHON_COMMAND}"
            #TEST_PY_DIR "${PROJECT_SOURCE_DIR}/src/test/py"

            #TEST_LOG_LEVEL "DEBUG"
            #TEST_LOG_FORMAT "%(levelname).4s %(asctime)s.%(msecs)03d [%(threadName)s] (%(name)s:%(filename)s:%(lineno)d) [%(funcName)s]: %(message)s"
            #TEST_LOG_DATE_FORMAT "%Y-%n-%d %H:%M:%S"
            #TEST_LOG_FILE "${PROJECT_BINARY_DIR}/test/log/txt/log.txt"
            #TEST_JUNIT_FILE "${PROJECT_BINARY_DIR}/test/report/xml/report.xml"

            #SETTINGS_GENERATE "true"
            #SETTINGS_TEMPLATE_FILE "${PROJECT_SOURCE_DIR}/src/test/resources/vscode/settings.json"
            #SETTINGS_FILE "${PROJECT_SOURCE_DIR}/.vscode/settings.json"
            #SETTINGS_FILE_OVERWRITE "true"

            #LAUNCH_GENERATE "true"
            #LAUNCH_TEMPLATE_FILE "${PROJECT_SOURCE_DIR}/src/test/resources/vscode/launch.json"
            #LAUNCH_FILE "${PROJECT_SOURCE_DIR}/.vscode/launch.json"
            #LAUNCH_FILE_OVERWRITE "true"
            #LAUNCH_TEST_LIST_FILE "${PROJECT_BINARY_DIR}/test/test-list.json"
    DEPENDS "${TEST_PYTHON_COMMAND}"
    WORKING_DIRECTORY "${PROJECT_SOURCE_DIR}"
    VERBATIM
    USES_TERMINAL
)

set("${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES"
    "${PROJECT_BINARY_DIR}/main"
    "${PROJECT_BINARY_DIR}/test"
    "${PROJECT_SOURCE_DIR}/exqudens_pytest_spec.py"
    "${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.spec"
)
set_directory_properties(PROPERTIES
    ADDITIONAL_CLEAN_FILES "${${PROJECT_NAME}_ADDITIONAL_CLEAN_FILES}"
)
