using Printf

@testset "printf" begin
    for (fmt, val) in (("%7.2f", "   1.23"),
                   ("%-7.2f", "1.23   "),
                   ("%07.2f", "0001.23"),
                   ("%.0f", "1"),
                   ("%#.0f", "1."),
                   ("%.4e", "1.2345e+00"),
                   ("%.4E", "1.2345E+00"),
                   ("%.2a", "0x1.3cp+0"),
                   ("%.2A", "0X1.3CP+0")),
        num in (Float128(1.2345),)
        @test @eval(@sprintf($fmt, $num) == $val)
    end
    @test (@sprintf "%f" Float128(Inf)) == "Inf"
    @test (@sprintf "%f" Float128(NaN)) == "NaN"
    @test (@sprintf "%.0e" Float128(3e142)) == "3e+142"
    @test (@sprintf "%#.0e" Float128(3e142)) == "3.e+142"

    @test (@sprintf "%.0e" Float128(big"3e1042")) == "3e+1042"

    for (val, res) in ((Float128(12345678.), "1.23457e+07"),
                   (Float128(1234567.8), "1.23457e+06"),
                   (Float128(123456.78), "123457"),
                   (Float128(12345.678), "12345.7"))
        @test (@sprintf("%.6g", val) == res)
    end

    for (fmt, val) in (("%10.5g", "     123.4"),
                       ("%+10.5g", "    +123.4"),
                       ("% 10.5g","     123.4"),
                       ("%#10.5g", "    123.40"),
                       ("%-10.5g", "123.4     "),
                       ("%-+10.5g", "+123.4    "),
                       ("%010.5g", "00000123.4")),
        num in (Float128(123.4),)
        @test @eval(@sprintf($fmt, $num) == $val)
    end
    @test( @sprintf( "%10.5g", Float128(-123.4) ) == "    -123.4")
    @test( @sprintf( "%010.5g", Float128(-123.4) ) == "-0000123.4")
    @test( @sprintf( "%.6g", Float128(12340000.0) ) == "1.234e+07")
    @test( @sprintf( "%#.6g", Float128(12340000.0)) == "1.23400e+07")

    @test (@sprintf "%a" Float128(1.5)) == "0x1.8p+0"

end

