@testset "special functions" begin
    # The intention here is not to check the accuracy of the libraries,
    # rather the sanity of library calls:
    piq = Float128(pi)
    halfq = Float128(0.5)
    @test gamma(halfq) ≈ sqrt(piq)
    for func in (erf, erfc, 
                 besselj0, besselj1, 
                 bessely0, bessely1, lgamma)
        @test func(halfq) ≈ func(0.5)
    end
    for func in (bessely, besselj)
        @test func(3,halfq) ≈ func(3,0.5)
    end
end
