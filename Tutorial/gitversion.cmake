find_package(Git)
execute_process(COMMAND ${GIT_EXECUTABLE} describe --always --abbrev=8
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_COMMIT)
execute_process(COMMAND ${GIT_EXECUTABLE} status --short
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_STATUS)
if (("${GIT_COMMIT}" STREQUAL "") OR (NOT "${GIT_STATUS}" STREQUAL ""))
    set(GIT_COMMIT "N/A")
endif()
execute_process(COMMAND ${GIT_EXECUTABLE} describe --exact-match --tags
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_TAG
                ERROR_QUIET)
if ("${GIT_TAG}" STREQUAL "")
    set(GIT_TAG "N/A")
endif()

execute_process(COMMAND ${GIT_EXECUTABLE} rev-parse --abbrev-ref HEAD
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_BRANCH)
if ("${GIT_BRANCH}" STREQUAL "")
    set(GIT_BRANCH "N/A")
endif()

execute_process(COMMAND ${GIT_EXECUTABLE} log -n 1 --pretty=%cd --pretty=%cI
                WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_DATE)
if ("${GIT_DATE}" STREQUAL "")
    set(GIT_DATE "N/A")
endif()

string(STRIP "${GIT_COMMIT}" GIT_COMMIT)
string(STRIP "${GIT_TAG}" GIT_TAG)
string(STRIP "${GIT_BRANCH}" GIT_BRANCH)
string(STRIP "${GIT_DATE}" GIT_DATE)

configure_file(gitversion.h.in gitversion.h)