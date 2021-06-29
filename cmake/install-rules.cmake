if(PROJECT_IS_TOP_LEVEL)
  set(CMAKE_INSTALL_INCLUDEDIR include/conan-example CACHE PATH "")
endif()

include(CMakePackageConfigHelpers)
include(GNUInstallDirs)

# find_package(<package>) call for consumers to find this project
set(package conan-example)

install(
    TARGETS conan-example_conan-example
    EXPORT conan-exampleTargets
    RUNTIME COMPONENT conan-example_Runtime
)

write_basic_package_version_file(
    "${package}ConfigVersion.cmake"
    COMPATIBILITY SameMajorVersion
)

# Allow package maintainers to freely override the path for the configs
set(
    conan-example_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/${package}"
    CACHE STRING "CMake package config location relative to the install prefix"
)
mark_as_advanced(conan-example_INSTALL_CMAKEDIR)

install(
    FILES cmake/install-config.cmake
    DESTINATION "${conan-example_INSTALL_CMAKEDIR}"
    RENAME "${package}Config.cmake"
    COMPONENT conan-example_Development
)

install(
    FILES "${PROJECT_BINARY_DIR}/${package}ConfigVersion.cmake"
    DESTINATION "${conan-example_INSTALL_CMAKEDIR}"
    COMPONENT conan-example_Development
)

install(
    EXPORT conan-exampleTargets
    NAMESPACE conan-example::
    DESTINATION "${conan-example_INSTALL_CMAKEDIR}"
    COMPONENT conan-example_Development
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
