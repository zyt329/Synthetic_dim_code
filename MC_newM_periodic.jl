include("confs_newM_periodic.jl")
using Plots
using JLD
using Dates
using Statistics

function cal_M2(M::Array{Float64,1}, Q::Int64)
    M2 = 0
    for i = 1:Q
        for j = 1:Q
            M2 += M[i] * M[j] * (Q * ==(i, j) - 1) / (Q - 1)
        end
    end
    return M2
end

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
    sweeps::Int64 = 10^4,
    cutoff::Int64 = Int(floor(0.8 * sweeps)),
    σ::Float64 = 1.0,
    J = [1.0],
    L::Int64 = 8,
    Q::Int64 = 16,
    init_conf::Array{Int64,2} = ones(Int64, L, L),
)
    conf = microstate(J = J, L = L, Q = Q, conf = init_conf)
    L = conf.L
    Q = conf.Q
    samples = sample()
    σ = 6
    change_range = vcat(-σ:-1, 1:σ)
    for i = 1:sweeps
        #index = prop_index(conf)
        for m = 1:L
            for n = 1:L
                #val = mod1(conf.conf[m, n] + rand(change_range), conf.Q)
                val = rand(1:Q)
                #val = mod1(conf.conf[m,n] + Int(ceil(rand(Normal(0, σ)))), conf.Q)
                if accept(conf, (m, n), val, T)
                    update(conf, (m, n), val)
                end
            end
        end
        i < cutoff + 1 && continue

        push!(samples.E, conf.E)
        M = Float64[]
        M0 = copy(conf.M)
        maxind = findmax(M0)[2]
        for i = maxind:(maxind+Q-1)
            push!(M, M0[mod1(i, Q)])
        end
        push!(samples.M, M)
    end
    #println("length of sample is ", length(samples))
    return (samples, conf.conf)
end
