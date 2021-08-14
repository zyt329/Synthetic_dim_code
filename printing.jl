using JLD

sims = [
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_8__Q_16__sweeps_1000000_Date_Fri_14_May_2021_18_43_17.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_12__Q_16__sweeps_1000000_Date_Fri_14_May_2021_20_14_08.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/newM_nonperiodic_J10.0_0.25_Q16_sweep1000000_L_16__Q_16__sweeps_1000000_Date_Fri_14_May_2021_22_19_18.jld",
]

function printing(sims)

    for m = 1:3
        L = [8, 12, 16]
        for i = 1:length(load(sims[m])["sim"][1][5])
            open(
                "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/L_$(L[m])_J1_$(load(sims[m])["sim"][1][5][i]).txt",
                "w",
            ) do io
                write(io, "L = $(L[m]), J1 = $(load(sims[m])["sim"][1][5][i])")
                write(io, "\n")
                for j = 1:length(load(sims[m])["sim"][1][4][1])
                    Temp = load(sims[m])["sim"][1][4][1][j]
                    Binder = load(sims[m])["sim"][1][3][i][j]
                    write(io, "\n")
                    write(io, "$(Temp), $(Binder)")
                end
            end
        end
    end

end

printing(sims)
#println("J1 = $(load(sims[1])["sim"][1][5])")
#=open(
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/myfile.txt",
    "w",
) do io
    write(io, "Hello world!")
    write(io, "\n")
    write(io, "Hello world!")
end;=#
