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

function Energy(J, L, Q, conf)
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
                            delta(S[i, j], mod1(S[mod1(i - 1, L), j] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[mod1(i + 1, L), j] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j - 1, L)] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j + 1, L)] + (k - 1), Q))
                        )
                else
                    E0 -=
                        0.5 *
                        J[k] *
                        (
                            delta(S[i, j], mod1(S[mod1(i - 1, L), j] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[mod1(i + 1, L), j] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j - 1, L)] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j + 1, L)] + (k - 1), Q)) +
                            delta(S[i, j], mod1(S[mod1(i - 1, L), j] - (k - 1), Q)) +
                            delta(S[i, j], mod1(S[mod1(i + 1, L), j] - (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j - 1, L)] - (k - 1), Q)) +
                            delta(S[i, j], mod1(S[i, mod1(j + 1, L)] - (k - 1), Q))
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
mutable struct microstate
    J::Array{Float64,1}
    L::Int64
    Q::Int64
    conf::Array{Int64,2}
    E::Float64
    M::Array{Float64,1}
    function cal_M(conf::Array{Int64,2}, Q::Int64, L::Int64)
        M = zeros(Q)
        for s in conf
            M[s] += 1
        end
        M = M / L^2
        return M
    end
    function microstate(
        J = [1.0, 0, 0],
        L::Int64 = 8,
        Q::Int64 = 32,
        conf::Array{Int64,2} = ones(Int64, L, L),
    )
        E::Float64 = Energy(J, L, Q, conf)
        M = cal_M(conf, Q, L)
        new(J, L, Q, conf, E, M)
    end
    function microstate(;
        J = [1.0, 0, 0],
        L::Int64 = 8,
        Q::Int64 = 32,
        conf::Array{Int64,2} = ones(Int64, L, L),
    )
        E::Float64 = Energy(J, L, Q, conf)
        M = cal_M(conf, Q, L)
        new(J, L, Q, conf, E, M)
    end
    @assert(microstate().E == -128, "Something wrong with the energy calculation")

end


"""
Calculate the energy difference after changing one variable. Implementing Periodic condition on interacting states.

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
    Q = conf.Q
    ΔE = 0
    for k = 1:q
        if k == 1
            ΔE -=
                J[k] * (
                    delta(val, mod1(S[mod1(m - 1, L), n] + (k - 1), Q)) +
                    delta(val, mod1(S[mod1(m + 1, L), n] + (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n - 1, L)] + (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n + 1, L)] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m - 1, L), n] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m + 1, L), n] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n - 1, L)] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n + 1, L)] + (k - 1), Q))
                )
        else
            ΔE -=
                J[k] * (
                    delta(val, mod1(S[mod1(m - 1, L), n] + (k - 1), Q)) +
                    delta(val, mod1(S[mod1(m + 1, L), n] + (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n - 1, L)] + (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n + 1, L)] + (k - 1), Q)) +
                    delta(val, mod1(S[mod1(m - 1, L), n] - (k - 1), Q)) +
                    delta(val, mod1(S[mod1(m + 1, L), n] - (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n - 1, L)] - (k - 1), Q)) +
                    delta(val, mod1(S[m, mod1(n + 1, L)] - (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m - 1, L), n] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m + 1, L), n] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n - 1, L)] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n + 1, L)] + (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m - 1, L), n] - (k - 1), Q)) -
                    delta(S[m, n], mod1(S[mod1(m + 1, L), n] - (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n - 1, L)] - (k - 1), Q)) -
                    delta(S[m, n], mod1(S[m, mod1(n + 1, L)] - (k - 1), Q))
                )
        end
    end
    return ΔE
end
println(Energy_Diff(microstate(), (1, 1), 0))

#=
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
    current_val = S[m, n]
    neighbours = (S[mod1(m - 1, L), n], S[mod1(m + 1, L), n], S[m, mod1(n - 1, L)], S[m, mod1(n + 1, L)])
    ΔE = 0
    for neighb in neighbours
        for k in 1:q
            if abs(val- neighb) == (k-1)
                ΔE += J[k]
            end
            if abs(current_val - neighb) == (k-1)
                ΔE -= J[k]
            end
        end
    end
    return ΔE
end
println(Energy_Diff(microstate(), (1,1), 0))
=#

"""
Function to change the current configuration to a new configuration. Also change the energy.

Parameter:
conf::microstate : current configuration.
index::Tuple : indexs of the changed variable.
val::Int64 : Proposed value for the Potts variable.

Return:
nothing
"""
function update(conf::microstate, index::Tuple, val::Int64)
    conf.E += Energy_Diff(conf, index, val)
    conf.M[conf.conf[index[1], index[2]]] -= 1 / conf.L^2
    conf.M[val] += 1 / conf.L^2
    conf.conf[index[1], index[2]] = val
    #debug
    #println(conf.M)
    nothing
end

"""
Deciding whether to accept a proposed chagne or not

Parameter:
conf::spins : The current state.
index::Tuple : A tuple of spin index to flip.

Return:
true of false. true means to flip false means not to
"""
function accept(conf::microstate, index::Tuple, val, T::Float64)
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


"""

"""
struct sample
    E::Array{Float64,1}
    M::Array{Array{Float64,1},1}
    function sample()
        new(Float64[], Array{Float64,1}[])
    end
end



"""
Choose an index of Potts variable to change value. Won't need this function if I'm doing sweeping.

Parameter:
conf::spins : the system

Return:
A tuple of index of the spin to flip
"""
function prop_index(conf::microstate)
    (rand(1:conf.L), rand(1:conf.L))
end
