__precompile__()
module Quadmath

export Float128, Complex256

import Base: (*), +, -, /,  <, <=, ==, ^, convert,
          reinterpret, sign_mask, exponent_mask, exponent_one, exponent_half,
          significand_mask,
          promote_rule, widen,
          string, print, show, showcompact, parse,
          acos, acosh, asin, asinh, atan, atanh, cosh, cos,
          erf, erfc, exp, expm1, log, log2, log10, log1p, sin, sinh, sqrt,
          tan, tanh,
          besselj, besselj0, besselj1, bessely, bessely0, bessely1,
          ceil, floor, trunc, round, fma, 
          atan2, copysign, max, min, hypot,
          gamma, lgamma,
          abs, imag, real, conj, angle, cis,
          eps, realmin, realmax, isinf, isnan, isfinite

if is_apple()
    const quadoplib = "libquadmath.0"
    const libquadmath = "libquadmath.0"
elseif is_unix()
    const quadoplib = "libgcc_s"
    const libquadmath = "libquadmath.so.0"
elseif is_windows()
    const quadoplib = "libgcc_s_seh-1.dll"
    const libquadmath = "libquadmath-0.dll"
end

import Base.Float128
typealias Cfloat128 Float128
typealias Complex256 Complex{Float128}

sign_mask(::Type{Float128}) =        0x8000_0000_0000_0000_0000_0000_0000_0000
exponent_mask(::Type{Float128}) =    0x7fff_0000_0000_0000_0000_0000_0000_0000
exponent_one(::Type{Float128}) =     0x3fff_0000_0000_0000_0000_0000_0000_0000
exponent_half(::Type{Float128}) =    0x3ffe_0000_0000_0000_0000_0000_0000_0000
significand_mask(::Type{Float128}) = 0x0000_ffff_ffff_ffff_ffff_ffff_ffff_ffff

fpinttype(::Type{Float128}) = UInt128

# conversion

## Float64
convert(::Type{Float128}, x::Float64) =
    Float128(ccall((:__extenddftf2, quadoplib), Cfloat128, (Cdouble,), x))
convert(::Type{Float64}, x::Float128) =
    ccall((:__trunctfdf2, quadoplib), Cdouble, (Cfloat128,), x)

convert(::Type{Int32}, x::Float128) =
    ccall((:__fixtfsi, quadoplib), Int32, (Cfloat128,), x)
convert(::Type{Float128}, x::Int32) =
    Float128(ccall((:__floatsitf, quadoplib), Cfloat128, (Int32,), x))

convert(::Type{Float128}, x::UInt32) =
    Float128(ccall((:__floatunsitf, quadoplib), Cfloat128, (UInt32,), x))

convert(::Type{Int64}, x::Float128) =
    ccall((:__fixtfdi, quadoplib), Int64, (Cfloat128,), x)
convert(::Type{Float128}, x::Int64) =
    Float128(ccall((:__floatditf, quadoplib), Cfloat128, (Int64,), x))


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

# math

## one argument
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :erf, :erfc, :exp, :expm1, :log, :log2, :log10, :log1p,
          :sin, :sinh, :sqrt, :tan, :tanh, 
          :ceil, :floor, :trunc, :lgamma, ) 
    @eval function $f(x::Float128)
        Float128(ccall(($(string(f,:q)), libquadmath), Cfloat128, (Cfloat128, ), x))
    end
end
for (f,fc) in (:abs => :fabs,
               :round => :rint,
               :gamma => :tgamma,              
               :besselj0 => :j0,
               :besselj1 => :j1,
               :bessely0 => :y0,
               :bessely1 => :y1,)
    @eval function $f(x::Float128)
        Float128(ccall(($(string(fc,:q)), libquadmath), Cfloat128, (Cfloat128, ), x))
    end
end

## two argument
for f in (:atan2, :copysign, :hypot, )
    @eval function $f(x::Float128, y::Float128)
       Float128(ccall(($(string(f,:q)), libquadmath), Cfloat128, (Cfloat128, Cfloat128), x, y))
    end
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

besselj(n::Cint, x::Float128) =
       Float128(ccall((:jnq, libquadmath), Cfloat128, (Cint, Cfloat128), n, x))
bessely(n::Cint, x::Float128) =
       Float128(ccall((:ynq, libquadmath), Cfloat128, (Cint, Cfloat128), n, x))




ldexp(x::Float128, n::Cint) =
    Float128(ccall((:ldexpq, libquadmath), Cfloat128, (Cfloat128, Cint), x, n))
ldexp(x::Float128, n::Integer) =
    ldexp(x, clamp(n, typemin(Cint), typemax(Cint)) % Cint)

function frexp(x::Float128)
    r = Ref{Cint}()
    Float128(ccall((:frexpq, libquadmath), Cfloat128, (Cfloat128, Ptr{Cint}), x, r))
    return x, Int(r[])
end
    
    


promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
promote_rule(::Type{Float128}, ::Type{Float64}) = Float128

#widen(::Type{Float64}) = Float128
widen(::Type{Float128}) = BigFloat

# TODO: need to do this better
function parse(::Type{Float128}, s::AbstractString)
    Float128(ccall((:strtoflt128, libquadmath), Cfloat128, (Cstring, Ptr{Ptr{Cchar}}), s, C_NULL))
end

function string(x::Float128)
    lng = 64 
    buf = Array(UInt8, lng + 1)
    lng = ccall((:quadmath_snprintf,libquadmath), Cint, (Ptr{UInt8}, Csize_t, Ptr{UInt8}, Cfloat128...), buf, lng + 1, "%.35Qe", x)
    return unsafe_string(pointer(buf), lng)
end

print(io::IO, b::Float128) = print(io, string(b))
show(io::IO, b::Float128) = print(io, string(b))
showcompact(io::IO, b::Float128) = print(io, string(b))

end # modeule Quadmath
