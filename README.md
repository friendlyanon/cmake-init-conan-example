# cmake-init + Conan

This is an example repository showcasing [Conan][1] integration with
[cmake-init][2] generated projects.

The list of changes to make when integrating with Conan:

* Add a [script](cmake/conan.cmake) that downloads [cmake-conan][3] and
  installs the project dependencies
* Add a `conan` preset to [`CMakePresets.json`](CMakePresets.json#L9)
* Inherit from the above preset in your [CI](CMakePresets.json#L57) and [dev
  presets](HACKING.md#L44)
* Mention in [`HACKING.md`](HACKING.md#L60) that the project uses Conan
* Mention in [`BUILDING.md`](BUILDING.md#L3) that the project provides a Conan
  script for its dependencies and it is one option to use
* Install Conan in the [CI](.github/workflows/ci.yml#L12-L16) workflow

Every other change in the repository was made just to make this repository more
focused on showing how to integrate with Conan, like removing unused presets
and trimming the CI workflow yaml.

[1]: https://conan.io/
[2]: https://github.com/friendlyanon/cmake-init
[3]: https://github.com/conan-io/cmake-conan
