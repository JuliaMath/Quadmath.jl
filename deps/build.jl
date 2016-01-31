cd(joinpath(dirname(@__FILE__), "src"))
run(`make`)
if (!ispath("../usr"))
    run(`mkdir ../usr`)
end
if (!ispath("../usr/lib"))
    run(`mkdir ../usr/lib`)
end

run(`mv libfloat128.$(Libdl.dlext) ../usr/lib`)

