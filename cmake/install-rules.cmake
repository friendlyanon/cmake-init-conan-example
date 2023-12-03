install(
    TARGETS conan-example_exe
    RUNTIME COMPONENT conan-example_Runtime
)

if(PROJECT_IS_TOP_LEVEL)
  include(CPack)
endif()
