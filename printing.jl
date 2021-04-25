using JLD

sims = [
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1060_085_sweep10e6_L_8__Q_16__sweeps_1000000_Date_Wed_14_Apr_2021_05_07_46.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1060_085_sweep10e6_L_12__Q_16__sweeps_1000000_Date_Wed_14_Apr_2021_07_58_35.jld",
    "D:/UC Davis/Research/Synthetic Dimension/Synthetic_dim_code/Bcrossing_result_newM/Wolff_newM_J1060_085_sweep10e6_L_16__Q_16__sweeps_1000000_Date_Wed_14_Apr_2021_12_26_04.jld",
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
