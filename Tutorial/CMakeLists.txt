cmake_minimum_required(VERSION 3.20)

project(Tutorial)

include(${PROJECT_SOURCE_DIR}/gitversion.cmake)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)

add_executable(Tutorial tutorial.cxx)
target_include_directories(Tutorial PUBLIC "${PROJECT_BINARY_DIR}")
