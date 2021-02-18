using Plots
using JLD

sim = load("Wolff.jld")["sim"]


function Eplotting()
    Temp = range(0.1, 1.0, length = 50)#range(0.550, 0.696, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "E_site",
        title = "E_site : 8 * 8, Q = 16, J_0 = 1.0",
        legend = :topleft,
    )
    J1 = [0.4]#range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:(length(J1)+1)
        plot!(Temp, sim[1][k], label = "$k")#"J1 = $(J1[k])")
    end

    #plot!(Temp, MAX_T, label = "MAX_Result_J1 = 0.4")
    savefig("Eplots1.svg")
end

function Cplotting()
    Temp = range(0.3, 1.0, length = 50)#range(0.550, 0.696, length = 50)
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
    Max_C = [
        3.3878527361821127
        3.5536276656345676
        3.4283657458882950
        4.4177896723225452
        5.0972946727005279
        5.0211590652229816
        5.7045807877319969
        8.1331762074205329
        7.2948042202461227
        9.5682521961962372
        10.869403160181095
        14.184649417103950
        18.058103837278690
        17.657856546312498
        21.694968853961626
        24.803619502838558
        25.604636227667893
        24.927664660390111
        24.238962110632301
        22.318684078414051
        18.680489036753738
        16.535709476455885
        11.371661852742118
        12.210111536263716
        10.327300141848246
        7.7318092473833708
        5.9394395099383699
        6.0080978485105589
        5.2693940002088224
        4.6098755261225968
        3.6243629851568002
        3.7140879703383249
        3.0714772275586522
        2.7034170657675527
        2.7965705851611520
        2.3371025835477268
        2.2469329088503569
        2.1931530878777803
        2.0534792046909680
        1.9995673217574497
        1.8712978145991379
        1.8433824056224588
        1.7491437461869175
        1.6398027373940327
        1.5608649534291497
        1.5289516420491229
        1.4701110389811460
        1.4412217133383853
        1.3816272385136472
        1.3199095564439149
    ]
    plot!(Temp, Max_C, label = "MAX_Result_J1 = 0.0")
    savefig("Cplots1.svg")
end

function Bplotting()
    Temp = range(0.3, 1.0, length = 50)#range(0.550, 0.696, length = 50)
    plot(
        dpi = 800,
        xlabel = "T",
        ylabel = "B",
        title = "B : 8 * 8, Q = 16, J_0 = 1.0",
        legend = :bottomright,
    )
    J1 = range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        plot!(Temp, sim[3][k], label = "J1 = $(J1[k])")
    end
    savefig("Bplots1.svg")
end
Eplotting()
#Cplotting()
#Bplotting()
