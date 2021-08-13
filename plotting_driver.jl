include("plotting_auto.jl")

sims = [
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Larger_system_result/newM_periodic_J10.6_0.6_Q16_sweep4000000_L_18__Q_16__sweeps_4000000_Date_Sun_20_Jun_2021_23_13_39.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Larger_system_result/newM_periodic_J10.6_0.6_Q16_sweep4000000_L_22__Q_16__sweeps_4000000_Date_Mon_21_Jun_2021_02_58_48.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Larger_system_result/newM_periodic_J10.6_0.6_Q16_sweep4000000_L_26__Q_16__sweeps_4000000_Date_Mon_21_Jun_2021_07_28_46.jld",
    #="E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_rev_J1060_085_Q16_sweep10e6_L_8__Q_16__sweeps_1000000_Date_Wed_12_May_2021_03_02_18.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_rev_J1060_085_Q16_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Wed_12_May_2021_05_44_09.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_rev_J1060_085_Q16_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Wed_12_May_2021_10_58_21.jld",=#
    #="E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_14__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_06_35_17.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Wed_07_Apr_2021_09_37_39.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1028_052_sweep10e6_L_24__Q_16__sweeps_1000000_Date_Thu_08_Apr_2021_23_08_02.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Wolff_nobin_J1056_080_sweep10e6_L_32__Q_16__sweeps_1000000_Date_Fri_09_Apr_2021_06_12_07.jld",=#
]

function driver(; sims = sims)
    J1 = load(sims[1])["sim"][1][5]
    for k = 1:length(J1)
        sims_plotting(
            sims...;
            save_name = "Wolff_corrected_Q16_J1=$(J1[k])",
            save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Larger_system_graph/",
            Eplot = true,
            Bplot = true,
            Cplot = true,
            J1index = [k],
        )
    end
end

driver()

#println(load(sims[1])["sim"][1][3][1])
