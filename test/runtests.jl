using Pushover
using Base.Test
using Lint

@testset "Pushover" begin
    @testset "tests" begin
        # write your own tests here
        @test 1 == 1
    end

    @testset "lint" begin
        @test isempty(lintpkg("Pushover"))
    end
end
