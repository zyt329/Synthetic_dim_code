using JLD
using DelimitedFiles

save_name = "exponent_vs_T"
save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/"

sims = [
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/Q=16_J1=0.0_exponent_vs_T.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/Q=16_J1=0.2_exponent_vs_T.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/Q=16_J1=0.6_exponent_vs_T.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/Q=16_J1=0.85_exponent_vs_T.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM_rev/Q=16_J1=1.15_exponent_vs_T.jld"
]

colnames = ["Temp" "J1=0.0" "J1=0.2" "J1=0.6" "J1=0.85" "J1=1.15"]
Temps = Array{Float64}(range(0.01, 1, length=50))
exponents = []
for simulation in sims
    push!(exponents, load(simulation)["exponents"])
end

exp2print = []
push!(exp2print, Temps)
for exponent in exponents#loop over different J1s
    push!(exp2print, Array{Float64}(exponent))
end
exp2print = cat(exp2print...,dims=2)
println(exp2print)
exp2print = cat(colnames, exp2print, dims=1)

outfile = save_path*save_name*".txt"
open(outfile, "w") do io
    #writedlm(io, J1s)
    writedlm(io, exp2print)
end
