module QuadmathSpecialFunctionsExt

using Quadmath: libquadmath, Float128, Cfloat128, @quad_ccall
import SpecialFunctions
import SpecialFunctions: erf, erfc, besselj0, besselj1, bessely0, bessely1,
    besselj, bessely, gamma, logabsgamma

erf(x::Float128) =
    Float128(@quad_ccall(@autoql(erf)(x::Cfloat128)::Cfloat128))
erfc(x::Float128) =
    Float128(@quad_ccall(@autoql(erfc)(x::Cfloat128)::Cfloat128))

besselj0(x::Float128) =
    Float128(@quad_ccall(@autoql(j0)(x::Cfloat128)::Cfloat128))
besselj1(x::Float128) =
    Float128(@quad_ccall(@autoql(j1)(x::Cfloat128)::Cfloat128))

bessely0(x::Float128) =
    Float128(@quad_ccall(@autoql(y0)(x::Cfloat128)::Cfloat128))
bessely1(x::Float128) =
    Float128(@quad_ccall(@autoql(y1)(x::Cfloat128)::Cfloat128))

besselj(n::Integer, x::Float128) =
    Float128(@quad_ccall(@autoql(jn)(n::Cint, x::Cfloat128)::Cfloat128))
bessely(n::Integer, x::Float128) =
    Float128(@quad_ccall(@autoql(yn)(n::Cint, x::Cfloat128)::Cfloat128))

gamma(x::Float128) =
    Float128(@quad_ccall(@autoql(tgamma)(x::Cfloat128)::Cfloat128))

function logabsgamma(x::Float128)
    result = Float128(@quad_ccall(@autoql(lgamma)(x::Cfloat128)::Cfloat128))
    sign = !isfinite(result) || x >= 0 || !iszero(mod(ceil(x), 2)) ? 1 : -1
    return result, sign
end

end
