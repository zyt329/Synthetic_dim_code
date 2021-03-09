using Plots
using JLD

sim1 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Max_def_nonperiodic_test_L_6__Q_16__sweeps_1000000_Date_Tue_02_Mar_2021_19_03_26.jld")["sim"]
sim2 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Max_def_nonperiodic_test_L_8__Q_16__sweeps_1000000_Date_Tue_02_Mar_2021_19_59_42.jld")["sim"]
sim3 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Max_def_nonperiodic_test_L_12__Q_16__sweeps_1000000_Date_Tue_02_Mar_2021_22_39_17.jld")["sim"]
sim5 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Wolff_wideTempcomparision_L_8__Q_16__sweeps_10e6_Date_Thu_25_Feb_2021_02_32_50.jld")["sim"]
sim4 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Wolff_wideTempcomparision_L_6__Q_16__sweeps_10e6_Date_Thu_25_Feb_2021_00_35_35.jld")["sim"]
sim6 = load("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Remote_result_Feb-22/Metropolis_Wolff_wideTempcomparision_L_12__Q_16__sweeps_10e6_Date_Thu_25_Feb_2021_08_46_15.jld")["sim"]

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

function Eplotting()
    Temp = range(0.4, 0.9, length = 100)#range(0.550, 0.696, length = 50)
    Tempwolff = range(0.4, 0.9, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "E_site",
        title = "E_site : 6*6, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [range(0.0, 1.0, length = 5);0.4;0.45]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 5:5#1:length(J1)
        plot!(Temp, sim1[1][k], label = "Periodic_J1 = $(J1[k])L6")#"J1 = $(J1[k])")
    end
    for k = 5:5#1:length(J1)
        plot!(Temp, sim2[1][k], label = "Periodic_J1 = $(J1[k])L8")
    end
    for k = 5:5#1:length(J1)
        plot!(Temp, sim3[1][k], label = "Periodic_J1 = $(J1[k])L12")
    end
    for k = 5:5#1:length(J1)
        plot!(Tempwolff, sim4[1][k], label = "Wolff_J1 = $(J1[k])L6")
    end
    for k = 5:5#1:length(J1)
        plot!(Tempwolff, sim5[1][k], label = "Wolff_J1 = $(J1[k])L8")
    end
    for k = 5:5#1:length(J1)
        plot!(Tempwolff, sim6[1][k], label = "Wolff_J1 = $(J1[k])L12")
    end
    #=
    for k = 1:3#1:length(J1)
        #plot!(Temp, sim3[1][k], label = "Wolff_J1 = $(J1[k])")
        for L in (6)
            #Since Max didn't run J1=1, skip J1 = 1.
            J1[k] == 1 && continue
            index_ini = Int(floor(J1[k]/0.02))*50 + 1
            index_final = index_ini + 49
            Max_Temp = range(0.56,0.648,length = 50)
            MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Max_$(L)_E.txt")
            plot!(Max_Temp, MaxBinder[index_ini: index_final], label = "Max, J1 = $(floor(J1[k]/0.02)*0.02), L = $(L)")
        end
    end=#

    #plot!(Temp, MAX_T, label = "MAX_Result_J1 = 0.4")
    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/test/Eplots_J1=1.0_wolff10e6_VS_periodic.png")
end

function Cplotting()
    Temp = range(0.4, 0.9, length = 50)#range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
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

    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Wolff_comparision/Cplots1_wolff10e6_VS_nonperiodic.svg")
end

function Bplotting()
    Temp = range(0.56, 0.648, length = 50)#range(0.56, 0.648, length = 50)#range(0.550, 0.696, length = 50)
    Temp1 = range(0.4, 0.9, length = 100)
    Temp2 = range(0.4, 0.9, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "B",
        title = "B : 6*6, Q = 16, J_0 = 1.0",
        legend = :bottomleft,
    )
    J1 = [range(0.0, 1.0, length = 5);0.4;0.45]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]

    for k = 2#length(J1)
        plot!(Temp1, sim1[3][k], label = "L6_nonperiodic_J1 = $(J1[k])")
    end
    for k = 2#length(J1)
        plot!(Temp1, sim2[3][k], label = "L8_nonperiodic_J1 = $(J1[k])")
    end
    for k = 2#length(J1)
        plot!(Temp2, sim3[3][k], label = "L6_Wolff_Periodic_J1 = $(J1[k])")
    end
    for k = 2#length(J1)
        plot!(Temp2, sim4[3][k], label = "L8_Wolff_Periodic_J1 = $(J1[k])")
    end

    for k = 2#1:length(J1)
        #plot!(Temp, sim3[1][k], label = "Wolff_J1 = $(J1[k])")
        for L in (6,8)
            #Since Max didn't run J1=1, skip J1 = 1.
            J1[k] == 1 && continue
            index_ini = Int(floor(J1[k]/0.02))*50 + 1
            index_final = index_ini + 49
            Max_Temp = range(0.56,0.648,length = 50)
            MaxBinder = file2array("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/Bcrossing_result/Max_$(L)_B.txt")
            plot!(Max_Temp, MaxBinder[index_ini: index_final], label = "Max, J1 = $(floor(J1[k]/0.02)*0.02), L = $(L)")
        end
    end
    savefig("E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/test/Bplots1_wolff10e6_VS_nonperiodic.png")
end
Eplotting()
#Cplotting()
#Bplotting()
