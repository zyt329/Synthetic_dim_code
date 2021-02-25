using DelimitedFiles

stream = open(
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/caliboration/Binder_Calib/040Binder.dat",
    "r",
)

function file2array(stream)
    index = 1
    array = Float64[]
    while eof(stream) != true
        tmp = readline(stream, keep = true)
        push!(array, parse(Float64, tmp))
        index += 1
    end
    return array
end
println(file2array(stream))
