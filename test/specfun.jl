import .SpecialFunctions

@testset "special functions" begin
    # The intention here is not to check the accuracy of the libraries,
    # rather the sanity of library calls:
    piq = Float128(pi)
    halfq = Float128(0.5)
    @test SpecialFunctions.gamma(halfq) ≈ sqrt(piq)
    for func in (SpecialFunctions.erf, SpecialFunctions.erfc, 
                 SpecialFunctions.besselj0, SpecialFunctions.besselj1, 
                 SpecialFunctions.bessely0, SpecialFunctions.bessely1, SpecialFunctions.lgamma)
        @test func(halfq) ≈ func(0.5)
    end
    for func in (SpecialFunctions.bessely, SpecialFunctions.besselj)
        @test func(3,halfq) ≈ func(3,0.5)
    end
end
