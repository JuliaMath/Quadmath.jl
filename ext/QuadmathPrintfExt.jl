module QuadmathPrintfExt

using Quadmath, Printf

Printf.tofloat(x::Float128) = BigFloat(x)

end
