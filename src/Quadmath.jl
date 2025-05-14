module Quadmath
using Compat: @assume_effects

export Float128, ComplexF128, Inf128

import Base: (*), +, -, /,  <, <=, ==, ^, convert,
          reinterpret, sign_mask, exponent_mask, exponent_one, exponent_half,
          significand_mask, significand_bits, exponent_bits, exponent_bias,
          exponent_max, exponent_raw_max, uinttype, inttype, floattype,
          exponent, significand,
          promote_rule, widen,
          string, print, show, parse,
          acos, acosh, asin, asinh, atan, atanh, cosh, cos, sincos,
          exp, expm1, log, log2, log10, log1p, sin, sinh, sqrt,
          tan, tanh,
          ceil, floor, trunc, round, fma, decompose,
          copysign, flipsign, max, min, hypot, abs,
          ldexp, frexp, modf, nextfloat, typemax, typemin, eps,
          isinf, isnan, isfinite, isinteger,
          floatmin, floatmax, precision, signbit, maxintfloat,
          Int32, Int64, Float16, Float32, Float64, BigFloat, BigInt

using Random

if Sys.isapple()
    if Sys.ARCH == :x86_64
        const quadoplib = "libgcc_s.1.dylib"
    elseif Sys.ARCH == :aarch64
        const quadoplib = "libgcc_s.1.1.dylib"
    end
    const libquadmath = "libquadmath.0"
elseif Sys.isunix()
    const quadoplib = "libgcc_s.so.1"
    const libquadmath = "libquadmath.so.0"
elseif Sys.iswindows()
    if Sys.WORD_SIZE == 64
        const quadoplib = "libgcc_s_seh-1.dll"
    else
        const quadoplib = "libgcc_s_sjlj-1.dll"
    end
    const libquadmath = "libquadmath-0.dll"
end

macro quad_ccall(expr)
    @assert expr isa Expr && expr.head == :(::)
    ret_type = expr.args[2]

    expr_call = expr.args[1]
    @assert expr_call isa Expr && expr_call.head == :call

    expr_fname = expr_call.args[1]

    if expr_fname isa Symbol
        fname = QuoteNode(expr_fname)
    elseif expr_fname isa Expr && expr_fname.head == :.
        fname = :(($(expr_fname.args[2]), $(esc(expr_fname.args[1]))))
    end

    expr_args = expr_call.args[2:end]

    @assert all(ex isa Expr && ex.head == :(::) for ex in expr_args)

    arg_names = [ex.args[1] for ex in expr_args]
    arg_types = [ex.args[2] for ex in expr_args]

    if Sys.isunix()
        :(ccall($fname, $(esc(ret_type)), ($(esc.(arg_types)...),), $(esc.(arg_names)...)))
    else
        if ret_type == :Cfloat128
            quote
                r = Ref{Cfloat128}()
                ccall($fname, Cvoid, (Ref{Cfloat128}, $(esc.(arg_types)...),), r, $(esc.(arg_names)...))
                r[]
            end
        else
            :(ccall($fname, $(esc(ret_type)), ($(esc.(arg_types)...),), $(esc.(arg_names)...)))
        end
    end
end

# we use this slightly cumbersome definition to ensure that the value is 128-bit aligned
# and passed on the xmm registers, matching the x86_64 ABI for __float128.
const Cfloat128 = NTuple{2,VecElement{Float64}}

primitive type Float128 <: AbstractFloat 128 end
Float128(data::Cfloat128) = reinterpret(Float128, data)

convert(::Type{Float128}, x::Number) = Float128(x)

const ComplexF128 = Complex{Float128}

Base.cconvert(::Type{Cfloat128}, x::Float128) = reinterpret(Cfloat128, x)
Base.cconvert(::Type{Ref{Cfloat128}}, x::Float128) = Ref(Cfloat128(x))

# reinterpret
reinterpret(::Type{Unsigned}, x::Float128) = reinterpret(UInt128, x)
reinterpret(::Type{Signed}, x::Float128) = reinterpret(Int128, x)

