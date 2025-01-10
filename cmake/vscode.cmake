cmake_minimum_required(VERSION "3.25" FATAL_ERROR)

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(PUSH)
    cmake_policy(SET CMP0007 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0010 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0012 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0054 NEW)
    cmake_policy(PUSH)
    cmake_policy(SET CMP0057 NEW)
endif()

function(vscode)
    set(options)
    set(oneValueKeywords
        "PROJECT_SOURCE_DIR"
        "PROJECT_BINARY_DIR"

        "MAIN_PYTHON_FILE"
        "MAIN_PY_DIR"

        "TEST_PYTHON_FILE"
        "TEST_PY_DIR"

        "PYTEST_LOG_LEVEL"
        "PYTEST_LOG_FORMAT"
        "PYTEST_LOG_DATE_FORMAT"
        "PYTEST_LOG_FILE"
        "PYTEST_JUNIT_FILE"

        "SETTINGS_GENERATE"
        "SETTINGS_TEMPLATE_FILE"
        "SETTINGS_FILE"
        "SETTINGS_FILE_OVERWRITE"

        "LAUNCH_GENERATE"
        "LAUNCH_TEMPLATE_FILE"
        "LAUNCH_FILE"
        "LAUNCH_FILE_OVERWRITE"
    )
    set(multiValueKeywords)

    cmake_parse_arguments("${CMAKE_CURRENT_FUNCTION}" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${${CMAKE_CURRENT_FUNCTION}_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR "Unparsed arguments: '${${CMAKE_CURRENT_FUNCTION}_UNPARSED_ARGUMENTS}'")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PROJECT_SOURCE_DIR}" STREQUAL "")
        message(FATAL_ERROR "'PROJECT_SOURCE_DIR' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_PROJECT_SOURCE_DIR}")
            message(FATAL_ERROR "not exists 'PROJECT_SOURCE_DIR': '${${CMAKE_CURRENT_FUNCTION}_PROJECT_SOURCE_DIR}'")
        endif()
        set(projectSourceDir "${${CMAKE_CURRENT_FUNCTION}_PROJECT_SOURCE_DIR}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PROJECT_BINARY_DIR}" STREQUAL "")
        message(FATAL_ERROR "'PROJECT_BINARY_DIR' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_PROJECT_BINARY_DIR}")
            message(FATAL_ERROR "not exists 'PROJECT_BINARY_DIR': '${${CMAKE_CURRENT_FUNCTION}_PROJECT_BINARY_DIR}'")
        endif()
        set(projectBinaryDir "${${CMAKE_CURRENT_FUNCTION}_PROJECT_BINARY_DIR}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_MAIN_PYTHON_FILE}" STREQUAL "")
        message(FATAL_ERROR "'MAIN_PYTHON_FILE' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_MAIN_PYTHON_FILE}")
            message(FATAL_ERROR "not exists 'MAIN_PYTHON_FILE': '${${CMAKE_CURRENT_FUNCTION}_MAIN_PYTHON_FILE}'")
        endif()
        set(mainPythonFile "${${CMAKE_CURRENT_FUNCTION}_MAIN_PYTHON_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_MAIN_PY_DIR}" STREQUAL "")
        message(FATAL_ERROR "'MAIN_PY_DIR' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_MAIN_PY_DIR}")
            message(FATAL_ERROR "not exists 'MAIN_PY_DIR': '${${CMAKE_CURRENT_FUNCTION}_MAIN_PY_DIR}'")
        endif()
        set(mainPyDir "${${CMAKE_CURRENT_FUNCTION}_MAIN_PY_DIR}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_TEST_PYTHON_FILE}" STREQUAL "")
        message(FATAL_ERROR "'TEST_PYTHON_FILE' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_TEST_PYTHON_FILE}")
            message(FATAL_ERROR "not exists 'TEST_PYTHON_FILE': '${${CMAKE_CURRENT_FUNCTION}_TEST_PYTHON_FILE}'")
        endif()
        set(testPythonFile "${${CMAKE_CURRENT_FUNCTION}_TEST_PYTHON_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_TEST_PY_DIR}" STREQUAL "")
        message(FATAL_ERROR "'TEST_PY_DIR' is empty")
    else()
        if(NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_TEST_PY_DIR}")
            message(FATAL_ERROR "not exists 'TEST_PY_DIR': '${${CMAKE_CURRENT_FUNCTION}_TEST_PY_DIR}'")
        endif()
        set(testPyDir "${${CMAKE_CURRENT_FUNCTION}_TEST_PY_DIR}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_LEVEL}" STREQUAL "")
        message(FATAL_ERROR "'PYTEST_LOG_LEVEL' is empty")
    else()
        set(pytestLogLevel "${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_LEVEL}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_FORMAT}" STREQUAL "")
        message(FATAL_ERROR "'PYTEST_LOG_FORMAT' is empty")
    else()
        set(pytestLogFormat "${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_FORMAT}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_DATE_FORMAT}" STREQUAL "")
        message(FATAL_ERROR "'PYTEST_LOG_DATE_FORMAT' is empty")
    else()
        set(pytestLogDateFormat "${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_DATE_FORMAT}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_FILE}" STREQUAL "")
        message(FATAL_ERROR "'PYTEST_LOG_FILE' is empty")
    else()
        set(pytestLogFile "${${CMAKE_CURRENT_FUNCTION}_PYTEST_LOG_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_PYTEST_JUNIT_FILE}" STREQUAL "")
        message(FATAL_ERROR "'PYTEST_JUNIT_FILE' is empty")
    else()
        set(pytestJunitFile "${${CMAKE_CURRENT_FUNCTION}_PYTEST_JUNIT_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_SETTINGS_GENERATE}" STREQUAL "")
        set(settingsGenerate "false")
    else()
        set(settingsGenerate "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_GENERATE}")
    endif()

    if("${settingsGenerate}" AND "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_TEMPLATE_FILE}" STREQUAL "")
        message(FATAL_ERROR "'SETTINGS_TEMPLATE_FILE' is empty")
    else()
        if("${settingsGenerate}" AND NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_TEMPLATE_FILE}")
            message(FATAL_ERROR "not exists 'SETTINGS_TEMPLATE_FILE': '${${CMAKE_CURRENT_FUNCTION}_SETTINGS_TEMPLATE_FILE}'")
        endif()
        set(settingsTemplateFile "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_TEMPLATE_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_SETTINGS_FILE}" STREQUAL "")
        set(settingsFile "${projectSourceDir}/.vscode/settings.json")
    else()
        set(settingsFile "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_SETTINGS_FILE_OVERWRITE}" STREQUAL "")
        set(settingsFileOverwrite "false")
    else()
        set(settingsFileOverwrite "${${CMAKE_CURRENT_FUNCTION}_SETTINGS_FILE_OVERWRITE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_LAUNCH_GENERATE}" STREQUAL "")
        set(launchGenerate "false")
    else()
        set(launchGenerate "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_GENERATE}")
    endif()

    if("${launchGenerate}" AND "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_TEMPLATE_FILE}" STREQUAL "")
        message(FATAL_ERROR "'LAUNCH_TEMPLATE_FILE' is empty")
    else()
        if("${launchGenerate}" AND NOT EXISTS "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_TEMPLATE_FILE}")
            message(FATAL_ERROR "not exists 'LAUNCH_TEMPLATE_FILE': '${${CMAKE_CURRENT_FUNCTION}_LAUNCH_TEMPLATE_FILE}'")
        endif()
        set(launchTemplateFile "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_TEMPLATE_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_LAUNCH_FILE}" STREQUAL "")
        set(launchFile "${projectSourceDir}/.vscode/launch.json")
    else()
        set(launchFile "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_FILE}")
    endif()

    if("${${CMAKE_CURRENT_FUNCTION}_LAUNCH_FILE_OVERWRITE}" STREQUAL "")
        set(launchFileOverwrite "false")
    else()
        set(launchFileOverwrite "${${CMAKE_CURRENT_FUNCTION}_LAUNCH_FILE_OVERWRITE}")
    endif()

    message(STATUS "==================================================")
    message(STATUS "resolved variables")
    message(STATUS "==================================================")
    message(STATUS "projectSourceDir: '${projectSourceDir}'")
    message(STATUS "projectBinaryDir: '${projectBinaryDir}'")
    message(STATUS "mainPythonFile: '${mainPythonFile}'")
    message(STATUS "mainPyDir: '${mainPyDir}'")
    message(STATUS "testPythonFile: '${testPythonFile}'")
    message(STATUS "testPyDir: '${testPyDir}'")
    message(STATUS "pytestLogLevel: '${pytestLogLevel}'")
    message(STATUS "pytestLogFormat: '${pytestLogFormat}'")
    message(STATUS "pytestLogDateFormat: '${pytestLogDateFormat}'")
    message(STATUS "pytestLogFile: '${pytestLogFile}'")
    message(STATUS "pytestJunitFile: '${pytestJunitFile}'")
    message(STATUS "settingsGenerate: '${settingsGenerate}'")
    message(STATUS "settingsTemplateFile: '${settingsTemplateFile}'")
    message(STATUS "settingsFile: '${settingsFile}'")
    message(STATUS "settingsFileOverwrite: '${settingsFileOverwrite}'")
    message(STATUS "launchGenerate: '${launchGenerate}'")
    message(STATUS "launchTemplateFile: '${launchTemplateFile}'")
    message(STATUS "launchFile: '${launchFile}'")
    message(STATUS "launchFileOverwrite: '${launchFileOverwrite}'")

    cmake_path(RELATIVE_PATH "testPythonFile" BASE_DIRECTORY "${projectSourceDir}" OUTPUT_VARIABLE "testPythonFileRel")
    set("settings.python.defaultInterpreterPath" "\${workspaceFolder}/${testPythonFileRel}") # "\${command:python.interpreterPath}"

    cmake_path(RELATIVE_PATH "mainPythonFile" BASE_DIRECTORY "${projectSourceDir}" OUTPUT_VARIABLE "mainPythonFileRel")
    set("launch.configurations.main.python" "\${workspaceFolder}/${mainPythonFileRel}")

    cmake_path(RELATIVE_PATH "testPythonFile" BASE_DIRECTORY "${projectSourceDir}" OUTPUT_VARIABLE "testPythonFileRel")
    set("launch.configurations.test.python" "\${workspaceFolder}/${testPythonFileRel}")

    set("launch.configurations.pytest.log-level" "${pytestLogLevel}")
    set("launch.configurations.pytest.log-format" "${pytestLogFormat}")
    set("launch.configurations.pytest.log-date-format" "${pytestLogDateFormat}")

    cmake_path(RELATIVE_PATH "pytestLogFile" BASE_DIRECTORY "${projectSourceDir}" OUTPUT_VARIABLE "pytestLogFileRel")
    set("launch.configurations.pytest.log-file" "\${workspaceFolder}/${pytestLogFileRel}")

    cmake_path(RELATIVE_PATH "pytestJunitFile" BASE_DIRECTORY "${projectSourceDir}" OUTPUT_VARIABLE "pytestJunitFileRel")
    set("launch.configurations.pytest.junit-xml" "\${workspaceFolder}/${pytestJunitFileRel}")

    if(EXISTS "${projectBinaryDir}/test/tests.json")
        file(REMOVE "${projectBinaryDir}/test/tests.json")
    endif()

    execute_process(
        COMMAND "${testPythonFile}" "-m" "pytest" "-q" "--co" "--rootdir=${testPyDir}" "--conftest-collect-file=${projectBinaryDir}/test/tests.json" "${testPyDir}"
        WORKING_DIRECTORY "${projectSourceDir}"
        COMMAND_ECHO "STDOUT"
        COMMAND_ERROR_IS_FATAL "ANY"
    )

    if(NOT EXISTS "${projectBinaryDir}/test/tests.json")
        message(FATAL_ERROR "not exists: '${projectBinaryDir}/test/tests.json'")
    endif()

    set("launch.inputs.default" "${testPyDir}")

    set(pytestCollectItems "${testPyDir}")
    file(READ "${projectBinaryDir}/test/tests.json" json_content)
    string(JSON "maxIndex" LENGTH "${json_content}")
    if("${maxIndex}" GREATER "0")
        math(EXPR maxIndex "${maxIndex} - 1")
        foreach(i RANGE "0" "${maxIndex}")
            string(JSON v GET "${json_content}" "${i}" "nodeid")
            list(APPEND "pytestCollectItems" "${testPyDir}/${v}")
        endforeach()
    endif()
    string(JOIN "\",\n                \"" "pytestCollectItems" ${pytestCollectItems})
    message(STATUS "pytestCollectItems: '${pytestCollectItems}'")

    file(REMOVE "${projectBinaryDir}/test/tests.json")

    set("launch.inputs.pytest.collect.items" "${pytestCollectItems}")

    message(STATUS "==================================================")
    message(STATUS "substitutions")
    message(STATUS "==================================================")
    message(STATUS "'@settings.python.defaultInterpreterPath@': '${settings.python.defaultInterpreterPath}'")
    message(STATUS "'@launch.configurations.main.python@': '${launch.configurations.main.python}'")
    message(STATUS "'@launch.configurations.test.python@': '${launch.configurations.test.python}'")
    message(STATUS "'@launch.configurations.pytest.log-level@': '${launch.configurations.pytest.log-level}'")
    message(STATUS "'@launch.configurations.pytest.log-format@': '${launch.configurations.pytest.log-format}'")
    message(STATUS "'@launch.configurations.pytest.log-date-format@': '${launch.configurations.pytest.log-date-format}'")
    message(STATUS "'@launch.configurations.pytest.log-file@': '${launch.configurations.pytest.log-file}'")
    message(STATUS "'@launch.configurations.pytest.junit-xml@': '${launch.configurations.pytest.junit-xml}'")
    message(STATUS "'@launch.inputs.default@': '${launch.inputs.default}'")
    message(STATUS "'@launch.inputs.pytest.collect.items@': '${launch.inputs.pytest.collect.items}'")
    message(STATUS "==================================================")

    if("${settingsGenerate}" AND (NOT EXISTS "${settingsFile}" OR "${settingsFileOverwrite}"))
        message(STATUS "generate: '${settingsFile}' ...")
        configure_file("${settingsTemplateFile}" "${settingsFile}" @ONLY NEWLINE_STYLE "LF")
        message(STATUS "generate: '${settingsFile}' ... done")
    endif()

    if("${launchGenerate}" AND (NOT EXISTS "${launchFile}" OR "${launchFileOverwrite}"))
        message(STATUS "generate: '${launchFile}' ...")
        configure_file("${launchTemplateFile}" "${launchFile}" @ONLY NEWLINE_STYLE "LF")
        message(STATUS "generate: '${launchFile}' ... done")
    endif()
