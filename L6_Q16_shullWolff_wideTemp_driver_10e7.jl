include("MC_Wolff.jl")

"""
Run the simulation for a series of different temps.

Output:


"""
function driver(;
    L = 8,
    Q = 16,
    J1 = [range(0.0, 1.0, length = 5); 0.4; 0.45],
    sweeps = 10^7,
    Temp = range(0.3, 0.7, length = 100),
)
    #Temp = [0.4, 0.6]
    #L = 16##more variables can be specified here

    Esim = []
    Csim = []
    Bsim = []
    simulation = []
    for k = 1:length(J1)
        #=
        simulation["E(T)"][k] = []
        simulation["C(T)"][k] = []=#
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
            Eavg = 0
            E2avg = 0
            for i = 1:length(samples[1].E)
                Eavg += samples[1].E[i]
                E2avg += (samples[1].E[i])^2
            end
            Eavg = Eavg / length(samples[1].E)
            E2avg = E2avg / length(samples[1].E)
            C = 1 / T^2 * (E2avg - Eavg^2) / L^2
            Eavg = Eavg / L^2
            push!(Esamples, Eavg)
            push!(Csamples, C)
            # Binning for M
            num_bins = 500
            bin_size = Int(floor(length(samples[1].M) / num_bins))
            Mbins = []
            for i = 1:num_bins
                M_this_bin = 0
                for j = ((i-1)*bin_size+1):i*bin_size
                    M_this_bin += samples[1].M[j] / bin_size
                end
                push!(Mbins, M_this_bin)
            end
            M2 = mean(Mbins .^ 2)
            M4 = mean(Mbins .^ 4)
            B = 1 - M4 / (3 * M2^2)
            push!(Bsamples, B)
            #output the final configuration as the initial conf for the next temperature.
            init_conf = samples[2]
        end
        push!(Esim, Esamples)
        push!(Csim, Csamples)
        push!(Bsim, Bsamples)
    end
    push!(simulation, Esim)
    push!(simulation, Csim)
    push!(simulation, Bsim)
    #plot(Temp, Esamples)
    #plot!(Temp, Csamples)

    return simulation

end
L = 6; Q = 16
@time sim = driver(L = L, Q = Q)
my_time = Dates.now()
save(
    "/nfs/home/zyt329/Research/Synthetic_dim_code/Remote_result/Metropolis_Wolff_wideTemp_L_$(L)__Q_$(Q)__sweeps_10e7_Date_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld",
    "sim",
    sim,
)
println("L=$L, Q=$Q, Wolff_wideTemp finished at $(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS"))")
