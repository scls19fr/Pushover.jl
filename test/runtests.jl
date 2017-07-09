using Pushover
using Base.Test
using Lint

@test isempty(lintpkg("Pushover"))

# write your own tests here
@test 1 == 1
