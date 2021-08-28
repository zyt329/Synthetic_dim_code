using JLD
using Plots
using LsqFit
using Statistics
using DelimitedFiles

J1_index = 1

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Tue_29_Jun_2021_20_10_56.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_10__Q_16__sweeps_1000000_Date_Tue_29_Jun_2021_21_13_29.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Tue_29_Jun_2021_22_27_36.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_14__Q_16__sweeps_1000000_Date_Tue_29_Jun_2021_23_54_46.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_16__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_02_19_37.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_18__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_04_19_30.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_20__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_06_33_50.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_22__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_09_00_54.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_24__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_10_54_16.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/newM_M2_Scaling_J10.0_1.15_Q16_sweep1000000_L_26__Q_16__sweeps_1000000_Date_Wed_30_Jun_2021_13_41_51.jld",
]

L = [8,10,12,14,16,18,20,22,24,26]
N = L.^2
Q=16

function offload(sim::String, quantity; J1_index::Int64, T_index::Int64, print = false)
    simulation = load(sim)["sim"][1]
    entry_num = Dict(:E=>1,:C=>2,:M2=>3,:T=>4,:J1=>5)

    if print
        println(simulation[entry_num[quantity]][J1_index][T_index])
    end
    return simulation[entry_num[quantity]][J1_index][T_index]
end

offload(sims[1], :E, J1_index=J1_index, T_index=1, print=true)

function M2_vs_L(sims; J1_index::Int64, T_index::Int64)
    Ns = Float64[]
    M2s = Float64[]
    for sim in sims
        L = simulation = load(sim)["sim"][2][2]
        N = L^2
        M2 = offload(sim, :M2, J1_index = J1_index, T_index = T_index)
        push!(Ns, N)
        push!(M2s, M2)
    end
    return Dict(:N=>Ns, :M2=>M2s)
end

function print2file_M2_vs_L(sims; save_path::String, J1_index::Int64, T_index::Int64, save_name)
    Q = load(sims[1])["sim"][2][3]
    J1 = load(sims[1])["sim"][1][5][J1_index]
    T = load(sims[1])["sim"][1][4][J1_index][T_index]


    lnN = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:N])
    lnM2 = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:M2])
    lnN_lnM2 = cat(lnN, lnM2, dims=2)

    outfile = save_path*"Q=$(Q)_T=$(T)_J1=$(J1)"*save_name*".txt"
    open(outfile, "w") do io
        #writedlm(io, J1s)
        writedlm(io, lnN_lnM2)
    end
end

function exponent_fit(sims; J1_index::Int64, T_index::Int64)
    lnM2(lnN, p) = p[1] * lnN .+ p[2]

    lnN_data = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:N])
    lnM2_data = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:M2])

    fit = curve_fit(lnM2, lnN_data, lnM2_data, [0.0, 0.0])
    mse = mean(fit.resid.^2)

    J1 = load(sims[1])["sim"][1][5][J1_index]
    T = load(sims[1])["sim"][1][4][J1_index][T_index]
    println("")
    println("J1=$(J1),T=$(T)"*" parameters are $(fit.param)"*" mean squared error is $(mse)")
    return fit.param[1]
end

exponent_fit(sims; J1_index=4, T_index=50)

print2file_M2_vs_L(sims; save_path="E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/", J1_index=1, T_index=33, save_name = "lnM2_vs_lnN")
