using Plots
using JLD

J1s = [range(0.0, 1.0, length = 5); 0.4; 0.45]
Q = 16

sim = []
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp4_L_6__Q_16__sweeps_10e7_Date_Fri_26_Feb_2021_21_08_54.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp3_L_6__Q_16__sweeps_10e7_Date_Fri_26_Feb_2021_21_06_42.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp2_L_6__Q_16__sweeps_10e7_Date_Fri_26_Feb_2021_01_12_44.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp4_L_8__Q_16__sweeps_10e7_Date_Sat_27_Feb_2021_01_20_36.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp3_L_8__Q_16__sweeps_10e7_Date_Sat_27_Feb_2021_01_06_41.jld")["sim"],
)
push!(
    sim,
    load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp2_L_8__Q_16__sweeps_10e7_Date_Fri_26_Feb_2021_08_27_14.jld")["sim"],
)


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
function Bcrossing(; Temp = range(0.3, 0.7, length = 100), Ls = [6, 8, 10, 12], k)#=range(0.56, 0.648, length = 50)=#
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

    savefig("Bcrossing_graph/Bcrossing_Wolff_fineTemp_10e7_2Ls_J1_$(J1s[k])_Q_$Q.png")
end
#println(sim[1][3])
println(length(cat(sim[1:length(sim)][3][1]..., dims = 1)'))
function add_Egraph(; Temp, sim::Array, L, k)
    Evalues = []
    for i in 1:length(sim)
        push!(Evalues, sim[i][1][k])
    end
    E = cat(Evalues..., dims = 1)
    plot!(Temp, E, label = "L = $(L)")
end

for k = 1:length(J1s)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "Internal Energy",
        title = "size:6,8; Q = 16; J_1 = $(J1s[k])",
        legend = :topleft,
    )
    Ls = [6, 8]
    Temps1 = [
        [0.598, 0.603],
        [0.573, 0.588],
        [0.552, 0.557],
        [0.5899, 0.5904],
        [0.55, 0.60],
        [0.556, 0.561],
        [0.555, 0.560],
    ]
    Temps2 = [
        [0.605, 0.61],
        [0.580, 0.584],
        [0.559, 0.564],
        [0.5905, 0.591],
        [0.60, 0.65],
        [0.562, 0.567],
        [0.561, 0.565],
    ]
    Temps3 = [
        [0.615, 0.625],
        [0.585, 0.597],
        [0.565, 0.575],
        [0.60, 0.61],
        [0.65, 0.75],
        [0.568, 0.576],
        [0.566, 0.574],
    ]
    Temp = cat(
        range(Temps1[k][1], Temps1[k][2], length = 5),
        range(Temps2[k][1], Temps2[k][2], length = 5),
        range(Temps3[k][1], Temps3[k][2], length = 10),
        dims = 1,
    )
    add_Egraph(L = 6, Temp = Temp, sim = [sim[1], sim[2], sim[3]], k = k)
    add_Egraph(L = 8, Temp = Temp, sim = [sim[4], sim[5], sim[6]], k = k)

    for L in (6,8)
        #Since Max didn't run J1=1, skip J1 = 1.
        J1s[k] == 1 && continue
        index_ini = Int(floor(J1s[k]/0.02))*50 + 1
        index_final = index_ini + 49
        Max_Temp = range(0.56,0.648,length = 50)
        MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Max_$(L)_E.txt")
        plot!(Max_Temp, MaxBinder[index_ini: index_final], label = "Max, J1 = $(floor(J1s[k]/0.02)*0.02), L = $(L)")
    end

    savefig("Bcrossing_graph/Egraphs_Wolff_fineTemp_10e7_2Ls_J1_$(J1s[k])_Q_$(Q)_combined.png")
end
#3,6,7
