#include <iostream>
#include <format>

#include "gitversion.h"

int main()
{
    std::cout << std::format("Build Info: {}\n{}\n{}\n{}", FromGit::BRANCH, FromGit::TAG, FromGit::COMMIT, FromGit::DATE) << std::endl;
    return 0;
}
