include("confs.jl")
using Plots
using JLD
using Dates

"""
Function to generate and store samples for a single temperature.

Parameter:
T::Float64 : Temperature
steps::Int64 : steps of the Monte Carlo Simulation
cutoff::Int64 : After the cutoff do we start to take down the samples.
σ::Float64 : Variation of the proposed new value for the Potts value each step in the simulation.

Output:
Samples::Array{microstate,1} : An Array of samples, each entry is of type microstate, representing one microstate.
"""
function sampling(;
    T::Float64,
    steps::Int64 = 10^8,
    cutoff::Int64 = Int(floor(0.4 * steps)),
    σ::Float64 = 1.0,
    J = [1.0, 0, 0],
    L::Int64 = 16,
    Q::Int64 = 32,
    init_conf::Array{Int64,2} = ones(Int64, L, L),
)
    conf = microstate(J = J, L = L, Q = Q, conf = init_conf)
    samples = [conf]
    for i = 1:steps
        index = prop_index(conf)
        val = mod1(conf.conf[index[1], index[2]] + Int(ceil(rand(Normal(0, σ)))), conf.Q)
        if evol_cond(conf, index, val, T)
            conf = prop_conf(conf, index, val)
        end
        i < cutoff + 1 && continue

        push!(samples, conf)

    end
    #println("length of sample is ", length(samples))
    return samples
end


"""
Run the simulation for a series of different temps.

Output:


"""
function driver()
    #Temp = range(0.01, 1.5, length = 100)
    Temp = [0.4, 0.6]

    #Esamples = []
    #Csamples = []
    #=
    simulation = Dict()
    for J1 in [0, 0.4, 0.8, 1]
    simulation["J1=$J1"] = []
    for T in Temp
        push!(simulation["J1=$J1"], sampling(T = T, J = [1.0, J1, 0]))
    end
    end
    =#
    Esim=[]
    Csim=[]
    simulation = []
    J1 = [0, 0.4, 0.8, 1]
    for k in 1:length(J1)
        #=
        simulation["E(T)"][k] = []
        simulation["C(T)"][k] = []=#
        Esamples = []
        Csamples = []
        for T in Temp
            samples = sampling(T = T, J = [1.0, J1[k], 0])
            Eavg = 0
            E2avg = 0
            for i = 1:length(samples)
                Eavg += samples[i].E
                E2avg += (samples[i].E)^2
            end
            Eavg = Eavg / length(samples)
            E2avg = E2avg / length(samples)
            C = 1 / T^2 * (E2avg - Eavg^2) / (samples[1].L)^2
            Eavg = Eavg / samples[1].L^2

            push!(Esamples, Eavg)
            push!(Csamples, C)
        end
        push!(Esim,Esamples)
        push!(Csim,Csamples)
    end
    push!(simulation,Esim)
    push!(simulation,Csim)
    #plot(Temp, Esamples)
    #plot!(Temp, Csamples)

    return simulation

end
@time sim = driver()
#=
println(length(sim[1][1]))
println(length(sim[1][1]))=#
my_time = Dates.now()
save("Cal_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld", "sim", sim)
#=
save("Result_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld", "sim", sim)
=#
