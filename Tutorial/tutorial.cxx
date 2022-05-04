#include <iostream>
#include <format>

#include "gitversion.h"

int main()
{
	std::cout << std::format("Build Info: {}\n{}\n{}\n{}", GIT_BRANCH, GIT_TAG, GIT_COMMIT, GIT_DATE) << std::endl;
	return 0;
}
