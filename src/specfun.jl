import SpecialFunctions

for (f, sym) in ((:erf, :erfq), (:erfc, :erfcq),
                 (:besselj0, :j0q), (:besselj1, :j1q),
                 (:bessely0, :y0q), (:bessely1, :y1q),
                 (:gamma, :tgammaq), (:lgamma, :lgammaq)
                 )
    @eval import SpecialFunctions: $f
    if _WIN_PTR_ABI
        @eval function $f(x::Float128)
            r = Ref{Cfloat128}()
            ccall(($(string(sym)), libquadmath),
                  Cvoid, (Ptr{Cfloat128}, Cfloat128, ), r, x)
            Float128(r[])
        end
    elseif Sys.iswindows()
        @eval function $f(x::Float128)
            r = Ref{Cfloat128}()
            p = PadPtr(r)
            ccall(($(string(sym)), libquadmath),
                  Cvoid, (PF128, Cfloat128, ), p, x)
            Float128(r[])
        end
    else
        @eval function $f(x::Float128)
            Float128(ccall(($(string(sym)), libquadmath),
                           Cfloat128, (Cfloat128, ), x))
        end
    end
end
for (f, sym) in ((:besselj, :jnq), (:bessely, :ynq))
    @eval import SpecialFunctions: $f
    if _WIN_PTR_ABI
        @eval function $f(n::Int, x::Float128)
            r = Ref{Cfloat128}()
            ccall(($(string(sym)), libquadmath),
                  Cvoid, (Ptr{Cfloat128}, Cint, Cfloat128, ), r, n, x)
            Float128(r[])
        end
    elseif Sys.iswindows()
        @eval function $f(n::Int, x::Float128)
            r = Ref{Cfloat128}()
            dummy = Int32(0) # for alignment
            ccall(($(string(sym)), libquadmath),
                  Cvoid, (Ptr{Cfloat128}, Cint, Cint, Cint, Cfloat128, ),
                  r, n, dummy, dummy, x)
            Float128(r[])
        end
    else
        @eval function $f(n::Int, x::Float128)
            Float128(ccall(($(string(sym)), libquadmath),
                           Cfloat128, (Cint, Cfloat128), n, x))
        end
    end
end
