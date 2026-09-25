module QuadmathRandomExt

using Quadmath, Random

function Random.rand(rng::AbstractRNG, s::Random.SamplerTrivial{Random.CloseOpen01{Float128}})
    u = rand(rng, UInt128)
    x = (reinterpret(Float128, u & Base.significand_mask(Float128)
                     | Base.exponent_one(Float128))
         - one(Float128))
    return x
end

end
