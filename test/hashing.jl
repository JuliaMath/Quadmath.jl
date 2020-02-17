# extend hashing tests from Julia Base to Float128

hashtypes = Any[
    Bool,
    Int8, UInt8, Int16, UInt16, Int32, UInt32, Int64, UInt64, Float32, Float64, Float128,
    Rational{Int8}, Rational{UInt8}, Rational{Int16}, Rational{UInt16},
    Rational{Int32}, Rational{UInt32}, Rational{Int64}, Rational{UInt64}
]
hashvals = vcat(
    typemin(Int64),
    -Int64(maxintfloat(Float64)) .+ Int64[-4:1;],
    typemin(Int32),
    -Integer(maxintfloat(Float32)) .+ (-4:1),
    -2:2,
    Integer(maxintfloat(Float32)) .+ (-1:4),
    typemax(Int32),
    Int64(maxintfloat(Float64)) .+ Int64[-1:4;],
    typemax(Int64),
)

function coerce(T::Type, x)
    if T<:Rational
        convert(T, coerce(typeof(numerator(zero(T))), x))
    elseif !(T<:Integer)
        convert(T, x)
    else
        x % T
    end
end

@testset "hash 0,1" begin
  for x = hashvals,
      a = coerce(Float128, x)
      @test hash(a,zero(UInt)) == invoke(hash, Tuple{Real, UInt}, a, zero(UInt))
      @test hash(a,one(UInt)) == invoke(hash, Tuple{Real, UInt}, a, one(UInt))
  end
end

@testset "hashing" begin
  for T = hashtypes,
    S = hashtypes,
    x = hashvals,
    a = coerce(T, x),
    b = coerce(S, x)
    T == Float128 || S == Float128 || continue # other types are not our problem
    #println("$(typeof(a)) $a")
    #println("$(typeof(b)) $b")
    @test isequal(a,b) == (hash(a)==hash(b))
  end
end
