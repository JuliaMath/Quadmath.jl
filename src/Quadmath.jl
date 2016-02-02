# This file is modelled after https://github.com/JuliaLang/julia/blob/master/base/mpfr.jl
# which implements the BigFloat type

module Quadmath

export Float128, Complex256

import 
    Base: (*), +, -, /,  <, <=, ==, >, >=, ^, convert, promote_rule,
          string, print, show, showcompact, tryparse, 
          acos, acosh, asin, asinh, atan, atanh, cosh, cos,
          erf, erfc, expm1, log, log2, log10, sin, sinh, sqrt,
          tan, tanh, exp,
          besselj, besselj0, besselj1, bessely, bessely0, bessely1,
          ceil, floor, trunc, round, fma, 
          atan2, copysign, max, min, hypot,
          gamma, lgamma,
          abs, imag, real, conj, angle, cis,
          eps, realmin, realmax


import Base.GMP: ClongMax, CulongMax, CdoubleMax

bitstype 128 Float128 <: AbstractFloat 

typealias Complex256 Complex{Float128}

const libquadmath_wrapper = joinpath(dirname(@__FILE__),
                            "..", "deps", "usr", "lib", "libquadmath_wrapper.so")

widen(::Type{Float64}) = Float128
widen(::Type{Float128}) = BigFloat

convert(::Type{Float128}, x::Float128) = x

convert(::Type{Float128}, x::Clong) = 
            ccall((:convert_qsi, libquadmath_wrapper), Float128, ( Clong, ), x )
convert(::Type{Float128}, x::Culong) = 
            ccall((:convert_qui, libquadmath_wrapper), Float128, ( Culong, ), x )
convert(::Type{Float128}, x::Float64) = 
            ccall((:convert_qd, libquadmath_wrapper), Float128, ( Float64, ), x )

#convert(::Type{Float128}, x::Integer) = Float128(BigInt(x))

convert(::Type{Float128}, x::Union{Bool,Int8,Int16,Int32}) = Float128(convert(Clong,x))
convert(::Type{Float128}, x::Union{UInt8,UInt16,UInt32}) = Float128(convert(Culong,x))

convert(::Type{Float128}, x::Union{Float16,Float32}) = Float128(Float64(x))
convert(::Type{Float128}, x::Rational) = Float128(num(x)) / Float128(den(x))

## Float128 -> AbstractFloat
convert(::Type{Float64}, x::Float128) =
    ccall((:convert_dq,libquadmath_wrapper), Float64, (Float128,), x)
convert(::Type{Float32}, x::Float128) =
    ccall((:convert_fq,libquadmath_wrapper), Float32, (Float128,), x)

call(::Type{Float64}, x::Float128, r::RoundingMode) =
    ccall((:convert_dq,libquadmath_wrapper), Float64, (Float128,), x)
call(::Type{Float32}, x::Float128, r::RoundingMode) =
    ccall((:convert_fq,libquadmath_wrapper), Float32, (Float128,), x)
# TODO: avoid double rounding
call(::Type{Float16}, x::Float128, r::RoundingMode) =
    convert(Float16, call(Float32, x, r))

#promote_rule{T<:Real}(::Type{Float128}, ::Type{T}) = Float128
#promote_rule{T<:AbstractFloat}(::Type{Float128},::Type{T}) = Float128

promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
promote_rule(::Type{Float128}, ::Type{Float64}) = Float128

function tryparse(::Type{Float128}, s::AbstractString, base::Int=0)
    Nullable(ccall((:set_str_q, libquadmath_wrapper), Float128, (Cstring, ), s))
end

