cd(joinpath(dirname(@__FILE__), "src"))
run(`make`)
if (!ispath("../usr"))
    run(`mkdir ../usr`)
end
if (!ispath("../usr/lib"))
    run(`mkdir ../usr/lib`)
end

run(`mv libquadmath_wrapper.$(Libdl.dlext) ../usr/lib`)

