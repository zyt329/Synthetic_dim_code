using JLD
using Plots
using LsqFit
using Statistics

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_32__Q_16__sweeps_1000000_Date_Sat_24_Apr_2021_09_59_05.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_30__Q_16__sweeps_1000000_Date_Sat_24_Apr_2021_03_08_08.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_28__Q_16__sweeps_1000000_Date_Fri_23_Apr_2021_18_19_07.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_26__Q_16__sweeps_1000000_Date_Fri_23_Apr_2021_10_42_07.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_24__Q_16__sweeps_1000000_Date_Fri_23_Apr_2021_02_15_57.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_22__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_21_00_43.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_20__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_16_30_26.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_18__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_12_50_37.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_09_47_54.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_14__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_07_25_37.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_05_17_01.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_10__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_03_48_31.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_result_newM/Wolff_newM_M2_J100_02_06_085_115_Q16_sweep10e6_L_8__Q_16__sweeps_1000000_Date_Thu_22_Apr_2021_02_40_39.jld"
]

L = [8,10,12,14,16,18,20,22,24,26,28,30,32]
N = L.^2

function offload(sim::String, quantity; J1_index::Int64, T_index::Int64, print = false)
    simulation = load(sim)["sim"][1]
    entry_num = Dict(:E=>1,:C=>2,:M2=>3,:T=>4,:J1=>5)

    if print
        println("")
    end
    return simulation[entry_num[quantity]][J1_index][T_index]
end

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

function plot_M2_vs_L(sims; savepath::String, J1_index::Int64, T_index::Int64)
    Q = load(sims[1])["sim"][2][3]
    J1 = load(sims[1])["sim"][1][5][J1_index]
    T = load(sims[1])["sim"][1][4][J1_index][T_index]

    plot(
        dpi = 800,
        xlabel = "lnN",
        ylabel = "M2",
        title = "M2_vs_L : J_0 = 1.0, Q = $Q, T = $T, J1 = $J1",
        legend = :topright,
    )
    lnN = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:N])
    lnM2 = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:M2])
    plot!(lnN, lnM2, label = "lnM2")
    savefig(savepath*"Q=$(Q)_T=$(T)_J1=$(J1)"*"_lnM2_vs_lnN"*".png")
end



function exponent_fit(sims; J1_index::Int64, T_index::Int64)
    lnM2(lnN, p) = p[1] * lnN .+ p[2]

    lnN_data = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:N])
    lnM2_data = log.(M2_vs_L(sims, J1_index=J1_index, T_index=T_index)[:M2])

    fit = curve_fit(lnM2, lnN_data, lnM2_data, [0.0, 0.0])
    mse = mean(fit.resid.^2)

    J1 = load(sims[1])["sim"][1][5][J1_index]
    T = load(sims[1])["sim"][1][4][J1_index][T_index]
    println("J1=$(J1),T=$(T)"*" parameters are $(fit.param)"*" mean squared error is $(mse)")
    return fit.param[1]
end


for J1_index in 1:length(load(sims[1])["sim"][1][5])
    savepath = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM/J1_$(load(sims[1])["sim"][1][5][J1_index])_50pts/"
    for T_index in 1:length(load(sims[1])["sim"][1][4][J1_index])
        plot_M2_vs_L(sims, savepath=savepath, J1_index=J1_index, T_index=T_index)
    end
end

#=
for J1_index in 1:length(load(sims[1])["sim"][1][5])

    savepath = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/M2_graph_newM/"
    J1 = load(sims[1])["sim"][1][5][J1_index]
    T = load(sims[1])["sim"][1][4][J1_index]
    plot(dpi = 800,
    seriestype = :scatter,
    markerstrokewidth = 0.3,
    markersize = 2,
    xlabel = "T",
    ylabel = "exponent",
    title = "exponent_of_M2(with respect to N) vs T : J_0 = 1.0, Q = $Q, J1 = $J1",
    legend = :topright,)

    exponents = Float64[]
    for T_index in 1:length(load(sims[1])["sim"][1][4][J1_index])
        push!(exponents, exponent_fit(sims, J1_index=J1_index, T_index=T_index))
    end
    plot!(T, exponents, label = "exponent")
    savefig(savepath*"Q=$(Q)_J1=$(J1)"*"_exponent_vs_T"*".png")
    save(savepath*"Q=$(Q)_J1=$(J1)_exponent_vs_T.jld", "exponents", exponents)
end
=#
