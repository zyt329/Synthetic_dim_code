include("plotting_auto.jl")

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_2__Q_16__sweeps_1000000_Date_Tue_06_Apr_2021_18_39_22.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_4__Q_16__sweeps_1000000_Date_Tue_06_Apr_2021_20_33_08.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_6__Q_16__sweeps_1000000_Date_Tue_06_Apr_2021_22_54_33.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_8__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_02_01_00.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_10__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_06_53_32.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_12_24_54.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_14__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_18_52_35.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J100_024_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Thu_08_Apr_2021_02_45_01.jld",#=
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1028_052_sweep10e6_L_24__Q_16__sweeps_1000000_Date_Thu_08_Apr_2021_23_08_02.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_32__Q_16__sweeps_1000000_Date_Fri_09_Apr_2021_06_12_07.jld",=#
]

function driver(; sims = sims)
    J1 = load(sims[1])["sim"][1][5]
    for k = 1:length(J1)
        sims_plotting(
            sims...;
            save_name = "Wolff_Q16_J1=$(J1[k])",
            save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_graph/Critical_L/",
            Eplot = false,
            Bplot = true,
            Cplot = false,
            J1index = [k],
        )
    end
end

driver()
