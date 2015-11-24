module float128

export Float128, Complex256

import 
    Base: +, -, (*), /, <, <=, ==, >, >=, ^, convert, promote_rule,
          string, print, show, showcompact, tryparse, 
          acos, acosh, asin, asinh, atan, atanh, cosh, cos,
          erf, erfc, expm1, log, log2, log10, sin, sinh, sqrt,
          tan, tanh, exp,
          besselj, besselj0, besselj1, bessely, bessely0, bessely1,
          ceil, floor, trunc, round, fma, 
          atan2, copysign, max, min, hypot,
          gamma, lgamma,
          abs, imag, real, conj


import Base.GMP: ClongMax, CulongMax, CdoubleMax

bitstype 128 Float128  <: AbstractFloat
#Note: with "<: AbstracFloat" multiplication of two Float128 numbers
#mysteriously doesn't work!

typealias Complex256 Complex{Float128}



convert(::Type{Float128}, x::Float128) = x

convert(::Type{Float128}, x::Clong) = 
            ccall((:convert_qsi, :libfloat128), Float128, ( Clong, ), x )
convert(::Type{Float128}, x::Culong) = 
            ccall((:convert_qui, :libfloat128), Float128, ( Culong, ), x )
convert(::Type{Float128}, x::Float64) = 
            ccall((:convert_qd, :libfloat128), Float128, ( Float64, ), x )

#convert(::Type{Float128}, x::Integer) = Float128(BigInt(x))

convert(::Type{Float128}, x::Union{Bool,Int8,Int16,Int32}) = Float128(convert(Clong,x))
convert(::Type{Float128}, x::Union{UInt8,UInt16,UInt32}) = Float128(convert(Culong,x))

convert(::Type{Float128}, x::Union{Float16,Float32}) = Float128(Float64(x))
convert(::Type{Float128}, x::Rational) = Float128(num(x)) / Float128(den(x))

## Float128 -> AbstractFloat
convert(::Type{Float64}, x::Float128) =
    ccall((:convert_dq,:libfloat128), Float64, (Float128,), x)
convert(::Type{Float32}, x::Float128) =
    ccall((:convert_fq,:libfloat128), Float32, (Float128,), x)

call(::Type{Float64}, x::Float128, r::RoundingMode) =
    ccall((:convert_dq,:libfloat128), Float64, (Float128,), x)
call(::Type{Float32}, x::Float128, r::RoundingMode) =
    ccall((:convert_fq,:libfloat128), Float32, (Float128,), x)
# TODO: avoid double rounding
call(::Type{Float16}, x::Float128, r::RoundingMode) =
    convert(Float16, call(Float32, x, r))


promote_rule{T<:Real}(::Type{Float128}, ::Type{T}) = Float128
promote_rule{T<:AbstractFloat}(::Type{Float128},::Type{T}) = Float128


function tryparse(::Type{Float128}, s::AbstractString, base::Int=0)
    Nullable(ccall((:set_str_q, :libfloat128), Float128, (Cstring, ), s))
end

    


# Basic arithmetic without promotion
for (fJ, fC) in ((:+,:add), (:-,:sub), (:/,:div), (:(*),:mul))
    @eval begin
        #Float128
        function ($fJ)(x::Float128, y::Float128)
            ccall(($(string(fC,:_q)),:libfloat128), Float128, (Float128, Float128), x, y)
        end

        #Unsigned Integer
        function ($fJ)(x::Float128, y::CulongMax)
            ccall(($(string(fC,:_qui)),:libfloat128), Float128, (Float128, Culong), x, y)
        end

        function ($fJ)(x::CulongMax, y::Float128)
            ccall(($(string(fC,:_uiq)),:libfloat128), Float128, (Culong, Float128), x, y)
        end

        #Signed Integer
        function ($fJ)(x::Float128, y::ClongMax)
            ccall(($(string(fC,:_qsi)),:libfloat128), Float128, (Float128, Clong), x, y)
        end

        function ($fJ)(x::ClongMax, y::Float128)
            ccall(($(string(fC,:_siq)),:libfloat128), Float128, (Clong, Float128), x, y)
        end

        # Float32, Float64
        function ($fJ)(x::Float128, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),:libfloat128), Float128, (Float128, Cdouble), x, y)
        end

        function ($fJ)(x::CdoubleMax, y::Float128,)
            ccall(($(string(fC,:_dq)),:libfloat128), Float128, (Cdouble, Float128), x, y)
        end
    end
end