sign_mask(::Type{Float128}) =        0x8000_0000_0000_0000_0000_0000_0000_0000
exponent_mask(::Type{Float128}) =    0x7fff_0000_0000_0000_0000_0000_0000_0000
exponent_one(::Type{Float128}) =     0x3fff_0000_0000_0000_0000_0000_0000_0000
exponent_half(::Type{Float128}) =    0x3ffe_0000_0000_0000_0000_0000_0000_0000
significand_mask(::Type{Float128}) = 0x0000_ffff_ffff_ffff_ffff_ffff_ffff_ffff

significand_bits(::Type{Float128}) = 112
exponent_bits(::Type{Float128}) = 15
exponent_bias(::Type{Float128}) = 16383
exponent_max(::Type{Float128}) = 16383
exponent_raw_max(::Type{Float128}) = 32767

uinttype(::Type{Float128}) = UInt128
inttype(::Type{Float128}) = Int128
# TODO: Logically speaking, we should also make the following definitions,
# but this would constitute type piracy under Aqua.jl rules.
# floattype(::Type{UInt128}) = Float128
# floattype(::Type{Int128}) = Float128

# conversion
Float128(x::Float128) = x

# Float64
@assume_effects :foldable Float128(x::Float64) =
    Float128(@quad_ccall(quadoplib.__extenddftf2(x::Cdouble)::Cfloat128))
@assume_effects :foldable Float64(x::Float128) =
    @quad_ccall(quadoplib.__trunctfdf2(x::Cfloat128)::Cdouble)

# Float32
@assume_effects :foldable Float128(x::Float32) =
    Float128(@quad_ccall(quadoplib.__extendsftf2(x::Cfloat)::Cfloat128))
@assume_effects :foldable Float32(x::Float128) =
    @quad_ccall(quadoplib.__trunctfsf2(x::Cfloat128)::Cfloat)

# Float16
Float128(x::Float16) = Float128(Float32(x))
Float16(x::Float128) = Float16(Float64(x)) # TODO: avoid double rounding

# TwicePrecision
Float128(x::Base.TwicePrecision{Float64}) =
    Float128(x.hi) + Float128(x.lo)

# integer -> Float128
function _Float128_bits(x::T) where T<:Base.BitUnsigned
    n = 8*sizeof(T)-leading_zeros(x) # Base.top_set_bit(x)
    if n <= 113 # not enough significand to need to care about rounding
        y = ((x % UInt128) << (113-n)) & significand_mask(Float128)
    else
        y = ((x >> (n-114)) % UInt128) & 0x0001_ffff_ffff_ffff_ffff_ffff_ffff_ffff # keep 1 extra bit
        y = (y+1)>>1 # round, ties up (extra leading bit in case of next exponent)
        y &= ~UInt128(trailing_zeros(x) == (n-114)) # fix last bit to round to even
    end
    d = ((n+exponent_bias(Float128)-1) % UInt128) << significand_bits(Float128)
    return d + y
end
function Float128(x::T) where T<:Base.BitUnsigned
    iszero(x) && return reinterpret(Float128, UInt128(0))
    reinterpret(Float128, _Float128_bits(x))
end

function Float128(x::T) where T<:Base.BitSigned
    iszero(x) && return reinterpret(Float128, UInt128(0))
    s = UInt128(signbit(x)) << 127 # sign bit
    ux = abs(x) % Unsigned # the % Unsigned doesn't care that abs(typemin) == typemin
    reinterpret(Float128, s|_Float128_bits(ux))
end

# Float128 -> integer requires arithmetic, so is below

# Rational
Float128(x::Rational{T}) where T = Float128(numerator(x))/Float128(denominator(x))

Float128(x::Bool) = x ? Float128(1) : Float128(0)

# Comparison
@assume_effects :foldable (==)(x::Float128, y::Float128) =
    @quad_ccall(quadoplib.__eqtf2(x::Cfloat128, y::Cfloat128)::Cint) == 0
@assume_effects :foldable (<)(x::Float128, y::Float128) =
    @quad_ccall(quadoplib.__letf2(x::Cfloat128, y::Cfloat128)::Cint) == -1
