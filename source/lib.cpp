#include <fmt/core.h>
#include <lib.hpp>

library::library()
    : name(fmt::format("{}", "conan-example"))
{
}
