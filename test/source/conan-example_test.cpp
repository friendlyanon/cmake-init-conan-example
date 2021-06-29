#include <doctest/doctest.h>
#include <lib.hpp>

TEST_CASE("lib")
{
  library lib;

  REQUIRE_EQ(lib.name, "conan-example");
}
