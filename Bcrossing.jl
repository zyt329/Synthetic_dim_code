using Plots
using JLD

J1s = [range(0.0, 1.0, length = 5); 0.4; 0.45]
Q = 16

sim = []
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Max_def_fineTemp_L_6__Q_16__sweeps_10e6_Date_Mon_22_Feb_2021_03_34_44.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Max_def_fineTemp_L_8__Q_16__sweeps_10e6_Date_Mon_22_Feb_2021_05_31_34.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Max_def_fineTemp_L_10__Q_16__sweeps_10e6_Date_Mon_22_Feb_2021_07_59_45.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Max_def_fineTemp_L_12__Q_16__sweeps_10e6_Date_Mon_22_Feb_2021_11_23_38.jld")["sim"],
)#=
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-21/Metropolis_Max_def_wideTemp_L_14__Q_16__sweeps_10e6_Date_Sun_21_Feb_2021_17_50_34.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-21/Metropolis_Max_def_wideTemp_L_16__Q_16__sweeps_10e6_Date_Sun_21_Feb_2021_22_09_39.jld")["sim"],
)=#

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




"""
Graphing Binder's ration corssing.

k::Int64 : data corresonpdoing to J1=J1s[k] is running.
"""
function Bcrossing(; Temp = range(0.3, 0.7, length = 100)#=range(0.56, 0.648, length = 50)=#, Ls = [6, 8, 10, 12], k)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "Binder's ratio",
        title = "size:6,8,10,12; Q = 16; J_1 = $(J1s[k])",
        legend = :bottomleft,
    )
    for i = 1:length(Ls)
        plot!(Temp, sim[i][3][k], label = "L = $(Ls[i])")
    end
    #=
    if k == 3
        MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/caliboration/Binder_Calib/050Binder.dat")
        plot!(Temp, MaxBinder, label = "Max's calculation, J1 = 0.5, L = 6")
    end
    if k == 6
        MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/caliboration/Binder_Calib/040Binder.dat")
        plot!(Temp, MaxBinder, label = "Max's calculation, J1 = 0.4, L = 6")
    end
    if k == 7
        MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/caliboration/Binder_Calib/045Binder.dat")
        plot!(Temp, MaxBinder, label = "Max's calculation, J1 = 0.45, L = 6")
    end=#

    savefig("Bcrossing_graph/Bcrossing_fineTemp_J1_$(J1s[k])_Q_$Q.svg")
end

for k = 1:length(J1s)
    Temps = [
        [0.61, 0.63],
        [0.59, 0.6],
        [0.56, 0.58],
        [0.61, 0.63],
        [0.68, 0.75],
        [0.57, 0.59],
        [0.57, 0.58],
    ]
    Bcrossing(k = k,Temp = range(Temps[k][1], Temps[k][2], length = 10))
end
#3,6,7
