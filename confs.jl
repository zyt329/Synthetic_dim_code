using Random, Distributions

"""
Kronecker Delta function
"""
function delta(x, y)
    if x == y
        return 1
    else
        return 0
    end
end

function Energy(J,L,Q,conf)
    S = conf
    E0 = 0
    n = length(J)
    for i = 1:L
        for j = 1:L
            for k = 1:n
                if k == 1
                    E0 -=
                        0.5 *
                        J[k] *
                        (
                            delta(S[i, j], S[mod1(i - 1, L), j] + (k - 1)) +
                            delta(S[i, j], S[mod1(i + 1, L), j] + (k - 1)) +
                            delta(S[i, j], S[i, mod1(j - 1, L)] + (k - 1)) +
                            delta(S[i, j], S[i, mod1(j + 1, L)] + (k - 1))
                        )
                else
                    E0 -=
                        0.5 *
                        J[k] *
                        (
                            delta(S[i, j], S[mod1(i - 1, L), j] + (k - 1)) +
                            delta(S[i, j], S[mod1(i + 1, L), j] + (k - 1)) +
                            delta(S[i, j], S[i, mod1(j - 1, L)] + (k - 1)) +
                            delta(S[i, j], S[i, mod1(j + 1, L)] + (k - 1)) +
                            delta(S[i, j], S[mod1(i - 1, L), j] - (k - 1)) +
                            delta(S[i, j], S[mod1(i + 1, L), j] - (k - 1)) +
                            delta(S[i, j], S[i, mod1(j - 1, L)] - (k - 1)) +
                            delta(S[i, j], S[i, mod1(j + 1, L)] - (k - 1))
                        )
                end
            end
        end
    end
    return E0
end

"""
Represent a microstate.

fields:  T, L, steps, dimension, spin
"""
struct microstate
    J::Array{Any,1}
    L::Int64
    Q::Int64
    conf::Array{Int64,2}
    E::Any
    function microstate(
        J = [1.0, 0, 0],
        L::Int64 = 8,
        Q::Int64 = 32,
        conf::Array{Int64,2} = ones(Int64, L, L),
        E::Float64 = Energy(J,L,Q,conf)
    )
        new(J, L, Q, conf, E)
    end
    function microstate(;
        J = [1.0, 0, 0],
        L::Int64 = 8,
        Q::Int64 = 32,
        conf::Array{Int64,2} = ones(Int64, L, L),
        E::Float64 = Energy(J,L,Q,conf)
    )
        new(J, L, Q, conf, E)
    end
    @assert(microstate().E == -128, "Something wrong with the energy calculation")

end

"""
Calculate the energy difference after changing one variable.

Parameter:
conf::spins : Input the state
index::Tuple : An Tuple of index of the flipped spin.
"""
function Energy_Diff(conf::microstate, index::Tuple, val::Int64)
    J = conf.J
    L = conf.L
    S = conf.conf
    q = length(conf.J)
    m = index[1]
    n = index[2]
    @assert(
        m <= L && m >= 1 && n <= L && n >= 1,
        "The Index of flipped spin should be within range"
    )
    ΔE = 0
    for k = 1:q
        if k == 1
            ΔE -=
                J[k] *
                (
                    delta(val, S[mod1(m - 1, L), n] + (k - 1)) +
                    delta(val, S[mod1(m + 1, L), n] + (k - 1)) +
                    delta(val, S[m, mod1(n - 1, L)] + (k - 1)) +
                    delta(val, S[m, mod1(n + 1, L)] + (k - 1)) -
                    delta(S[m, n], S[mod1(m - 1, L), n] + (k - 1)) -
                    delta(S[m, n], S[mod1(m + 1, L), n] + (k - 1)) -
                    delta(S[m, n], S[m, mod1(n - 1, L)] + (k - 1)) -
                    delta(S[m, n], S[m, mod1(n + 1, L)] + (k - 1))
                )
        else
            ΔE -=
                J[k] *
                (
                    delta(val, S[mod1(m - 1, L), n] + (k - 1)) +
                    delta(val, S[mod1(m + 1, L), n] + (k - 1)) +
                    delta(val, S[m, mod1(n - 1, L)] + (k - 1)) +
                    delta(val, S[m, mod1(n + 1, L)] + (k - 1)) +
                    delta(val, S[mod1(m - 1, L), n] - (k - 1)) +
                    delta(val, S[mod1(m + 1, L), n] - (k - 1)) +
                    delta(val, S[m, mod1(n - 1, L)] - (k - 1)) +
                    delta(val, S[m, mod1(n + 1, L)] - (k - 1)) -
                    delta(S[m, n], S[mod1(m - 1, L), n] + (k - 1)) -
                    delta(S[m, n], S[mod1(m + 1, L), n] + (k - 1)) -
                    delta(S[m, n], S[m, mod1(n - 1, L)] + (k - 1)) -
                    delta(S[m, n], S[m, mod1(n + 1, L)] + (k - 1)) -
                    delta(S[m, n], S[mod1(m - 1, L), n] - (k - 1)) -
                    delta(S[m, n], S[mod1(m + 1, L), n] - (k - 1)) -
                    delta(S[m, n], S[m, mod1(n - 1, L)] - (k - 1)) -
                    delta(S[m, n], S[m, mod1(n + 1, L)] - (k - 1))
                )
        end
    end
    return ΔE
end
println(Energy_Diff(microstate(), (1,1), 0))

"""
Choose an index of Potts variable to change value.

Parameter:
conf::spins : the system

Return:
A tuple of index of the spin to flip
"""
function prop_index(conf::microstate)
    (rand(1:conf.L), rand(1:conf.L))
end



"""
Function to propose a new configuration of the current microstate in the Markov Chian. Including a position and a new value for the randomly selected Potts variable.

Parameter:
conf::microstate : current configuration.
index::Tuple : indexs of the changed variable.
val::Int64 : Proposed value for the Potts variable.

Return:
new_config::microstate : the new configuration.
"""
function prop_conf(conf::microstate, index::Tuple, val::Int64)
    new_E = conf.E + Energy_Diff(conf, index, val)
    config = copy(conf.conf)
    config[index[1], index[2]] = val
    new_state = microstate(conf.J, conf.L, conf.Q, config, new_E)
    return new_state
end

"""
Deciding whether to accept a proposed chagne or not

Parameter:
conf::spins : The current state.
index::Tuple : A tuple of spin index to flip.

Return:
true of false. true means to flip false means not to
"""
function evol_cond(conf::microstate, index::Tuple, val, T::Float64)
    #index = flip_index(conf.dimension)
    ΔE = Energy_Diff(conf, index, val)

    p = exp(-ΔE / T) / (1 + exp(-ΔE / T))
    r = rand()
    if r < p
        return true
    else
        return false
    end
end