# Basic arithmetic without promotion
for (fJ, fC) in ((:+,:add), (:-,:sub), (:/,:div), (:*,:mul))

    #Float128
    if (fC!=(:mul)) # 1st part of mysterious hack to get multiplication work 
        @eval begin
            function ($fJ)(x::Float128, y::Float128)
               ccall(($(string(fC,:_q)),libquadmath_wrapper), Float128, (Float128, Float128), x, y)
            end
        end
    end    

    @eval begin

        #Unsigned Integer
        function ($fJ)(x::Float128, y::CulongMax)
            ccall(($(string(fC,:_qui)),libquadmath_wrapper), Float128, (Float128, Culong), x, y)
        end

        function ($fJ)(x::CulongMax, y::Float128)
            ccall(($(string(fC,:_uiq)),libquadmath_wrapper), Float128, (Culong, Float128), x, y)
        end

        #Signed Integer
        function ($fJ)(x::Float128, y::ClongMax)
            ccall(($(string(fC,:_qsi)),libquadmath_wrapper), Float128, (Float128, Clong), x, y)
        end

        function ($fJ)(x::ClongMax, y::Float128)
            ccall(($(string(fC,:_siq)),libquadmath_wrapper), Float128, (Clong, Float128), x, y)
        end

        # Float32, Float64
        function ($fJ)(x::Float128, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),libquadmath_wrapper), Float128, (Float128, Cdouble), x, y)
        end

        function ($fJ)(x::CdoubleMax, y::Float128,)
            ccall(($(string(fC,:_dq)),libquadmath_wrapper), Float128, (Cdouble, Float128), x, y)
        end
    end
end
# 2nd part of mysterious hack to get multiplication work 
# Defining * in this way works, very strange...
*(x::Float128, y::Float128) = ccall(("mul_q",libquadmath_wrapper), Float128, (Float128, Float128), x, y)

# Basic complex arithmetic without promotion
for (fJ, fC) in ((:+,:cadd), (:-,:csub), (:/,:cdiv), (:*,:cmul))
    @eval begin
        #Float128
        function ($fJ)(x::Complex256, y::Complex256)
            ccall(($(string(fC,:_q)),libquadmath_wrapper), Complex256, (Complex256, Complex256), x, y)
        end

        #Unsigned Integer
        function ($fJ)(x::Complex256, y::CulongMax)
            ccall(($(string(fC,:_qui)),libquadmath_wrapper), Complex256, (Complex256, Culong), x, y)
        end

        function ($fJ)(x::CulongMax, y::Complex256)
            ccall(($(string(fC,:_uiq)),libquadmath_wrapper), Complex256, (Culong, Complex256), x, y)
        end

        #Signed Integer
        function ($fJ)(x::Complex256, y::ClongMax)
            ccall(($(string(fC,:_qsi)),libquadmath_wrapper), Complex256, (Complex256, Clong), x, y)
        end

        function ($fJ)(x::ClongMax, y::Complex256)
            ccall(($(string(fC,:_siq)),libquadmath_wrapper), Complex256, (Clong, Complex256), x, y)
        end

        # Float32, Float64
        function ($fJ)(x::Complex256, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),libquadmath_wrapper), Complex256, (Complex256, Cdouble), x, y)
        end

        function ($fJ)(x::CdoubleMax, y::Complex256,)
            ccall(($(string(fC,:_dq)),libquadmath_wrapper), Complex256, (Cdouble, Complex256), x, y)
        end

        # Float128
        function ($fJ)(x::Complex256, y::Float128)
            ccall(($(string(fC,:_qD)),libquadmath_wrapper), Complex256, (Complex256, Float128), x, y)
        end

        function ($fJ)(x::Float128, y::Complex256,)
            ccall(($(string(fC,:_Dq)),libquadmath_wrapper), Complex256, (Float128, Complex256), x, y)
        end
        
    end
end

# comparisons
for (fJ, fC) in ((:<,:less), (:<=,:less_equal), (:(==),:equal), (:>=,:greater_equal), (:>,:greater))
    @eval begin
        #Float128
        function ($fJ)(x::Float128, y::Float128)
            ccall(($(string(fC,:_q)),libquadmath_wrapper), Cint, (Float128, Float128), x, y) != 0
        end 

        #Unsigned Integer
        function ($fJ)(x::Float128, y::CulongMax)
            ccall(($(string(fC,:_qui)),libquadmath_wrapper), Cint, (Float128, Culong), x, y) != 0
        end

        function ($fJ)(x::CulongMax, y::Float128)
            ccall(($(string(fC,:_uiq)),libquadmath_wrapper), Cint, (Culong, Float128), x, y) != 0
        end

        #Signed Integer
        function ($fJ)(x::Float128, y::ClongMax)
            ccall(($(string(fC,:_qsi)),libquadmath_wrapper), Cint, (Float128, Clong), x, y) != 0
        end

        function ($fJ)(x::ClongMax, y::Float128)
            ccall(($(string(fC,:_siq)),libquadmath_wrapper), Cint, (Clong, Float128), x, y) != 0
        end

        # Float32, Float64
        function ($fJ)(x::Float128, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),libquadmath_wrapper), Cint, (Float128, Cdouble), x, y) != 0
        end

        function ($fJ)(x::CdoubleMax, y::Float128,)
            ccall(($(string(fC,:_dq)),libquadmath_wrapper), Cint, (Cdouble, Float128), x, y) != 0
        end     
    end
