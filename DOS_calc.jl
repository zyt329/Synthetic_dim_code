using Statistics
using Plots
include("confs_Wolff_newM.jl")
nbins = 100

mutable struct Histogram
    hist::Array{Int64,1}
    max::Float64
    min::Float64
    nbins::Int64
    bin_size::Float64
    collection::Array{Float64,1}

    """
    Building a histogram for the input collection of E: E_collection

    input:
        collection::Array{Float64,1}
        keyword arguments:
        nbins::Int64 = 1000,
        max::Float64 = max(collection...),
        min::Float64 = min(collection...),

    output:
        hist::Array{Int64,1} : An array representing the histogram for collection, with its ith entry recording the number of E values of collection that belongs to the ith bin of the histogram.

    """
    function Histogram(
        collection::Array{Float64,1};
        nbins::Int64 = 1000,
        max::Float64 = Float64(max(collection...)),
        min::Float64 = Float64(min(collection...)),
    )
        bin_size = (max - min) / nbins
        hist = new(zeros(Int64, nbins), max, min, nbins, bin_size, collection)
        for val in collection
            @assert(val <= max, "The max is set too small.")
            @assert(val >= min, "The min is set too large.")
            if val == min
                hist.hist[1] += 1
                continue
            end
            ind = Int(ceil((val - min) / bin_size))
            if ind > nbins
                hist.hist[end] += 1
                continue
            end
            hist.hist[ind] += 1
        end
        return hist
    end

end


"""
Updating(change the input object) the input histogram: hist::Histogram by putting a new value: val::Float64 into it. Returning nothing.
"""
function update_hist!(hist::Histogram, val::Float64)
    if val < hist.min
        collection = push!(hist.collection, val)
        hist_tempo =
            Histogram(collection, nbins = hist.nbins, min = val, max = hist.max)
        hist.hist = hist_tempo.hist
        hist.min = val
        hist.bin_size = hist_tempo.bin_size
        push!(hist.collection, val)
        return nothing
    elseif val > hist.max
        collection = push!(hist.collection, val)
        hist_tempo =
            Histogram(collection, nbins = hist.nbins, min = hist.min, max = val)
        hist.hist = hist_tempo.hist
        hist.max = val
        hist.bin_size = hist_tempo.bin_size
        push!(hist.collection, val)
        return nothing
    elseif val == hist.min
        hist.hist[1] += 1
        push!(hist.collection, val)
        return nothing
    else
        ind = Int(ceil((val - hist.min) / hist.bin_size))
        hist.hist[ind] += 1
        push!(hist.collection, val)
        return nothing
    end
end

@debug begin
    @time(hist = Histogram(rand(Float64, 10000), nbins = 10))
    @time(update_hist(hist, 0.5))
    println(hist.hist)
    println(hist.max)
    println(hist.min)
    println(hist.nbins)
    println(hist.bin_size)
    println(hist.collection[end])
end

"""
Input histogram and the required flatness, output true or false depending on the histogram being flat enough or not.

Flatness is set between 0 and 1. If the (minimum value) of the histogram is bigger than the (maximum value) × (flatness), the histogram is considered flat. And the function outputs true.

When the total count in the histogram is more than 100 times the number of bins (nbins), the bins with 0 count is discarded since it might correspond to a no state zone.
"""
function flat_enough(hist::Histogram; flatness::Float64 = 0.9)
    @assert(
        flatness <= 1 && flatness > 0,
        "flatness has to be set between 0 and 1"
    )
    if sum(hist.hist) > nbins * 100
        nonzero_hist = Int64[]
        for count in hist.hist
            if count == 0
                continue
            else
                push!(nonzero_hist, count)
            end
        end
        return max(nonzero_hist...) * flatness < min(nonzero_hist...)
    else
        return max(hist.hist...) * flatness < min(hist.hist...)
    end
end

