using Plots
using JLD

function file2array(location::String)
    stream = open(location, "r")
    index = 1
    array = Float64[]
    while eof(stream) != true
        tmp = readline(stream, keep = true)
        push!(array, parse(Float64, tmp))
        index += 1
    end
    return array
end

function sims_plotting(
    sims...;
    save_name,
    save_path,
    Eplot = true,
    Bplot = true,
    Cplot = true,
    J1index = [],
)
    simulations = []
    simulations_paras = []
    for simulation in sims
        push!(simulations, load(simulation)["sim"][1])
        push!(simulations_paras, load(simulation)["sim"][2])
    end
    if Eplot
        plot(
            dpi = 800,
            xlabel = "T",
            ylabel = "E_site",
            title = "E_site : J_0 = 1.0",
            legend = :topleft,
        )
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            J1s = simulations[i][5]
            if J1index == []
                for k in 1:length(J1s)#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][1][k],
                        label = simulations_paras[i][1] *
                                "_J1 = $(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            else
                for k in J1index#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][1][k],
                        label = simulations_paras[i][1] *
                                "_J1 = $(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            end
        end
        savefig(save_path *save_name* simulations_paras[1][1] * "_E" * ".png")# Save by the content of the first simulation among the simulations
    end
    ####------------------------------------------------------------------
    if Bplot
        plot(
            dpi = 800,
            xlabel = "T",
            ylabel = "Binder's ratio",
            title = "Binder's ratio : J_0 = 1.0",
            legend = :bottomleft,
            legendfontsize=8,
        )
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            J1s = simulations[i][5]
            if J1index == []
                for k in 1:length(J1s)#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][3][k],
                        label = #=simulations_paras[i][1] *=#
                                "_J1=$(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            else
                for k in J1index#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][3][k],
                        label = #=simulations_paras[i][1] *=#
                                "_J1 = $(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            end
        end#=
        for k = J1index#1:length(J1)
            J1 = [range(0.0, 1.0, length = 5);0.4;0.45]
            #plot!(Temp, sim3[1][k], label = "Wolff_J1 = $(J1[k])")
            for L in (6, 8)
                #Since Max didn't run J1=1, skip J1 = 1.
                J1[k] == 1 && continue
                index_ini = Int(floor(J1[k]/0.02))*50 + 1
                index_final = index_ini + 49
                Max_Temp = range(0.56,0.648,length = 50)
                MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Max_$(L)_B.txt")
                plot!(Max_Temp, MaxBinder[index_ini: index_final], label = "Max, J1 = $(floor(J1[k]/0.02)*0.02), L = $(L)")
            end
        end=#
        savefig(save_path *save_name* simulations_paras[1][1] * "_B" * ".png")
    end
    ####---------------------------------------------------------------
    if Cplot
        plot(
            dpi = 800,
            xlabel = "T",
            ylabel = "C_site",
            title = "C_site : J_0 = 1.0",
            legend = :topleft,
        )
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            J1s = simulations[i][5]
            if J1index == []
                for k in 1:length(J1s)#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][2][k],
                        label = simulations_paras[i][1] *
                                "_J1 = $(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            else
                for k in J1index#loop over different J1 values
                    Temp = simulations[i][4][k]
                    plot!(
                        Temp,
                        simulations[i][2][k],
                        label = simulations_paras[i][1] *
                                "_J1 = $(J1s[k]),L$(simulations_paras[i][2])",
                    )
                end
            end
        end
        savefig(save_path *save_name* simulations_paras[1][1] * "_C" * ".png")
    end
end