# Basic complex arithmetic without promotion
for (fJ, fC) in ((:+,:cadd), (:-,:csub), (:/,:cdiv), (:(*),:cmul))
    @eval begin
        #Float128
        function ($fJ)(x::Complex256, y::Complex256)
            ccall(($(string(fC,:_q)),:libfloat128), Complex256, (Complex256, Complex256), x, y)
        end

        #Unsigned Integer
        function ($fJ)(x::Complex256, y::CulongMax)
            ccall(($(string(fC,:_qui)),:libfloat128), Complex256, (Complex256, Culong), x, y)
        end

        function ($fJ)(x::CulongMax, y::Complex256)
            ccall(($(string(fC,:_uiq)),:libfloat128), Complex256, (Culong, Complex256), x, y)
        end

        #Signed Integer
        function ($fJ)(x::Complex256, y::ClongMax)
            ccall(($(string(fC,:_qsi)),:libfloat128), Complex256, (Complex256, Clong), x, y)
        end

        function ($fJ)(x::ClongMax, y::Complex256)
            ccall(($(string(fC,:_siq)),:libfloat128), Complex256, (Clong, Complex256), x, y)
        end

        # Float32, Float64
        function ($fJ)(x::Complex256, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),:libfloat128), Complex256, (Complex256, Cdouble), x, y)
        end

        function ($fJ)(x::CdoubleMax, y::Complex256,)
            ccall(($(string(fC,:_dq)),:libfloat128), Complex256, (Cdouble, Complex256), x, y)
        end

        # Float128
        function ($fJ)(x::Complex256, y::Float128)
            ccall(($(string(fC,:_qD)),:libfloat128), Complex256, (Complex256, Float128), x, y)
        end

        function ($fJ)(x::Float128, y::Complex256,)
            ccall(($(string(fC,:_Dq)),:libfloat128), Complex256, (Float128, Complex256), x, y)
        end
        
    end
end




# comparisons
for (fJ, fC) in ((:<,:less), (:<=,:less_equal), (:(==),:equal), (:>=,:greater_equal), (:>,:greater))
    @eval begin
        #Float128
        function ($fJ)(x::Float128, y::Float128)
            ccall(($(string(fC,:_q)),:libfloat128), Cint, (Float128, Float128), x, y) != 0
        end 

        #Unsigned Integer
        function ($fJ)(x::Float128, y::CulongMax)
            ccall(($(string(fC,:_qui)),:libfloat128), Cint, (Float128, Culong), x, y) != 0
        end

        function ($fJ)(x::CulongMax, y::Float128)
            ccall(($(string(fC,:_uiq)),:libfloat128), Cint, (Culong, Float128), x, y) != 0
        end

        #Signed Integer
        function ($fJ)(x::Float128, y::ClongMax)
            ccall(($(string(fC,:_qsi)),:libfloat128), Cint, (Float128, Clong), x, y) != 0
        end

        function ($fJ)(x::ClongMax, y::Float128)
            ccall(($(string(fC,:_siq)),:libfloat128), Cint, (Clong, Float128), x, y) != 0
        end

        # Float32, Float64
        function ($fJ)(x::Float128, y::CdoubleMax)
            ccall(($(string(fC,:_qd)),:libfloat128), Cint, (Float128, Cdouble), x, y) != 0
        end

        function ($fJ)(x::CdoubleMax, y::Float128,)
            ccall(($(string(fC,:_dq)),:libfloat128), Cint, (Cdouble, Float128), x, y) != 0
        end     
    end
end


function fma(x::Float128, y::Float128, z::Float128)
    ccall(("fma_q",:libfloat128), Float128, (Float128, Float128, Float128, ), x, y, z)
end


function -(x::Float128)
    ccall((:neg_q, :libfloat128), Float128, (Float128,), x)
end

function ^(x::Float128, y::Float128)
    ccall((:pow_q, :libfloat128), Float128, (Float128, Float128,), x, y)
end


# unary functions
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :erf, :erfc, :exp, :expm1, :log, :log2, :log10, :sin, :sinh, :sqrt,
          :tan, :tanh, :besselj0, :besselj1, :bessely0, :bessely1, :abs, 
          :ceil, :floor, :trunc, :round, :gamma, :lgamma, ) 
    @eval function $f(x::Float128)
        ccall(($(string(f,:_q)), :libfloat128), Float128, (Float128, ), x)
    end
end
    
for f in (:atan2, :copysign,  :max, :min, :hypot,)
   @eval function $f(x::Float128, y::Float128)
        ccall(($(string(f,:_q)), :libfloat128), Float128, (Float128, Float128), x, y)
    end
end


function -(x::Complex256)
    ccall((:cneg_q, :libfloat128), Complex256, (Complex256,), x)
end

function ^(x::Complex256, y::Complex256)
    ccall((:cpow_q, :libfloat128), Complex256, (Complex256, Complex256,), x, y)
end

# unary complex functions
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :exp, :log, :log10, :conj, :sin, :sinh, :sqrt,
          :tan, :tanh, ) 
    @eval function $f(x::Complex256)
        ccall(($(string(:c,f,:_q)), :libfloat128), Complex256, (Complex256, ), x)
    end
end

# unary complex functions with real result
for f in (:abs, :imag, :real, )
    @eval function $f(x::Float128)
        ccall(($(string(:c,f,:_q)), :libfloat128), Float128, (Complex256, ), x)
    end
end

# arg, expi, proj


function string(x::Float128)
    lng = 64 
    buf = Array(UInt8, lng + 1)
    lng = ccall((:stringq,:libfloat128), Int32, (Ptr{UInt8}, Culong, Ptr{UInt8}, Float128,), buf, lng + 1, "%.33Qe", x)
    return bytestring(pointer(buf), lng)
end

print(io::IO, b::Float128) = print(io, string(b))
show(io::IO, b::Float128) = print(io, string(b))
showcompact(io::IO, b::Float128) = print(io, string(b))

end