@debug begin

    println(
        flat_enough(
            Histogram(rand(Float64, 10000), nbins = 10),
            flatness = 0.90,
        ),
    )
end

"""
    given the current simulated lng(E) and the current_E, prop_E, decide whether to accept the proposed state. Need to input the corresponding histogram to access how you have binned the energy.
"""
function accept_WL(;
    lng::Array{Float64,1},
    current_E::Float64,
    prop_E::Float64,
    hist::Histogram,
)
    Eind_current = Int(ceil((current_E - hist.min) / hist.bin_size))
    Eind_prop = Int(ceil((prop_E - hist.min) / hist.bin_size))
    current_E == hist.min && (Eind_current = 1)
    prop_E == hist.min && (Eind_prop = 1)# in case index = 0 when E=min

    Prob = min(1, exp(lng[Eind_current] - lng[Eind_prop]))
    r = rand()
    if r < Prob
        return true
    else
        return false
    end
end

function Wang_Landau(;
    L = 10,
    Q = 2,
    J = [1.0, 0.0],
    f0::Float64 = 1.5,
    f_final = 1 + 10^(-5),
    init_conf::Array{Int64,2} = ones(Int64, L, L),
    nbins = 100,
    flatness = 0.9,
)
    Emax = 0.0
    Emin = -max(J...) * 2
    @assert(Emax > Emin, "Maximum energy should be bigger than minimum energy.")
    lng = zeros(Float64, nbins)

    conf = microstate(J = J, L = L, Q = Q, conf = init_conf)
    f = f0
    while f > f_final
        hist = Histogram(Float64[]; nbins = nbins, max = Emax, min = Emin)
        while !flat_enough(hist, flatness = flatness)
            for i = 1:10^7
                proposed_index = prop_index(conf)
                #new_val_range = vcat(-3:-1, 1:3)
                val = rand(1:conf.Q)
                current_E = conf.E / L^2
                prop_E = (Energy_Diff(conf, proposed_index, val) + conf.E) / L^2
                if accept_WL(
                    lng = lng,
                    current_E = current_E,
                    prop_E = prop_E,
                    hist = hist,
                )
                    Eind_prop = Int(ceil((prop_E - hist.min) / hist.bin_size))
                    prop_E == hist.min && (Eind_prop = 1)
                    lng[Eind_prop] = lng[Eind_prop] + log(f)
                    @assert(lng[Eind_prop] != Inf, "lng[$(Eind_prop)] is Inf")
                    update(conf, proposed_index, val)
                    update_hist!(hist, prop_E)
                else
                    Eind_current =
                        Int(ceil((current_E - hist.min) / hist.bin_size))
                    current_E == hist.min && (Eind_current = 1)
                    lng[Eind_current] = lng[Eind_current] + log(f)
                    @assert(
                        lng[Eind_current] != Inf,
                        "lng[$(Eind_current)] is Inf"
                    )
                    update_hist!(hist, current_E)
                end
            end
            #@debug begin
                println(hist.hist)
                println(lng[end])
                println(lng[50])
            #end
        end
        println("f = $f")
        f = sqrt(f)
    end
    return lng
end


@time lng = Wang_Landau()
lng = lng .- max(lng...)
g = exp.(lng)
g = g / sum(g)
#plot(1:nbins, g)

function Eplot(g; Tmin::Float64 = 0.01, Tmax::Float64 = 2.0)
    Emax = 0.0
    Emin = - 2.0
    Eavg = Float64[]
    for T in range(Tmin, Tmax, length = 100)
        ET = 0
        ZT = 0
        for i in 1:length(g)
            Ei = (Emax - Emin)/100 * i + Emin
            ET += exp(-Ei/T)*g[i]*Ei
            ZT += exp(-Ei/T)*g[i]
        end
        ET = ET / ZT
        push!(Eavg, ET)
    end
    plot(range(Tmin, Tmax, length = 100), Eavg)
end

Eplot(g, Tmin = 0.005, Tmax = 2.0)
