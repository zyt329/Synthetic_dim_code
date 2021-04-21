include("plotting_auto.jl")

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1000_115_Q5_sweep10e6_L_8__Q_6__sweeps_10000_Date_Wed_14_Apr_2021_22_07_41.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1000_115_Q5_sweep10e6_L_12__Q_6__sweeps_10000_Date_Wed_14_Apr_2021_22_11_37.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1000_115_Q5_sweep10e6_L_16__Q_6__sweeps_10000_Date_Wed_14_Apr_2021_22_18_53.jld",#=
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_J1049_050_sweep10e6_L_20__Q_16__sweeps_10000_Date_Wed_14_Apr_2021_01_05_20.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_J1049_050_sweep10e6_L_36__Q_16__sweeps_10000_Date_Wed_14_Apr_2021_01_39_24.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_03_53_11.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_14__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_06_35_17.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_09_37_39.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1028_052_sweep10e6_L_24__Q_16__sweeps_1000000_Date_Thu_08_Apr_2021_23_08_02.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_32__Q_16__sweeps_1000000_Date_Fri_09_Apr_2021_06_12_07.jld",=#
]

function driver(; sims = sims)
    J1 = load(sims[1])["sim"][1][5]
    for k = 1:length(J1)
        sims_plotting(
            sims...;
            save_name = "Wolff_Q16_J1=$(J1[k])",
            save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_graph_newM/Q=6/",
            Eplot = true,
            Bplot = true,
            Cplot = true,
            J1index = [k],
        )
    end
end

driver()

#println(load(sims[1])["sim"][1][3][1])