@assume_effects :foldable (<=)(x::Float128, y::Float128) =
    @quad_ccall(quadoplib.__letf2(x::Cfloat128, y::Cfloat128)::Cint) <= 0

# Arithmetic
@assume_effects :foldable (+)(x::Float128, y::Float128) =
    Float128(@quad_ccall(quadoplib.__addtf3(x::Cfloat128, y::Cfloat128)::Cfloat128))
@assume_effects :foldable (-)(x::Float128, y::Float128) =
    Float128(@quad_ccall(quadoplib.__subtf3(x::Cfloat128, y::Cfloat128)::Cfloat128))
@assume_effects :foldable (*)(x::Float128, y::Float128) =
    Float128(@quad_ccall(quadoplib.__multf3(x::Cfloat128, y::Cfloat128)::Cfloat128))
@assume_effects :foldable (/)(x::Float128, y::Float128) =
    Float128(@quad_ccall(quadoplib.__divtf3(x::Cfloat128, y::Cfloat128)::Cfloat128))

@assume_effects :foldable (-)(x::Float128) =
    Float128(@quad_ccall(quadoplib.__negtf2(x::Cfloat128)::Cfloat128))

# Float128 -> Integer
@assume_effects :foldable unsafe_trunc(::Type{Int32}, x::Float128) =
    @quad_ccall(quadoplib.__fixtfsi(x::Cfloat128)::Int32)

@assume_effects :foldable unsafe_trunc(::Type{Int64}, x::Float128) =
    @quad_ccall(quadoplib.__fixtfdi(x::Cfloat128)::Int64)

@assume_effects :foldable unsafe_trunc(::Type{UInt32}, x::Float128) =
    @quad_ccall(quadoplib.__fixunstfsi(x::Cfloat128)::UInt32)

@assume_effects :foldable unsafe_trunc(::Type{UInt64}, x::Float128) =
    @quad_ccall(quadoplib.__fixunstfdi(x::Cfloat128)::UInt64)

function unsafe_trunc(::Type{UInt128}, x::Float128)
    xu = reinterpret(UInt128,x)
    k = (Int64(xu >> 112) & 0x07fff) - 16382 - 113
    xu = (xu & significand_mask(Float128)) | 0x0001_0000_0000_0000_0000_0000_0000_0000
    if k <= 0
        UInt128(xu >> -k)
    else
        UInt128(xu) << k
    end
end
function unsafe_trunc(::Type{Int128}, x::Float128)
    copysign(unsafe_trunc(UInt128,x) % Int128, x)
end
trunc(::Type{Signed}, x::Float128) = trunc(Int,x)
trunc(::Type{Unsigned}, x::Float128) = trunc(Int,x)
trunc(::Type{Integer}, x::Float128) = trunc(Int,x)

for Ti in (Int32, Int64, Int128, UInt32, UInt64, UInt128)
    if Ti <: Unsigned || sizeof(Ti) < sizeof(Float128)
        # Here `Float128(typemin(Ti))-1` is exact, so we can compare the lower-bound
        # directly. `Float128(typemax(Ti))+1` is either always exactly representable, or
        # rounded to `Inf` (e.g. when `Ti==UInt128 && Float128==Float32`).
        @eval begin
            function trunc(::Type{$Ti},x::Float128)
                if Float128(typemin($Ti)) - one(Float128) < x < Float128(typemax($Ti)) + one(Float128)
                    return unsafe_trunc($Ti,x)
                else
                    throw(InexactError(:trunc, $Ti, x))
                end
            end
            function (::Type{$Ti})(x::Float128)
                if (Float128(typemin($Ti)) <= x <= Float128(typemax($Ti))) && (round(x, RoundToZero) == x)
                    return unsafe_trunc($Ti,x)
                else
                    throw(InexactError($(Expr(:quote,Ti.name.name)), $Ti, x))
                end
            end
        end
    else
        # Here `eps(Float128(typemin(Ti))) > 1`, so the only value which can be truncated to
        # `Float128(typemin(Ti)` is itself. Similarly, `Float128(typemax(Ti))` is inexact and will
        # be rounded up. This assumes that `Float128(typemin(Ti)) > -Inf`, which is true for
        # these types, but not for `Float16` or larger integer types.
        @eval begin
            function trunc(::Type{$Ti},x::Float128)
                if Float128(typemin($Ti)) <= x < Float128(typemax($Ti))
                    return unsafe_trunc($Ti,x)
                else
                    throw(InexactError(:trunc, $Ti, x))
                end
            end
            function (::Type{$Ti})(x::Float128)
                if (Float128(typemin($Ti)) <= x < Float128(typemax($Ti))) && (round(x, RoundToZero) == x)
                    return unsafe_trunc($Ti,x)
                else
                    throw(InexactError($(Expr(:quote,Ti.name.name)), $Ti, x))
                end
            end
        end
    end
