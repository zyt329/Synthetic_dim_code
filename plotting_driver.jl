include("plotting_auto.jl")

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J10.0_1.15_Q2_sweep100000_L_12__Q_2__sweeps_100000_Date_Fri_14_May_2021_00_33_18.jld",
    #"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J10.9_0.115_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Thu_13_May_2021_08_20_06.jld",
    #"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J10.9_0.115_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Thu_13_May_2021_05_07_11.jld",
    #="E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_J1049_050_sweep10e6_L_20__Q_16__sweeps_10000_Date_Wed_14_Apr_2021_01_05_20.jld",
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
            save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_graph_newM/rev/",
            Eplot = true,
            Bplot = true,
            Cplot = true,
            J1index = [k],
        )
    end
end

driver()

#println(load(sims[1])["sim"][1][3][1])
