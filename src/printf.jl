import Base.Printf: ini_dec, fix_dec, ini_hex, ini_HEX

fix_dec(out, d::Float128, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)
ini_dec(out, d::Float128, ndigits::Int, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)
ini_hex(out, d::Float128, ndigits::Int, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)
ini_HEX(out, d::Float128, ndigits::Int, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)
ini_hex(out, d::Float128, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)
ini_HEX(out, d::Float128, flags::String, width::Int, precision::Int, c::Char, digits) = fp128_printf(out, d, flags, width, precision, c, digits)

function fp128_printf(out, d::Float128, flags::String, width::Int, precision::Int, c::Char, digits)
    fmt_len = sizeof(flags)+4
    if width > 0
        fmt_len += ndigits(width)
    end
    if precision >= 0
        fmt_len += ndigits(precision)+1
    end
    fmt = IOBuffer(maxsize=fmt_len)
    print(fmt, '%')
    print(fmt, flags)
    if width > 0
        print(fmt, width)
    end
    if precision == 0
        print(fmt, '.')
        print(fmt, '0')
    elseif precision > 0
        print(fmt, '.')
        print(fmt, precision)
    end
    print(fmt, 'Q')
    print(fmt, c)
    write(fmt, UInt8(0))
    printf_fmt = take!(fmt)
    @assert length(printf_fmt) == fmt_len
    bufsiz = length(digits)
    lng = @ccall(libquadmath.quadmath_snprintf(digits::Ptr{UInt8}, bufsiz::Csize_t, printf_fmt::Ptr{UInt8}, d::(Cfloat128...))::Cint)
#    lng = ccall((:mpfr_snprintf,:libmpfr), Int32,
#                (Ptr{UInt8}, Culong, Ptr{UInt8}, Ref{Float}...),
#                digits, bufsiz, printf_fmt, d)
    lng > 0 || error("invalid printf formatting for Float128")
    unsafe_write(out, pointer(digits), min(lng, bufsiz-1))
    return (false, ())
end
