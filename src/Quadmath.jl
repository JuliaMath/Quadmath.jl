__precompile__()
module Quadmath
using Requires

export Float128, ComplexF128

import Base: (*), +, -, /,  <, <=, ==, ^, convert,
          reinterpret, sign_mask, exponent_mask, exponent_one, exponent_half,
          significand_mask,
          promote_rule, widen,
          string, print, show, parse,
          acos, acosh, asin, asinh, atan, atanh, cosh, cos,
          exp, expm1, log, log2, log10, log1p, sin, sinh, sqrt,
          tan, tanh,
          ceil, floor, trunc, round, fma,
          copysign, max, min, hypot,
          abs, imag, real, conj, angle, cis,
          eps, isinf, isnan, isfinite,
          Int32,Int64,Float64

if Sys.isapple()
    const quadoplib = "libquadmath.0"
    const libquadmath = "libquadmath.0"
elseif Sys.isunix()
    const quadoplib = "libgcc_s.so.1"
    const libquadmath = "libquadmath.so.0"
elseif Sys.iswindows()
    const quadoplib = "libgcc_s_seh-1.dll"
    const libquadmath = "libquadmath-0.dll"
end

@static if Sys.isunix()
    # we use this slightly cumbersome definition to ensure that the value is passed
    # on the xmm registers, matching the x86_64 ABI for __float128.
    const Cfloat128 = NTuple{2,VecElement{Float64}}

    struct Float128 <: AbstractFloat
        data::Cfloat128
    end
    convert(::Type{Float128}, x::Number) = Float128(x)

    const ComplexF128 = Complex{Float128}

    Base.cconvert(::Type{Cfloat128}, x::Float128) = x.data


    # reinterpret
    function reinterpret(::Type{UInt128}, x::Float128)
        hi = reinterpret(UInt64, x.data[2].value)
        lo = reinterpret(UInt64, x.data[1].value)
        UInt128(hi) << 64 | lo
    end
    function reinterpret(::Type{Float128}, x::UInt128)
        fhi = reinterpret(Float64, (x >> 64) % UInt64)
        flo = reinterpret(Float64, x % UInt64)
        Float128((VecElement(flo), VecElement(fhi)))
    end
    reinterpret(::Type{Unsigned}, x::Float128) = reinterpret(UInt128, x)

    reinterpret(::Type{Int128}, x::Float128) =
        reinterpret(Int128, reinterpret(UInt128, x))
    reinterpret(::Type{Float128}, x::Int128) =
        reinterpret(Float128, reinterpret(UInt128, x))

elseif Sys.iswindows()
    primitive type Float128 <: AbstractFloat 128
    end
    const Cfloat128 = Float128
end

