using JLD
using DelimitedFiles

sims = [
    #="E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_43_17.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.3_0.55_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_45_34.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.6_0.85_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_43_59.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.9_1.15_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_45_45.jld",=##=
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Fri_14_May_2021_20_14_08.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.3_0.55_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Fri_14_May_2021_20_15_52.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.6_0.85_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Fri_14_May_2021_20_11_21.jld",
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.9_1.15_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Fri_14_May_2021_20_13_57.jld",=#
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_43_17.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.3_0.55_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_45_34.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.6_0.85_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_43_59.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM_nonperiodic/newM_nonperiodic_J10.9_1.15_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_45_45.jld",
]

#=
notes = ["C4" "D4" "E4" "F4"]
outfile = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/file.txt"
a=[1,2,3,4]
b=[5,6,7,8]
test = [a b ]
println(typeof(test))
open(outfile, "w") do f
    for i in notes
        println(f, i)
    end
    writedlm(f, test)
end=#

function sims_print(
    sims...;
    save_name,
    save_path,
    Eprint = true,
    Bprint = true,
    Cprint = true,
    J1index = [],
)
    simulations = []
    simulations_paras = []
    for simulation in sims
        push!(simulations, load(simulation)["sim"][1])
        push!(simulations_paras, load(simulation)["sim"][2])
    end

    if Eprint

        outfile = save_path*save_name*"_E"*".txt"
        Temp_E = []
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            for k = 1:length(simulations[i][4])#loop over different J1 values
                J1=simulations[i][5][k]
                push!(Temp_E, cat("Temp_$(J1)", Array{Float64}(simulations[i][4][k]), dims=1))#Temp
                push!(Temp_E, cat("E_$(J1)",Array{Float64}(simulations[i][1][k]),dims=1))#E
            end
        end
        Temp_E = reshape(Temp_E, 1, length(Temp_E))
        Temp_E = cat(Temp_E...,dims=2)
        open(outfile, "w") do io
            #println(io, "J1 values are $(J1s)")
            writedlm(io, Temp_E)
        end
        # Save by the content of the first simulation among the simulations
    end
    ####------------------------------------------------------------------
    if Bprint
        outfile = save_path*save_name*"_Binder"*".txt"
        Temp_B = []
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            for k = 1:length(simulations[i][4])#loop over different J1 values
                J1=simulations[i][5][k]
                push!(Temp_B, cat("Temp_$(J1)", Array{Float64}(simulations[i][4][k]), dims=1))#Temp
                push!(Temp_B, cat("B_$(J1)",Array{Float64}(simulations[i][3][k]),dims=1))#E
            end
        end
        Temp_B = reshape(Temp_B, 1, length(Temp_B))
        Temp_B = cat(Temp_B...,dims=2)
        open(outfile, "w") do io
            #println(io, "J1 values are $(J1s)")
            writedlm(io, Temp_B)
        end
    end
    ####------------------------------------------------------------------
    if Cprint
        outfile = save_path*save_name*"_C"*".txt"
        Temp_C = []
        for i = 1:length(simulations)#loop over different simulations(L,Q...)
            for k = 1:length(simulations[i][4])#loop over different J1 values
                J1=simulations[i][5][k]
                push!(Temp_C, cat("Temp_$(J1)", Array{Float64}(simulations[i][4][k]), dims=1))#Temp
                push!(Temp_C, cat("C_$(J1)",Array{Float64}(simulations[i][2][k]),dims=1))#E
            end
        end
        Temp_C = reshape(Temp_C, 1, length(Temp_C))
        Temp_C = cat(Temp_C...,dims=2)
        open(outfile, "w") do io
            #println(io, "J1 values are $(J1s)")
            #writedlm(io, J1s)
            writedlm(io, Temp_C)
        end
    end
end

function driver(; sims = sims)
    J1 = load(sims[1])["sim"][1][5]

    sims_print(
        sims...;
        save_name = "nonperiodic_L=8",
        save_path = "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/data_in_text/",
        Eprint = true,
        Bprint = true,
        Cprint = true,
        J1index = [],
    )

end

driver()