end

## math

## one argument
for f in (:acos, :acosh, :asin, :asinh, :atan, :atanh, :cosh, :cos,
          :exp, :expm1, :log, :log2, :log10, :log1p,
          :sin, :sinh, :sqrt, :tan, :tanh,
          :ceil, :floor, :trunc, )
    @eval @assume_effects :foldable function $f(x::Float128)
        Float128(@quad_ccall(libquadmath.$(string(f,:q))(x::Cfloat128)::Cfloat128))
    end
end

@assume_effects :foldable abs(x::Float128) = Float128(@quad_ccall(libquadmath.fabsq(x::Cfloat128)::Cfloat128))
@assume_effects :foldable round(x::Float128) = Float128(@quad_ccall(libquadmath.rintq(x::Cfloat128)::Cfloat128))
round(x::Float128, r::RoundingMode{:Down}) = floor(x)
round(x::Float128, r::RoundingMode{:Up}) = ceil(x)
round(x::Float128, r::RoundingMode{:ToZero}) = round(x)

## two argument
@assume_effects :foldable (^)(x::Float128, y::Float128) =
    Float128(@quad_ccall(libquadmath.powq(x::Cfloat128, y::Cfloat128)::Cfloat128))

# circumvent a failure in Base
function (^)(x::Float128, p::Integer)
    if p >= 0
        Base.power_by_squaring(x,p)
    else
        Base.power_by_squaring(inv(x),-p)
    end
end
@assume_effects :foldable copysign(x::Float128, y::Float128) =
    Float128(@quad_ccall(libquadmath.copysignq(x::Cfloat128, y::Cfloat128)::Cfloat128))
@assume_effects :foldable hypot(x::Float128, y::Float128) =
    Float128(@quad_ccall(libquadmath.hypotq(x::Cfloat128, y::Cfloat128)::Cfloat128))
@assume_effects :foldable atan(x::Float128, y::Float128) =
    Float128(@quad_ccall(libquadmath.atan2q(x::Cfloat128, y::Cfloat128)::Cfloat128))

Base.Integer(x::Float128) = Int(x)
@assume_effects :foldable Base.rem(x::Float128, y::Float128) =
    Float128(@quad_ccall(libquadmath.remainderq(x::Cfloat128, y::Cfloat128)::Cfloat128))

sincos(x::Float128) = (sin(x), cos(x))

## misc
@static if !Sys.iswindows()
    # disable fma on Windows until rounding mode issue fixed
    # https://github.com/JuliaMath/Quadmath.jl/issues/31
    @assume_effects :foldable fma(x::Float128, y::Float128, z::Float128) =
        Float128(@quad_ccall(libquadmath.fmaq(x::Cfloat128, y::Cfloat128, z::Cfloat128)::Cfloat128))
end

@assume_effects :foldable isnan(x::Float128) = 0 != @quad_ccall(libquadmath.isnanq(x::Cfloat128)::Cint)
@assume_effects :foldable isinf(x::Float128) = 0 != @quad_ccall(libquadmath.isinfq(x::Cfloat128)::Cint)
@assume_effects :foldable isfinite(x::Float128) = 0 != @quad_ccall(libquadmath.finiteq(x::Cfloat128)::Cint)

