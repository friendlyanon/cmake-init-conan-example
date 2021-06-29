# Parent project does not export its library target, so this CML implicitly
# depends on being added from it, i.e. the testing is done only from the build
# tree and is not feasible from an install location

project(conan-exampleTests LANGUAGES CXX)

find_package(doctest REQUIRED)
include(doctest)

add_executable(conan-example_test source/conan-example_test.cpp)
set_property(
    SOURCE source/conan-example_test.cpp APPEND PROPERTY
    COMPILE_DEFINITIONS DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
)
target_link_libraries(
    conan-example_test
    PRIVATE
    conan-example_lib
    doctest::doctest
)
target_compile_features(conan-example_test PRIVATE cxx_std_17)

doctest_discover_tests(conan-example_test ADD_LABELS NO)
