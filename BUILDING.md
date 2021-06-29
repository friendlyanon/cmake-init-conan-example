# Building with CMake

## Conan dependencies

This project uses Conan to install some dependencies, but it is optional to
use. You may also install those dependencies manually or using any other
package manager, however a script file is already provided to use Conan and
makes automatic dependency management easier.

If you have Conan set up, then you have to provide an extra flag to the
configure command, which differs only in how you provide the paths depending on
your OS:

```batch
rem Windows
-D "CMAKE_PROJECT_conan-example_INCLUDE=%cd:\=/%/cmake/conan.cmake"
```

```sh
# Unix based (Linux, macOS)
-D "CMAKE_PROJECT_conan-example_INCLUDE=$PWD/cmake/conan.cmake"
```

## Build

Besides the one for Conan dependencies (if you choose to provide them to the
project using Conan), this project doesn't require any special command-line
flags to build to keep things simple.

Here are the steps for building in release mode with a single-configuration
generator, like the Unix Makefiles one:

```sh
cmake -S . -B build -D CMAKE_BUILD_TYPE=Release # Conan flag
cmake --build build
```

Here are the steps for building in release mode with a multi-configuration
generator, like the Visual Studio ones:

```sh
cmake -S . -B build # Conan flag
cmake --build build --config Release
```

## Install

This project doesn't require any special command-line flags to install to keep
things simple. As a prerequisite, the project has to be built with the above
commands already.

The below commands require at least CMake 3.15 to run, because that is the
version in which [Install a Project][1] was added.

Here is the command for installing the release mode artifacts with a
single-configuration generator, like the Unix Makefiles one:

```sh
cmake --install build
```

Here is the command for installing the release mode artifacts with a
multi-configuration generator, like the Visual Studio ones:

```sh
cmake --install build --config Release
```

[1]: https://cmake.org/cmake/help/latest/manual/cmake.1.html#install-a-project
