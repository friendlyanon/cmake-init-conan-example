# Parent project does not export its library target, so this CML implicitly
# depends on being added from it, i.e. the testing is done only from the build
# tree and is not feasible from an install location

project(conan-exampleTests LANGUAGES CXX)

# ---- Dependencies ----

find_package(Catch2 REQUIRED)
include(Catch)

# ---- Tests ----

add_executable(conan-example_test source/conan-example_test.cpp)
target_link_libraries(
    conan-example_test PRIVATE
    conan-example_lib
    Catch2::Catch2WithMain
)
target_compile_features(conan-example_test PRIVATE cxx_std_17)

catch_discover_tests(conan-example_test)

# ---- End-of-file commands ----

add_folders(Test)
