using Statistics

function error_binning(x::Array; bin_num = 10)
    x2 = x.^2
    L = length(x)
    bin_size = Int(floor(L / bin_num))
    xbin = Float64[]
    for i = 1:bin_num # for each entry of xbin
        x_bin_avg = mean(x[(i-1)*bin_size+1:i*bin_size])
        push!(xbin, x_bin_avg)
    end
    return std(xbin)
end
