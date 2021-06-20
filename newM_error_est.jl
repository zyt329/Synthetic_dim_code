include("MC_newM_periodic.jl")
include("Temp_range_gen.jl")
include("error_analysis.jl")

"""
Run the simulation for a series of different temps.

Output:

Simulation::Array{Array,1} : It's an array that is of length 5.
    1st entry : An array of Average E values for the simulated ranges of temperatures.
    2nd entry : An array of Average C values for the simulated ranges of temperatures.
    3rd entry : An array of Average Binder's ratios for the simulated ranges of temperatures.
    4th entry : An array of ranges of temperatures that is simulated for different J1 values. Each entry correspond to one J1 value.
    5th entry : An array of simulated J1 values.

"""
function driver(;
    L = 8,
    Q = 16,
    J1 = [range(0.0, 1.0, length = 5); 0.4; 0.45],
    sweeps = 10^6,
    Temp = range(0.3,0.7,length=50),
)
    #Temp = [0.4, 0.6]
    #L = 16##more variables can be specified here

    Esim = []
    Csim = []
    Bsim = []
    simulation = []
    #=Temps = [
        [0.598,0.603],
        [0.573,0.588],
        [0.552,0.557],
        [0.5899,0.5904],
        [0.55,0.60],
        [0.556,0.561],
        [0.555,0.560],
    ]=#
    Temperatures = []
    for k = 1:length(J1)
        #=Temp = range(Temps[k][1], Temps[k][2], length = 5)=#
        #Temp = Temp_range_gen(J = J1[k])
        Esamples = []
        Csamples = []
        Bsamples = []
        init_conf::Array{Int64,2} = ones(Int64, L, L)
        for T in Temp
            samples = sampling(
                T = T,
                J = [1.0, J1[k]],
                L = L,
                Q = Q,
                sweeps = sweeps,
                init_conf = init_conf,
            )
            samplelength = length(samples[1].E)
            Eavg = 0
            E2avg = 0
            for i = 1:samplelength
                Eavg += samples[1].E[i]
                E2avg += (samples[1].E[i])^2
            end
            Eavg = Eavg / samplelength
            E2avg = E2avg / samplelength
            C = 1 / T^2 * (E2avg - Eavg^2) / L^2
            Eavg = Eavg / L^2
            push!(Esamples, Eavg)
            push!(Csamples, C)
            # Calculating B
            M2_values = Float64[]
            M4_values = Float64[]
            M2 = 0
            M4 = 0
            for M in samples[1].M
                Δ = cal_M2(M, Q)
                M2 += Δ
                M4 += Δ^2
                push!(M2_values, Δ)
                push!(M4_values, Δ^2)
            end
            M2 = M2 / samplelength
            M4 = M4 / samplelength
            B = 1 - M4 / ((1+2/(Q-1)) * M2^2)
            println()
            println("MCMC At T=$T, L=$L; B=$B, M2=$M2, M4=$M4, E=$Eavg, C=$C")
            M2_error = error_binning(M2_values)
            M4_error = error_binning(M4_values)
            println("error of B is estimated to be $(B*sqrt((M4_error/M4)^2+(2*M2_error/M2)^2)), error of M2 is $(M2_error), error of M4 is $(M4_error)")
            push!(Bsamples, B)
            #output the final configuration as the initial conf for the next temperature.
            init_conf = samples[2]
        end
        push!(Esim, Esamples)
        push!(Csim, Csamples)
        push!(Bsim, Bsamples)
        push!(Temperatures, Temp)
    end
    push!(simulation, Esim)
    push!(simulation, Csim)
    push!(simulation, Bsim)
    push!(simulation, Temperatures)
    push!(simulation, J1)
    #plot(Temp, Esamples)
    #plot!(Temp, Csamples)

    return simulation

end
L = 3;Q = 4;
J1 = [0.6]#=range(0.0, 1.15, length = 6)=#;sweeps = 10^7;Temp = [0.5]
#range(0.01, 1, length = 50)#Temp range determined by fcn in the driver, not here.
content = "Wolff_newM_J1000_115_Q5_sweep10e6"
sim = driver(L = L, Q = Q, J1 = J1, sweeps = sweeps, Temp = Temp)
