using Plots
using JLD

sim = load("Result_Mon_11_Jan_2021_13_30_11.jld")["sim"]


function Eplotting()
    Temp = range(0.01, 1.5, length = 100)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "E_site",
        title = "E_site : 16 * 16, Q = 32, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [0, 0.4, 0.8, 1]
    for k = 1:4
        plot!(Temp, sim[1][k], label = "J1 = $(J1[k])")
    end
    savefig("Eplots1.svg")
end

function Cplotting()
    Temp = range(0.01, 1.5, length = 100)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "C_site",
        title = "C_site : 16 * 16, Q = 32, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [0, 0.4, 0.8, 1]
    for k = 1:4
        plot!(Temp, sim[2][k], label = "J1 = $(J1[k])")
    end
    savefig("Cplots1.svg")
end
Eplotting()
Cplotting()