end

function fma(x::Float128, y::Float128, z::Float128)
    ccall(("fma_q",libquadmath_wrapper), Float128, (Float128, Float128, Float128, ), x, y, z)
end

function -(x::Float128)
    ccall((:neg_q, libquadmath_wrapper), Float128, (Float128,), x)
end

function ^(x::Float128, y::Float128)
    ccall((:pow_q, libquadmath_wrapper), Float128, (Float128, Float128,), x, y)
end

# constants
eps(::Type{Float128}) = ccall(("eps_q", libquadmath_wrapper), Float128, (), )
realmin(::Type{Float128}) = ccall(("realmin_q", libquadmath_wrapper), Float128, (), )
realmax(::Type{Float128}) = ccall(("realmax_q", libquadmath_wrapper), Float128, (), )
convert(::Type{Float128}, ::Irrational{:π}) =  ccall(("pi_q", libquadmath_wrapper), Float128, (), )
convert(::Type{Float128}, ::Irrational{:e}) =  ccall(("e_q", libquadmath_wrapper), Float128, (), )

# unary functions
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :erf, :erfc, :exp, :expm1, :log, :log2, :log10, :sin, :sinh, :sqrt,
          :tan, :tanh, :besselj0, :besselj1, :bessely0, :bessely1, :abs, 
          :ceil, :floor, :trunc, :round, :gamma, :lgamma, ) 
    @eval function $f(x::Float128)
        ccall(($(string(f,:_q)), libquadmath_wrapper), Float128, (Float128, ), x)
    end
end
    
for f in (:atan2, :copysign,  :max, :min, :hypot,)
   @eval function $f(x::Float128, y::Float128)
        ccall(($(string(f,:_q)), libquadmath_wrapper), Float128, (Float128, Float128), x, y)
    end
end

for f in (:besselj, :bessely,)
    @eval function $f(n::Integer, x::Float128)
        ccall(($(string(f,:_q)), libquadmath_wrapper), Float128, (Cint, Float128), n, x)
    end
end

function -(x::Complex256)
    ccall((:cneg_q, libquadmath_wrapper), Complex256, (Complex256,), x)
end

function ^(x::Complex256, y::Complex256)
    ccall((:cpow_q, libquadmath_wrapper), Complex256, (Complex256, Complex256,), x, y)
end

# unary complex functions
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :exp, :log, :log10, :conj, :sin, :sinh, :sqrt,
          :tan, :tanh, ) 
    @eval function $f(x::Complex256)
        ccall(($(string(:c,f,:_q)), libquadmath_wrapper), Complex256, (Complex256, ), x)
    end
end

# unary complex functions with real result
for f in (:abs, :imag, :real, :angle )
    @eval function $f(x::Float128)
        ccall(($(string(:c,f,:_q)), libquadmath_wrapper), Float128, (Complex256, ), x)
    end
end

function cis(x::Float128)
    ccall((:ccis_q, libquadmath_wrapper), Complex256, (Float128,), x)
end

function string(x::Float128)
    lng = 64 
    buf = Array(UInt8, lng + 1)
    lng = ccall((:stringq,libquadmath_wrapper), Int32, (Ptr{UInt8}, Culong, Ptr{UInt8}, Float128,), buf, lng + 1, "%.35Qe", x)
    return bytestring(pointer(buf), lng)
end

print(io::IO, b::Float128) = print(io, string(b))
show(io::IO, b::Float128) = print(io, string(b))
showcompact(io::IO, b::Float128) = print(io, string(b))

const ROUNDING_MODE = Cint[0]

function convert(::Type{BigFloat}, x::Float128)
    z = BigFloat()
    res = ccall((:mpfr_set_float128_xxx, libquadmath_wrapper), Int32, (Ptr{BigFloat}, Float128, Int32), &z, x, ROUNDING_MODE[end])
    return z
end

convert(::Type{Float128}, x::BigFloat) =
    ccall((:mpfr_get_float128_xxx, libquadmath_wrapper), Float128, (Ptr{BigFloat},Int32), &x, ROUNDING_MODE[end])

end # modeule Quadmath
