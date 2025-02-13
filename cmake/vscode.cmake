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
        "SOURCE_DIR"
        "BINARY_DIR"

        "MAIN_PYTHON_COMMAND"
        "MAIN_PY_DIR"

        "TEST_PYTHON_COMMAND"
        "TEST_PY_DIR"

        "TEST_LOG_LEVEL"
        "TEST_LOG_FORMAT"
        "TEST_LOG_DATE_FORMAT"
        "TEST_LOG_FILE"
        "TEST_JUNIT_FILE"

        "SETTINGS_GENERATE"
        "SETTINGS_TEMPLATE_FILE"
        "SETTINGS_FILE"
        "SETTINGS_FILE_OVERWRITE"

        "LAUNCH_GENERATE"
        "LAUNCH_TEMPLATE_FILE"
        "LAUNCH_FILE"
        "LAUNCH_FILE_OVERWRITE"
        "LAUNCH_TEST_LIST_FILE"
    )
    set(multiValueKeywords)

    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        unset("_${v}")
    endforeach()

    cmake_parse_arguments("" "${options}" "${oneValueKeywords}" "${multiValueKeywords}" "${ARGN}")

    if(NOT "${_UNPARSED_ARGUMENTS}" STREQUAL "")
        message(FATAL_ERROR ": '${_UNPARSED_ARGUMENTS}'")
    endif()

    if("${_SOURCE_DIR}" STREQUAL "")
        cmake_path(GET "CMAKE_CURRENT_LIST_DIR" PARENT_PATH "_SOURCE_DIR")
    endif()

    if("${_BINARY_DIR}" STREQUAL "")
        set(_BINARY_DIR "${_SOURCE_DIR}/build")
    endif()

    if("${_MAIN_PYTHON_COMMAND}" STREQUAL "")
        if(EXISTS "${_BINARY_DIR}/main/env/Scripts/python.exe")
            set(_MAIN_PYTHON_COMMAND "${_BINARY_DIR}/main/env/Scripts/python.exe")
        else()
            set(_MAIN_PYTHON_COMMAND "${_BINARY_DIR}/main/env/bin/python")
        endif()
    endif()

    if("${_MAIN_PY_DIR}" STREQUAL "")
        set(_MAIN_PY_DIR "${_SOURCE_DIR}/src/main/py")
    endif()

    if("${_TEST_PYTHON_COMMAND}" STREQUAL "")
        if(EXISTS "${_BINARY_DIR}/test/env/Scripts/python.exe")
            set(_TEST_PYTHON_COMMAND "${_BINARY_DIR}/test/env/Scripts/python.exe")
        else()
            set(_TEST_PYTHON_COMMAND "${_BINARY_DIR}/test/env/bin/python")
        endif()
    endif()

    if("${_TEST_PY_DIR}" STREQUAL "")
        set(_TEST_PY_DIR "${_SOURCE_DIR}/src/test/py")
    endif()

    if("${_TEST_LOG_LEVEL}" STREQUAL "")
        set(_TEST_LOG_LEVEL "DEBUG")
    endif()

    if("${_TEST_LOG_FORMAT}" STREQUAL "")
        set(_TEST_LOG_FORMAT "%(levelname).4s %(asctime)s.%(msecs)03d [%(threadName)s] (%(name)s:%(filename)s:%(lineno)d) [%(funcName)s]: %(message)s")
    endif()

    if("${_TEST_LOG_DATE_FORMAT}" STREQUAL "")
        set(_TEST_LOG_DATE_FORMAT "%Y-%n-%d %H:%M:%S")
    endif()

    if("${_TEST_LOG_FILE}" STREQUAL "")
        set(_TEST_LOG_FILE "${_BINARY_DIR}/test/log/txt/log.txt")
    endif()

    if("${_TEST_JUNIT_FILE}" STREQUAL "")
        set(_TEST_JUNIT_FILE "${_BINARY_DIR}/test/report/xml/report.xml")
    endif()

    if("${_SETTINGS_GENERATE}" STREQUAL "")
        set(_SETTINGS_GENERATE "true")
    endif()

    if("${_SETTINGS_TEMPLATE_FILE}" STREQUAL "")
        set(_SETTINGS_TEMPLATE_FILE "${_SOURCE_DIR}/src/test/resources/vscode/settings.json")
    endif()

    if("${_SETTINGS_FILE}" STREQUAL "")
        set(_SETTINGS_FILE "${_SOURCE_DIR}/.vscode/settings.json")
    endif()

    if("${_SETTINGS_FILE_OVERWRITE}" STREQUAL "")
        set(_SETTINGS_FILE_OVERWRITE "true")
    endif()

    if("${_LAUNCH_GENERATE}" STREQUAL "")
        set(_LAUNCH_GENERATE "true")
    endif()

    if("${_LAUNCH_TEMPLATE_FILE}" STREQUAL "")
        set(_LAUNCH_TEMPLATE_FILE "${_SOURCE_DIR}/src/test/resources/vscode/launch.json")
    endif()

    if("${_LAUNCH_FILE}" STREQUAL "")
        set(_LAUNCH_FILE "${_SOURCE_DIR}/.vscode/launch.json")
    endif()

    if("${_LAUNCH_FILE_OVERWRITE}" STREQUAL "")
        set(_LAUNCH_FILE_OVERWRITE "true")
    endif()

    if("${_LAUNCH_TEST_LIST_FILE}" STREQUAL "")
        set(_LAUNCH_TEST_LIST_FILE "${_BINARY_DIR}/test/test-list.json")
    endif()

    message(STATUS "input:")
    foreach(v IN LISTS "options" "oneValueKeywords" "multiValueKeywords")
        message(STATUS "${v}: '${_${v}}'")
    endforeach()

    set(checkNotEmptyVarNames
        "TEST_LOG_LEVEL"
        "TEST_LOG_FORMAT"
        "TEST_LOG_DATE_FORMAT"
        "TEST_LOG_FILE"
        "TEST_JUNIT_FILE"

        "SETTINGS_GENERATE"
        "SETTINGS_FILE_OVERWRITE"
        "SETTINGS_FILE"

        "LAUNCH_GENERATE"
        "LAUNCH_FILE_OVERWRITE"
        "LAUNCH_FILE"
    )

    foreach(v IN LISTS "checkNotEmptyVarNames")
        if("${_${v}}" STREQUAL "")
            message(FATAL_ERROR "Empty ${v}: '${_${v}}'")
        endif()
    endforeach()

    set(checkExistsVarNames ${options} ${oneValueKeywords} ${multiValueKeywords})
    list(REMOVE_ITEM "checkExistsVarNames" ${checkNotEmptyVarNames})

    foreach(v IN LISTS "checkExistsVarNames")
        if(NOT EXISTS "${_${v}}")
            message(FATAL_ERROR "Not exists ${v}: '${_${v}}'")
        endif()
    endforeach()

    set("settings.python.defaultInterpreterPath" "${_TEST_PYTHON_COMMAND}")
    set("test.log-level" "${_TEST_LOG_LEVEL}")
    set("test.log-format" "${_TEST_LOG_FORMAT}")
    set("test.log-date-format" "${_TEST_LOG_DATE_FORMAT}")
    set("test.log-file" "${_TEST_LOG_FILE}")
    set("test.junit-file" "${_TEST_JUNIT_FILE}")
    cmake_path(RELATIVE_PATH "_TEST_PY_DIR" BASE_DIRECTORY "${_SOURCE_DIR}" OUTPUT_VARIABLE "test.dir-rel")

    set(pytestCollectItems "${test.dir-rel}")
    file(READ "${_LAUNCH_TEST_LIST_FILE}" jsonContent)
    string(JSON "maxIndex" LENGTH "${jsonContent}")
    if("${maxIndex}" GREATER "0")
        math(EXPR maxIndex "${maxIndex} - 1")
        foreach(i RANGE "0" "${maxIndex}")
            string(JSON v GET "${jsonContent}" "${i}" "nodeid")
            list(APPEND "pytestCollectItems" "${test.dir-rel}/${v}")
        endforeach()
    endif()

    list(GET "pytestCollectItems" "0" "test.default-entry")
    string(JOIN "\",\n                \"" "test.entries" ${pytestCollectItems})

    message(STATUS "substitutions:")
    message(STATUS "'@settings.python.defaultInterpreterPath@': '${settings.python.defaultInterpreterPath}'")
    message(STATUS "'@test.log-level@': '${test.log-level}'")
    message(STATUS "'@test.log-format@': '${test.log-format}'")
    message(STATUS "'@test.log-date-format@': '${test.log-date-format}'")
    message(STATUS "'@test.log-file@': '${test.log-file}'")
    message(STATUS "'@test.junit-file@': '${test.junit-file}'")
    message(STATUS "'@test.dir-rel@': '${test.dir-rel}'")
    message(STATUS "'@test.default-entry@': '${test.default-entry}'")
    message(STATUS "'@test.entries@': '${test.entries}'")

    if("${_SETTINGS_GENERATE}" AND (NOT EXISTS "${_SETTINGS_FILE}" OR "${_SETTINGS_FILE_OVERWRITE}"))
        message(STATUS "generate: '${_SETTINGS_FILE}' ...")
        configure_file("${_SETTINGS_TEMPLATE_FILE}" "${_SETTINGS_FILE}" @ONLY)
        message(STATUS "generate: '${_SETTINGS_FILE}' ... done")
    endif()

    if("${_LAUNCH_GENERATE}" AND (NOT EXISTS "${_LAUNCH_FILE}" OR "${_LAUNCH_FILE_OVERWRITE}"))
        message(STATUS "generate: '${_LAUNCH_FILE}' ...")
        configure_file("${_LAUNCH_TEMPLATE_FILE}" "${_LAUNCH_FILE}" @ONLY)
        message(STATUS "generate: '${_LAUNCH_FILE}' ... done")
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
