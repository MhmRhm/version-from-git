# version-from-git
Bake git information into your binary.

## Objective
Consider the following C++ program:

```c
#include <iostream>
#include <format>

#include "gitversion.h"

int main()
{
	std::cout << std::format("Build Info: {}-{}-{}-{}",
        GIT_BRANCH, GIT_TAG, GIT_COMMIT, GIT_DATE) << std::endl;
	return 0;
}
```

The goal is to have a `gitversion.h` file which upon including gives us access to the branch, tag, commit and date information of the repository.

## A Recommendation
For this to work, it's recommended that the *build tree* resides outside of the *source tree* (**out of source build**.) To accomplish that using the command line:

```bash
mkdir ../build
cd ../build
```

Or if you are using the *QtCreator*, go to the *Projects* tab on the left-hand side of the IDE, choose the right *kit*, and on the build tab select the **Shadow build**.

And if you are using the *Microsoft Visual Studio*, right-click on `CMakeLists.txt` and choose *CMake Settings for...*, then change *Build root* to something like below:

```cmake
${projectDir}\..\build\${name}
```

If you go against this recommendation and put your build directory inside the source, every time you run the `cmake` or change project settings in your *IDE*, the `git status` may change and unwanted changes will be reflected in your binary.

## The CMakeLists File
The following is the content of the `CMakeLists.txt`:

```cmake
cmake_minimum_required(VERSION 3.20)

project(Tutorial)

# Where we get information from the git and put it into the gitversion.h file.
include(${PROJECT_SOURCE_DIR}/gitversion.cmake)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(Tutorial tutorial.cxx)

# Must include the build tree to get access to the gitversion.h file.
target_include_directories(Tutorial PUBLIC "${PROJECT_BINARY_DIR}")
```
## The .cmake File
This is where the bulk of the work happens:

```cmake
 # find_package(Git) -> finds the location of the git executable
 # git describe --always --abbrev=8 -> gives the abbreviated hash
 # git status --short -> checks for uncommitted  work
 # git describe --exact-match --tags -> gives the tag
 # git rev-parse --abbrev-ref HEAD -> gives current branch
 # git log -n 1 --pretty=%cd --pretty=%cI -> gives the time of the last commit
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

# replaces matching variabels in gitversion.h.in file and writes it to gitversion.h
configure_file(gitversion.h.in gitversion.h)
```

## The .in File
This file is actually a `.h` file that is loaded with cmake related variables to be replaced during `cmake` execution:

```c
#pragma once
#include<string_view>
const std::string_view GIT_COMMIT{ "@GIT_COMMIT@" };
const std::string_view GIT_TAG{ "@GIT_TAG@" };
const std::string_view GIT_BRANCH{ "@GIT_BRANCH@" };
const std::string_view GIT_DATE{ "@GIT_DATE@" };
```

## Last Step
Finally in our build directory run:

```bash
cmake ../Tutorial
cmake --build .
```
Make sure the `Tutorial` directory is initialized with `git`.

This solution is based on [Matt Keeter](https://www.mattkeeter.com/blog/2018-01-06-versioning/)'s work.