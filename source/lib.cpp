#include "lib.hpp"

#include <fmt/core.h>

library::library()
    : name {fmt::format("{}", "conan-example")}
{
}