endfunction()

block()
    if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
        set(args)
        set(argsStarted "FALSE")
        math(EXPR argIndexMax "${CMAKE_ARGC} - 1")

        foreach(i RANGE "0" "${argIndexMax}")
            if("${argsStarted}")
                list(APPEND args "${CMAKE_ARGV${i}}")
            elseif(NOT "${argsStarted}" AND "${CMAKE_ARGV${i}}" STREQUAL "--")
                set(argsStarted "TRUE")
            endif()
        endforeach()

        set(noEscapeBackslashOption "--no-escape-backslash")

        if("${args}" STREQUAL "")
            cmake_path(GET CMAKE_CURRENT_LIST_FILE FILENAME fileName)
            message(FATAL_ERROR "Usage: cmake -P ${fileName} -- [${noEscapeBackslashOption}] function_name args...")
        endif()

        list(POP_FRONT args firstArg)
        set(escapeBackslash "TRUE")

        if("${firstArg}" STREQUAL "${noEscapeBackslashOption}")
            set(escapeBackslash "FALSE")
            list(POP_FRONT args func)
        else()
            set(func "${firstArg}")
        endif()

        set(wrappedArgs "")

        if(NOT "${args}" STREQUAL "")
            foreach(arg IN LISTS args)
                set(wrappedArg "${arg}")
                string(FIND "${wrappedArg}" " " firstIndexOfSpace)

                if(NOT "${firstIndexOfSpace}" EQUAL "-1")
                    set(wrappedArg "\"${wrappedArg}\"")
                endif()

                if("${escapeBackslash}")
                    string(REPLACE "\\" "\\\\" wrappedArg "${wrappedArg}")
                endif()

                if("${wrappedArgs}" STREQUAL "")
                    string(APPEND wrappedArgs "${wrappedArg}")
                else()
                    string(APPEND wrappedArgs " ${wrappedArg}")
                endif()
            endforeach()
        endif()

        cmake_language(EVAL CODE "${func}(${wrappedArgs})")
    endif()
endblock()

if(NOT "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "" AND "${CMAKE_SCRIPT_MODE_FILE}" STREQUAL "${CMAKE_CURRENT_LIST_FILE}")
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
    cmake_policy(POP)
endif()
