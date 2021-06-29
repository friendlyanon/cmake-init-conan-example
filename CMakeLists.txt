cmake_minimum_required(VERSION 3.14)

include(cmake/in-source-guard.cmake)

project(
    conan-example
    VERSION 0.1.0
    DESCRIPTION "Short description"
    HOMEPAGE_URL "https://example.com/"
    LANGUAGES CXX
)

include(cmake/project-is-top-level.cmake)
include(cmake/variables.cmake)

# ---- Declare library ----

add_library(
    conan-example_lib OBJECT
    source/lib.cpp
)

target_include_directories(
    conan-example_lib
    PUBLIC
    "$<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/source>"
)

target_compile_features(conan-example_lib PUBLIC cxx_std_17)

find_package(fmt REQUIRED)

target_link_libraries(conan-example_lib PRIVATE fmt::fmt)

# ---- Declare executable ----

add_executable(conan-example_conan-example source/main.cpp)
add_executable(conan-example::conan-example ALIAS conan-example_conan-example)

set_target_properties(
    conan-example_conan-example PROPERTIES
    OUTPUT_NAME conan-example
    EXPORT_NAME conan-example
)

target_compile_features(conan-example_conan-example PRIVATE cxx_std_17)

target_link_libraries(conan-example_conan-example PRIVATE conan-example_lib)

# ---- Install rules ----

include(cmake/install-rules.cmake)

# ---- Developer mode ----

if(NOT conan-example_DEVELOPER_MODE)
  return()
elseif(NOT PROJECT_IS_TOP_LEVEL)
  message(
      AUTHOR_WARNING
      "Developer mode is intended for developers of conan-example"
  )
endif()

include(CTest)
if(BUILD_TESTING)
  add_subdirectory(test)
endif()
