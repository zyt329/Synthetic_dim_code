include("confs_wolff_newM.jl")
include("MC_corrected_newM.jl")
using JLD
using Dates

struct state4storage
    E::Float64
    conf::Array{Int64,2}
    function state4storage(E::Float64, conf::Array{Int64,2})
        new(E, conf)
    end
end

function enumerate(; J = [0.0, 1.0], L = 2, Q = 4, T = 0.5)
    test_state = microstate(J = J, L = L, Q = Q, conf = ones(Int64, L, L))
    Z = 0.0
    E = 0.0
    E2 = 0.0
    M2 = 0.0
    M4 = 0.0
    #generating states
    sites = []
    for i = 1:L
        for j = 1:L
            push!(sites, (i, j))
        end
    end
    #loop over states and find the ground state
    function looping_over_state(; n::Int64, Q::Int64, sites = sites)
        if n != 1
            for val = 1:Q
                update(test_state, sites[n], val)
                looping_over_state(n = n - 1, Q = Q, sites = sites)
            end
        else
            for val = 1:Q
                update(test_state, sites[n], val)
                E_state = test_state.E
                Boltzman_fct = exp(-1 / T * E_state)
                Z += Boltzman_fct
                E += E_state * Boltzman_fct
                E2 += E_state^2 * Boltzman_fct
                ΔM2 = cal_M2(test_state.M, test_state.Q)
                M2 += ΔM2 * Boltzman_fct
                M4 += ΔM2^2 * Boltzman_fct
            end
        end
    end
    looping_over_state(n = L^2, Q = Q)
    #@assert (Z !== Inf,"partition function too big to handle")
    println("Z=$Z")
    E = E/Z/L^2; E2 = E2/Z;M2 = M2/Z; M4 = M4/Z
    B = 1 - M4 / ((1+2/(Q-1)) * M2^2)
    C = 1 / T^2 * (E2 - (E*L^2)^2) / L^2
    println("For L = $(L), Q = $(Q), J = [$(J[1]), $(J[2])],E=$E, M^2=$M2, M^4=$M4, B=$B, C=$C")

    return nothing
end

L = 2 ;Q = 4 ;J = [1.0, 0.6]; T = 0.5
@time lowest_E_states = enumerate(J = J, L = L, Q = Q)