function __init__()
    @require SpecialFunctions="276daf66-3868-5448-9aa4-cd146d93841b" begin
        using SpecialFunctions

        SpecialFunctions.erf(x::Float128) = Float128(ccall((:erfq, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.erfc(x::Float128) = Float128(ccall((:erfcq, libquadmath), Cfloat128, (Cfloat128, ), x))

        SpecialFunctions.besselj0(x::Float128) = Float128(ccall((:j0q, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.besselj1(x::Float128) = Float128(ccall((:j1q, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.bessely0(x::Float128) = Float128(ccall((:y0q, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.bessely1(x::Float128) = Float128(ccall((:y1q, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.besselj(n::Cint, x::Float128) = Float128(ccall((:jnq, libquadmath), Cfloat128, (Cint, Cfloat128), n, x))
        SpecialFunctions.bessely(n::Cint, x::Float128) = Float128(ccall((:ynq, libquadmath), Cfloat128, (Cint, Cfloat128), n, x))

        SpecialFunctions.gamma(x::Float128) = Float128(ccall((:tgammaq, libquadmath), Cfloat128, (Cfloat128, ), x))
        SpecialFunctions.lgamma(x::Float128) = Float128(ccall((:lgammaq, libquadmath), Cfloat128, (Cfloat128, ), x))
    end
end


sign_mask(::Type{Float128}) =        0x8000_0000_0000_0000_0000_0000_0000_0000
exponent_mask(::Type{Float128}) =    0x7fff_0000_0000_0000_0000_0000_0000_0000
exponent_one(::Type{Float128}) =     0x3fff_0000_0000_0000_0000_0000_0000_0000
exponent_half(::Type{Float128}) =    0x3ffe_0000_0000_0000_0000_0000_0000_0000
significand_mask(::Type{Float128}) = 0x0000_ffff_ffff_ffff_ffff_ffff_ffff_ffff

fpinttype(::Type{Float128}) = UInt128

# conversion
Float128(x::Float128) = x

## Float64
Float128(x::Float64) =
    Float128(ccall((:__extenddftf2, quadoplib), Cfloat128, (Cdouble,), x))
Float64(x::Float128) =
    ccall((:__trunctfdf2, quadoplib), Cdouble, (Cfloat128,), x)

Int32(x::Float128) =
    ccall((:__fixtfsi, quadoplib), Int32, (Cfloat128,), x)
Float128(x::Int32) =
    Float128(ccall((:__floatsitf, quadoplib), Cfloat128, (Int32,), x))

Float128(x::UInt32) =
    Float128(ccall((:__floatunsitf, quadoplib), Cfloat128, (UInt32,), x))

Int64(x::Float128) =
    ccall((:__fixtfdi, quadoplib), Int64, (Cfloat128,), x)
Float128(x::Int64) =
    Float128(ccall((:__floatditf, quadoplib), Cfloat128, (Int64,), x))

Float128(x::Rational{T}) where T = Float128(numerator(x))/Float128(denominator(x))

# comparison

(==)(x::Float128, y::Float128) =
    ccall((:__eqtf2,quadoplib), Cint, (Cfloat128,Cfloat128), x, y) == 0

(<)(x::Float128, y::Float128) =
    ccall((:__letf2,quadoplib), Cint, (Cfloat128,Cfloat128), x, y) == -1

(<=)(x::Float128, y::Float128) =
    ccall((:__letf2,quadoplib), Cint, (Cfloat128,Cfloat128), x, y) <= 0

# arithmetic

(+)(x::Float128, y::Float128) =
    Float128(ccall((:__addtf3,quadoplib), Cfloat128, (Cfloat128,Cfloat128), x, y))
(-)(x::Float128, y::Float128) =
    Float128(ccall((:__subtf3,quadoplib), Cfloat128, (Cfloat128,Cfloat128), x, y))
(*)(x::Float128, y::Float128) =
    Float128(ccall((:__multf3,quadoplib), Cfloat128, (Cfloat128,Cfloat128), x, y))
(/)(x::Float128, y::Float128) =
    Float128(ccall((:__divtf3,quadoplib), Cfloat128, (Cfloat128,Cfloat128), x, y))
(-)(x::Float128) =
    Float128(ccall((:__negtf2,quadoplib), Cfloat128, (Cfloat128,), x))
(^)(x::Float128, y::Float128) =
    Float128(ccall((:powq, libquadmath), Cfloat128, (Cfloat128,Cfloat128), x, y))
# math

## one argument
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :erf, :erfc, :exp, :expm1, :log, :log2, :log10, :log1p,
          :sin, :sinh, :sqrt, :tan, :tanh,
          :ceil, :floor, :trunc, )
    @eval function $f(x::Float128)
        Float128(ccall(($(string(f,:q)), libquadmath), Cfloat128, (Cfloat128, ), x))
    end
end
for (f,fc) in (:abs => :fabs,
               :round => :rint,)
    @eval function $f(x::Float128)
        Float128(ccall(($(string(fc,:q)), libquadmath), Cfloat128, (Cfloat128, ), x))
    end
end

## two argument
for f in (:copysign, :hypot, )
    @eval function $f(x::Float128, y::Float128)
       Float128(ccall(($(string(f,:q)), libquadmath), Cfloat128, (Cfloat128, Cfloat128), x, y))
    end
end

function atan(x::Float128, y::Float128)
    Float128(ccall((:atan2q, libquadmath), Cfloat128, (Cfloat128, Cfloat128), x, y))
end

## misc
fma(x::Float128, y::Float128, z::Float128) =
    Float128(ccall((:fmaq,libquadmath), Cfloat128, (Cfloat128, Cfloat128, Cfloat128), x, y, z))

isnan(x::Float128) =
    0 != ccall((:isnanq,libquadmath), Cint, (Cfloat128, ), x)
isinf(x::Float128) =
    0 != ccall((:isinfq,libquadmath), Cint, (Cfloat128, ), x)
isfinite(x::Float128) =
    0 != ccall((:finiteq,libquadmath), Cint, (Cfloat128, ), x)

eps(::Type{Float128}) = reinterpret(Float128, 0x3f8f0000000000000000000000000000)
realmin(::Type{Float128}) = reinterpret(Float128, 0x00010000000000000000000000000000)
realmax(::Type{Float128}) = reinterpret(Float128, 0x7ffeffffffffffffffffffffffffffff)
Float128(::Irrational{:π}) =  reinterpret(Float128, 0x4000921fb54442d18469898cc51701b8)
Float128(::Irrational{:e}) =  reinterpret(Float128, 0x40005bf0a8b1457695355fb8ac404e7a)


ldexp(x::Float128, n::Cint) =
    Float128(ccall((:ldexpq, libquadmath), Cfloat128, (Cfloat128, Cint), x, n))
ldexp(x::Float128, n::Integer) =
    ldexp(x, clamp(n, typemin(Cint), typemax(Cint)) % Cint)

function frexp(x::Float128)
    r = Ref{Cint}()
    Float128(ccall((:frexpq, libquadmath), Cfloat128, (Cfloat128, Ptr{Cint}), x, r))
    return x, Int(r[])
end

promote_rule(::Type{Float128}, ::Type{Float16}) = Float128
promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
promote_rule(::Type{Float128}, ::Type{Float64}) = Float128
promote_rule(::Type{Float128}, ::Type{<:Integer}) = Float128

#widen(::Type{Float64}) = Float128
widen(::Type{Float128}) = BigFloat

# TODO: need to do this better
function parse(::Type{Float128}, s::AbstractString)
    Float128(ccall((:strtoflt128, libquadmath), Cfloat128, (Cstring, Ptr{Ptr{Cchar}}), s, C_NULL))
end

function string(x::Float128)
    lng = 64
    buf = Array{UInt8}(undef, lng + 1)
    lng = ccall((:quadmath_snprintf,libquadmath), Cint, (Ptr{UInt8}, Csize_t, Ptr{UInt8}, Cfloat128...), buf, lng + 1, "%.35Qe", x)
    return String(resize!(buf, lng))
end

print(io::IO, b::Float128) = print(io, string(b))
show(io::IO, b::Float128) = print(io, string(b))

end # modeule Quadmath
