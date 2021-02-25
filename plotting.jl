using Plots
using JLD

sim1 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Test_Wolff_wideTempcomparision_L_6__Q_16__sweeps_10e7_Date_Wed_24_Feb_2021_17_29_51.jld")["sim"]
sim2 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Max_def_wideTemp_L_6__Q_16__sweeps_10e6_Date_Sun_21_Feb_2021_04_55_53.jld")["sim"]

function Eplotting()
    Temp = range(0.4, 0.9, length = 100)#range(0.550, 0.696, length = 50)
    Tempwolff = range(0.3, 0.7, length = 100)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "E_site",
        title = "E_site : 6*6, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [range(0.0, 1.0, length = 5);0.4;0.45]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:3#1:length(J1)
        plot!(Temp, sim1[1][k], label = "J1 = $(J1[k])")#"J1 = $(J1[k])")
    end
    for k = 1:3#1:length(J1)
        plot!(Tempwolff, sim2[1][k], label = "Periodic_J1 = $(J1[k])")
    end
    #plot!(Temp, MAX_T, label = "MAX_Result_J1 = 0.4")
    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_comparision/Eplots_wolfftest_VS_nonperiodic.svg")
end

function Cplotting()
    Temp = range(0.4, 0.9, length = 100)#range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
    Tempwolff = range(0.3, 0.7, length = 100)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "C_site",
        title = "C_site : 6*6, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [range(0.0, 1.0, length = 5);0.4;0.45]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        plot!(Temp, sim1[2][k], label = "J1 = $(J1[k])")
    end
    for k = 1:length(J1)
        plot!(Tempwolff, sim2[2][k], label = "Periodic_J1 = $(J1[k])")
    end
    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_comparision/Cplots1_wolfftest_VS_nonperiodic.svg")
end

function Bplotting()
    Temp = range(0.4, 0.9, length = 100)#range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
    Tempwolff = range(0.3, 0.7, length = 100)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "B",
        title = "B : 6*6, Q = 16, J_0 = 1.0",
        legend = :bottomleft,
    )
    J1 = [range(0.0, 1.0, length = 5);0.4;0.45]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    #=
    for k = 1:length(J1)
        plot!(Temp, sim1[3][k], label = "J1 = $(J1[k])")
    end=#
    for k = 1:length(J1)
        plot!(Tempwolff, sim2[3][k], label = "Periodic_J1 = $(J1[k])")
    end
    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_comparision/Bplots1_wolfftest_VS_nonperiodic.svg")
end
Eplotting()
Cplotting()
Bplotting()
