# ---- Fetch cmake-conan ----

set(conan_cmake_path "${PROJECT_BINARY_DIR}/_conan/conan.cmake")
set(conan_cmake_prefix "${PROJECT_BINARY_DIR}/_conan/configs")
# v0.16.1 is missing a feature that enabled conan_cmake_autodetect() to receive
# the BUILD_TYPE argument, so instead of using that version, grab a version
# from the develop branch that has this feature. This should eventually be
# switched to v0.17.0. See https://github.com/conan-io/cmake-conan/issues/336
set(conan_cmake_url "https://raw.githubusercontent.com/conan-io/cmake-conan/\
3b17ecedade832ea0cd6a73654399ea03341297d/conan.cmake")
if(NOT EXISTS "${conan_cmake_path}")
  file(
      DOWNLOAD "${conan_cmake_url}" "${conan_cmake_path}"
      EXPECTED_HASH
      SHA256=ddf0fafacf48b5c4912ecce5701c252532437c40277734cad5f4a8084470adbc
      TLS_VERIFY ON
      STATUS status
  )
  if(NOT status MATCHES "^0;")
    message(FATAL_ERROR "file(DOWNLOAD) returned with ${status}")
  endif()
endif()

# ---- Install dependencies via Conan ----

include("${conan_cmake_path}")

# CMakeDeps was added in 1.33
conan_check(VERSION 1.33 REQUIRED)

set(initial_build_type "$CACHE{CMAKE_BUILD_TYPE}")
get_cmake_property(is_multi_config GENERATOR_IS_MULTI_CONFIG)
if(is_multi_config)
  set(initial_build_type Release)
endif()

set(
    CONAN_CMAKE_BUILD_TYPES "${initial_build_type}"
    CACHE STRING "List of build types to invoke Conan with"
)
if(CONAN_CMAKE_BUILD_TYPES STREQUAL "")
  message(FATAL_ERROR "CONAN_CMAKE_BUILD_TYPES is empty")
endif()

set(conan_requires fmt/8.0.0)
if(conan-example_DEVELOPER_MODE)
  list(APPEND conan_requires doctest/2.4.6)
endif()

conan_cmake_configure(GENERATORS CMakeDeps REQUIRES ${conan_requires})

foreach(type IN LISTS CONAN_CMAKE_BUILD_TYPES)
  conan_cmake_autodetect(conan_cmake_settings BUILD_TYPE "${type}")

  conan_cmake_install(
      PATH_OR_REFERENCE .
      INSTALL_FOLDER "${conan_cmake_prefix}"
      BUILD missing
      SETTINGS ${conan_cmake_settings}
  )
endforeach()

# ---- Make Conan installed dependencies available ----

set(cache_prefix_paths "$CACHE{CMAKE_PREFIX_PATH}")
if(NOT conan_cmake_prefix IN_LIST cache_prefix_paths)
  list(APPEND cache_prefix_paths "${conan_cmake_prefix}")
  set(CMAKE_PREFIX_PATH "${cache_prefix_paths}" CACHE STRING "" FORCE)
endif()