isinteger(x::Float128) = isfinite(x) && x === trunc(x)

signbit(x::Float128) = signbit(reinterpret(Int128, x))

flipsign(x::Float128, y::Float128) = signbit(y) ? -x : x

precision(::Type{Float128}) = 113

eps(::Type{Float128}) = reinterpret(Float128, 0x3f8f_0000_0000_0000_0000_0000_0000_0000)
floatmin(::Type{Float128}) = reinterpret(Float128, 0x0001_0000_0000_0000_0000_0000_0000_0000)
floatmax(::Type{Float128}) = reinterpret(Float128, 0x7ffe_ffff_ffff_ffff_ffff_ffff_ffff_ffff)
maxintfloat(::Type{Float128}) = Float128(0x0002_0000_0000_0000_0000_0000_0000_0000)

"""
    Inf128

Positive infinity of type [`Float128`](@ref).
"""
const Inf128 = reinterpret(Float128, 0x7fff_0000_0000_0000_0000_0000_0000_0000)
typemax(::Type{Float128}) = Inf128
typemin(::Type{Float128}) = -Inf128

@assume_effects :foldable ldexp(x::Float128, n::Cint) =
    Float128(@quad_ccall(libquadmath.ldexpq(x::Cfloat128, n::Cint)::Cfloat128))
ldexp(x::Float128, n::Integer) =
    ldexp(x, clamp(n, typemin(Cint), typemax(Cint)) % Cint)


@assume_effects :foldable function frexp(x::Float128)
    ri = Ref{Cint}()
    f = Float128(@quad_ccall(libquadmath.frexpq(x::Cfloat128, ri::Ptr{Cint})::Cfloat128))
    return f, Int(ri[])
end

function modf(x::Float128)
    isinf(x) && return (zero(Float128), x)
    ipart = trunc(x)
    fpart = x - ipart
    return fpart, ipart
end

significand(x::Float128) = frexp(x)[1] * 2
function exponent(x::Float128)
     !isfinite(x) && throw(DomainError("Cannot be NaN or Inf."))
     abs(x) > 0 && return frexp(x)[2] - 1
     throw(DomainError("Cannot be subnormal converted to 0."))
end

function nextfloat(f::Float128, d::Integer)
    F = typeof(f)
    fumax = reinterpret(Unsigned, F(Inf))
    U = typeof(fumax)

    isnan(f) && return f
    fi = reinterpret(Signed, f)
    fneg = fi < 0
    fu = unsigned(fi & typemax(fi))

    dneg = d < 0
    da = Base.uabs(d)
    if da > typemax(U)
        fneg = dneg
        fu = fumax
    else
        du = da % U
        if fneg ⊻ dneg
            if du > fu
                fu = min(fumax, du - fu)
                fneg = !fneg
            else
                fu = fu - du
            end
        else
            if fumax - fu < du
                fu = fumax
            else
                fu = fu + du
            end
        end
    end
    if fneg
        fu |= sign_mask(F)
    end
    reinterpret(F, fu)
end

Float128(::Irrational{:π}) =  reinterpret(Float128, 0x4000921fb54442d18469898cc51701b8)
Float128(::Irrational{:ℯ}) =  reinterpret(Float128, 0x40005bf0a8b1457695355fb8ac404e7a)
Float128(x::Irrational{T}) where {T} = Float128(BigFloat(x))

import Base.MPFR

@static if VERSION >= v"1.12.0-DEV.1343"
    const _big_setindex! = Base.setindex!
    const _big_getindex = Base.getindex
else
    const _big_setindex! = unsafe_store!
    const _big_getindex = unsafe_load
end

