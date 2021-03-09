include("confs_Max_def.jl")
using JLD
using Dates

struct state4storage
    E::Float64
    conf::Array{Int64,2}
    function state4storage(E::Float64, conf::Array{Int64,2})
        new(E, conf)
    end
end

function Ground_state_search(; J = [0.0, 1.0], L = 2, Q = 4)
    test_state = microstate(J = J, L = L, Q = Q, conf = ones(Int64, L, L))
    E = test_state.E
    lowest_E_states = state4storage[state4storage(Inf, test_state.conf)]
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
                if test_state.E == lowest_E_states[1].E
                    push!(
                        lowest_E_states,
                        state4storage(copy(test_state.E), copy(test_state.conf)),
                    )
                elseif test_state.E < lowest_E_states[1].E
                    lowest_E_states = state4storage[]
                    push!(
                        lowest_E_states,
                        state4storage(copy(test_state.E), copy(test_state.conf)),
                    )
                end
            end
        end
    end
    looping_over_state(n = L^2, Q = Q)
    #Output results
    #=for i = 1:length(lowest_E_states)
        println(lowest_E_states[i].conf)
    end=#
    println("For L = $(L), Q = $(Q), J = [$(J[1]), $(J[2])], Lowest E is $(lowest_E_states[1].E), and degeneracy is $(length(lowest_E_states))")

    return lowest_E_states
end

L = 4; Q = 2;J = [1,1]
@time lowest_E_states = Ground_state_search(J = J, L = L, Q = Q)

my_time = Dates.now()
save(
    "/nfs/home/zyt329/Research/Synthetic_dim_code/Ground_state_search/Nonperiodic_L$(L)_Q$(Q)_J_[$(J[1]),$(J[2])]_Date$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld",
    "lowest_E_states",
    lowest_E_states,
)
println("L=$L, Q=$Q, L$(L)_Q$(Q)_J_[$(J[1]),$(J[2])] finished search at $(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS"))")
