#include <iostream>
#include <format>

#include "gitversion.h"

int main()
{
    std::cout << std::format("Build Info: {}\n{}\n{}\n{}", FromGit::Branch, FromGit::Tag, FromGit::Commit, FromGit::Date) << std::endl;
    return 0;
}
