using Plots
using JLD

sim = load("Metropolis_My_def_L_6__Q_8__Date_Wed_17_Feb_2021_15_53_54.jld")["sim"]


function Eplotting()
    Temp = range(0.3, 0.7, length = 50)#range(0.550, 0.696, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "E_site",
        title = "E_site : 8 * 8, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        plot!(Temp, sim[1][k], label = "J1 = $(J1[k])")
    end

    #plot!(Temp, MAX_T, label = "MAX_Result_J1 = 0.4")
    savefig("Eplots1.svg")
end

function Cplotting()
    Temp = range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "C_site",
        title = "C_site : 8 * 8, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        plot!(Temp, sim[2][k], label = "J1 = $(J1[k])")
    end

    #plot!(Temp, Max_C, label = "MAX_Result_J1 = 0.0")
    savefig("Cplots1.svg")
end

function Bplotting()
    Temp = range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "B",
        title = "B : 8 * 8, Q = 16, J_0 = 1.0",
        legend = :bottomright,
    )
    J1 = range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        plot!(Temp, sim[3][k], label = "J1 = $(J1[k])_L=6")
    end
    savefig("Bplots1.svg")
end
Eplotting()
Cplotting()
Bplotting()
