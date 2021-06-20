include("confs_Wolff_newM.jl")
using Plots
using JLD
using Dates

"""
Function to calculate difference in bond energy when change one of the Pott's variable's value.
"""
function bond_energy_diff(
    conf::microstate,
    current_index::Tuple{Int64,Int64},
    neighb::Tuple{Int64,Int64},
    val::Int64,
)
    Q = conf.Q
    S = conf.conf
    q = length(conf.J)
    J = conf.J
    current_val = S[current_index[1], current_index[2]]
    neighb_val = S[neighb[1], neighb[2]]
    ΔE = 0
    for k = 1:q
        if (
            val - mod1(current_val + (k - 1), Q) == 0 ||
            val - mod1(current_val - (k - 1), Q) == 0
        )
            ΔE += J[k]
        end
        if (
            current_val - mod1(neighb_val + (k - 1), Q) == 0 ||
            current_val - mod1(neighb_val - (k - 1), Q) == 0
        )
            ΔE -= J[k]
        end
        #=if abs(val - current_val) == (k - 1)
            ΔE += J[k]
        end
        if abs(current_val - neighb_val) == (k - 1)
            ΔE -= J[k]
        end=#
    end
    return ΔE
end

"""
Function to decide whether to form a bond.

Input:
conf::spins : current state of the lattice
x::Tuple : A Tuple of index of spin that's inside the Wolff's cluster(flipped spin in the Wolff's algorithm)
y::Tuple : A Tuple of index of spin that represents the spin to be flipped

output:
true for a bond, false for no bond
"""
function bond(
    conf::microstate,
    current_index::Tuple{Int64,Int64},
    neighb::Tuple{Int64,Int64},
    val::Int64,
    T::Float64,
)
    J = conf.J
    p = 1 - exp(min(0, -1 / T * bond_energy_diff(conf, current_index, neighb, val)))
    r = rand()
    if r < p
        return true
    else
        return false
    end
end


"""
function to construct the Wolff cluster and flip all of the spins in the cluster.

Input:
conf::spins : configuration of the system.


Output:
nothing

"""
function Wolff_update(conf::microstate, T::Float64)
    """
    Search function to be performed recursively to complete a depth-first search of the entire lattice for the Wolff Cluster. Meanwhile flip the spins that's been reached.

    Input :
    conf::spins : configuration of the current state.
    current_index::Tuple : index of the current position.

    """
    discovered = Tuple{Int64,Int64}[]
    new_val_range = (1:conf.Q)#vcat(-3:-1, 1:3)
    function search_flip(
        conf::microstate,
        current_index::Tuple{Int64,Int64},
        val::Int64,
        T::Float64,
    )
        L = conf.L
        update(
            conf,
            current_index,
            mod1(conf.conf[current_index[1], current_index[2]] + val, conf.Q),
        )
        push!(discovered, current_index)
        neighbours = (
            (mod1(current_index[1] + 1, L), current_index[2]),
            (current_index[1], mod1(current_index[2] + 1, L)),
            (mod1(current_index[1] - 1, L), current_index[2]),
            (current_index[1], mod1(current_index[2] - 1, L)),
        )
        for neighb in neighbours
            if (neighb ∉ discovered) && bond(
                conf,
                current_index,
                neighb,
                mod1(conf.conf[neighb[1], neighb[2]] + val, conf.Q),
                T,
            )
                search_flip(conf, neighb, val, T)
            end
        end
    end
    proposed_index = prop_index(conf)
    val = rand(new_val_range)
    search_flip(conf, proposed_index, val, T)
    #println(discovered)
    #return conf
    nothing
end

function cal_M2(M::Array{Float64,1}, Q::Int64)
    M2 = 0
    for i = 1:Q
        for j = 1:Q
            M2 += M[i] * M[j] * (Q * ==(i,j) - 1) / (Q - 1)
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
    sweeps::Int64 = 10^5,
    cutoff::Int64 = Int(floor(0.4 * sweeps)),
    σ::Float64 = 1.0,
    J = [1.0],
    L::Int64 = 16,
    Q::Int64 = 32,
    init_conf::Array{Int64,2} = ones(Int64, L, L),
)
    conf = microstate(J = J, L = L, Q = Q, conf = init_conf)
    L = conf.L
    Q = conf.Q
    samples = sample()
    for i = 1:sweeps
        Wolff_update(conf, T)
        i < cutoff + 1 && continue

        push!(samples.E, conf.E)
        push!(samples.M, copy(conf.M))
    end
    #println("length of sample is ", length(samples))
    return (samples, conf.conf)
end
