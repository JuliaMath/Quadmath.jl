import SpecialFunctions

SpecialFunctions.erf(x::Float128) =
    Float128(@ccall(libquadmath.erfq(x::Cfloat128)::Cfloat128))
SpecialFunctions.erfc(x::Float128) =
    Float128(@ccall(libquadmath.erfcq(x::Cfloat128)::Cfloat128))

SpecialFunctions.besselj0(x::Float128) =
    Float128(@ccall(libquadmath.j0q(x::Cfloat128)::Cfloat128))
SpecialFunctions.besselj1(x::Float128) =
    Float128(@ccall(libquadmath.j1q(x::Cfloat128)::Cfloat128))

SpecialFunctions.bessely0(x::Float128) =
    Float128(@ccall(libquadmath.y0q(x::Cfloat128)::Cfloat128))
SpecialFunctions.bessely1(x::Float128) =
    Float128(@ccall(libquadmath.y1q(x::Cfloat128)::Cfloat128))

SpecialFunctions.besselj(n::Integer, x::Float128) =
    Float128(@ccall(libquadmath.jnq(n::Cint, x::Cfloat128)::Cfloat128))
SpecialFunctions.bessely(n::Integer, x::Float128) =
    Float128(@ccall(libquadmath.ynq(n::Cint, x::Cfloat128)::Cfloat128))

SpecialFunctions.gamma(x::Float128) =
    Float128(@ccall(libquadmath.tgammaq(x::Cfloat128)::Cfloat128))
SpecialFunctions.lgamma(x::Float128) =
    Float128(@ccall(libquadmath.lgammaq(x::Cfloat128)::Cfloat128))
