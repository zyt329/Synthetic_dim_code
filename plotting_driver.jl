include("plotting_auto.jl")

sims = ["E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_test/Wolff_5000bin_sweep10e6_L_6__Q_16__sweeps_1000000_Date_Sun_07_Mar_2021_19_02_40.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_test/Wolff_5000bin_sweep10e6_L_8__Q_16__sweeps_1000000_Date_Sun_07_Mar_2021_21_08_32.jld",
"E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_test/Wolff_5000bin_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Mon_08_Mar_2021_02_37_55.jld"
]

sims_plotting(
    sims...;
    save_name = "Wolff_10000bin_Q_16",
    save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_graph/",
    Eplot = false,
    Bplot = true,
    Cplot = false,
    J1index = [7],
)