function BigFloat(x::Float128; precision=precision(BigFloat))
    if !isfinite(x) || iszero(x)
        return BigFloat(Float64(x), precision=precision)
    end

    b = BigFloat(precision=max(precision,113))

    y, k = frexp(x)
    b.exp = Clong(k)
    b.sign = signbit(x) ? Cint(-1) : Cint(1)
    u = (reinterpret(UInt128, y) << 15) | 0x8000_0000_0000_0000_0000_0000_0000_0000
    i = cld(precision, sizeof(MPFR.Limb)*8)
    while u != 0
        w = (u >> (128-sizeof(MPFR.Limb)*8)) % MPFR.Limb
        _big_setindex!(b.d, w, i)
        i -= 1
        u <<= sizeof(MPFR.Limb)*8
    end
    # set remaining bits to zero
    while i > 0
        _big_setindex!(b.d, zero(MPFR.Limb), i)
        i -= 1
    end

    if precision < 113
        return BigFloat(b, precision=precision)
    else
        return b
    end
end

function Float128(x::BigFloat)
    if !isfinite(x) || iszero(x)
        return Float128(Float64(x))
    end

    y,k = frexp(x)
    if k >= -16381
        prec = 113
    elseif k >= -16381-112
        prec = 113 + (k + 16381)
    elseif k == -16381-113 && abs(y) > 0.5
        z = reinterpret(Float128, UInt128(1))
    else
        z = reinterpret(Float128, UInt128(0))
    end

    y = BigFloat(x, precision=prec)
    u = zero(UInt128)
    i = cld(prec, sizeof(MPFR.Limb)*8)
    j = 113
    while i > 0
        j -= sizeof(MPFR.Limb)*8
        u |= (_big_getindex(y.d, i) % UInt128) << j
        i -= 1
    end
    u &= significand_mask(Float128)
    u |= exponent_half(Float128)
    z = ldexp(reinterpret(Float128, u), y.exp)
    return copysign(z,x)
end

function BigInt(x::Float128)
    !isinteger(x) && throw(InexactError(BigInt, x))
    BigInt(BigFloat(x, precision=precision(Float128)))
end
function Float128(x::BigInt)
    y = BigFloat(x, precision=precision(Float128))
    Float128(y)
end

promote_rule(::Type{Float128}, ::Type{Float16}) = Float128
promote_rule(::Type{Float128}, ::Type{Float32}) = Float128
promote_rule(::Type{Float128}, ::Type{Float64}) = Float128
promote_rule(::Type{Float128}, ::Type{<:Integer}) = Float128

#widen(::Type{Float64}) = Float128
widen(::Type{Float128}) = BigFloat

function decompose(x::Float128)::Tuple{Int128, Int, Int}
    isnan(x) && return 0, 0, 0
    isinf(x) && return ifelse(x < 0, -1, 1), 0, 0
    n = reinterpret(UInt128, x)
    s = (n & significand_mask(Float128)) % Int128
    e = ((n & exponent_mask(Float128)) >> 112) % Int
    s |= Int128(e != 0) << 112
    d = ifelse(signbit(x), -1, 1)
    s, e - 16495 + (e == 0), d
end

function Random.rand(rng::AbstractRNG, s::Random.SamplerTrivial{Random.CloseOpen01{Float128}})
    u = rand(rng, UInt128)
    x = (reinterpret(Float128, u & Base.significand_mask(Float128)
                     | Base.exponent_one(Float128))
         - one(Float128))
    return x
end

# TODO: need to do this better
function parse(::Type{Float128}, s::AbstractString)
    Float128(@quad_ccall(libquadmath.strtoflt128(s::Cstring, C_NULL::Ptr{Ptr{Cchar}})::Cfloat128))
end

function string(x::Float128)
    lng = 64
    buf = Array{UInt8}(undef, lng + 1)
    lng = @quad_ccall(libquadmath.quadmath_snprintf(buf::Ptr{UInt8}, (lng+1)::Csize_t, "%.35Qe"::Ptr{UInt8}, x::(Cfloat128...))::Cint)
    return String(resize!(buf, lng))
end

print(io::IO, b::Float128) = print(io, string(b))
show(io::IO, b::Float128) = print(io, string(b))

include("printf.jl")

if !isdefined(Base, :get_extension)
    include("../ext/QuadmathSpecialFunctionsExt.jl")
end
end # module Quadmath
