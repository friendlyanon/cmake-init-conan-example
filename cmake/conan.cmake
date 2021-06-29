# ---- Fetch cmake-conan ----

set(conan_cmake_path "${PROJECT_BINARY_DIR}/_conan/conan.cmake")
set(conan_cmake_prefix "${PROJECT_BINARY_DIR}/_conan/configs")
set(conan_cmake_url "https://raw.githubusercontent.com/conan-io/cmake-conan/\
v0.16.1/conan.cmake")
if(NOT EXISTS "${conan_cmake_path}")
  file(
      DOWNLOAD "${conan_cmake_url}" "${conan_cmake_path}"
      EXPECTED_HASH
      SHA256=396e16d0f5eabdc6a14afddbcfff62a54a7ee75c6da23f32f7a31bc85db23484
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

# The loop variable is called CMAKE_BUILD_TYPE, because
# conan_cmake_autodetect() does not honor the BUILD_TYPE argument and when the
# generator is multi-config, then there is no point in setting that variable,
# but this command tries to read it regardless
foreach(CMAKE_BUILD_TYPE IN LISTS CONAN_CMAKE_BUILD_TYPES)
  conan_cmake_autodetect(conan_cmake_settings)

  conan_cmake_install(
      PATH_OR_REFERENCE .
      INSTALL_FOLDER "${conan_cmake_prefix}"
      BUILD missing
      SETTINGS ${conan_cmake_settings}
  )
endforeach()
unset(CMAKE_BUILD_TYPE)

# ---- Make Conan installed dependencies available ----

set(cmake_prefix_paths "$CACHE{CMAKE_PREFIX_PATH}")
if(NOT conan_cmake_prefix IN_LIST cmake_prefix_paths)
  list(APPEND cmake_prefix_paths "${conan_cmake_prefix}")
  set(CMAKE_PREFIX_PATH "${cmake_prefix_paths}" CACHE STRING "" FORCE)
endif()
