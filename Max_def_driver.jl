include("MC_Max_def.jl")

"""
Run the simulation for a series of different temps.

Output:


"""
function driver(; L = 8, Q = 16, J1 = [range(0.0, 1.0, length = 5);0.4;0.45], sweeps = 10^7, Temp = range(0.56, 0.648, length = 50))
    Esim = []
    Csim = []
    Bsim = []
    simulation = []
    #J1 = range(0.0, 1.0, length = 5)#[0.0, 0.4, 0.8]
    for k = 1:length(J1)
        init_conf::Array{Int64,2} = ones(Int64, L, L)
        Esamples = []
        Csamples = []
        Bsamples = []
        for T in Temp
            samples = sampling(
                T = T,
                J = [1.0, J1[k]],
                L = L,
                Q = Q,
                init_conf = init_conf,
                sweeps = sweeps,
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
            num_bins = 5000
            bin_size = Int(floor(length(samples[1].M)/num_bins))
            Mbins = []
            for i = 1:num_bins
                M_this_bin = 0
                for j = ((i-1)*bin_size + 1) : i * bin_size
                    M_this_bin += samples[1].M[j] / bin_size
                end
                push!(Mbins, M_this_bin)
            end
            M2 = mean(Mbins.^2)
            M4 = mean(Mbins.^4)
            B = 1 - M4/(3*M2^2)
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
L = 8; Q = 16
@time sim = driver(L = L, Q = Q)
my_time = Dates.now()
#save("Cal_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld", "sim", sim)
#save("Result_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld", "sim", sim)
save("Metropolis_Max_def_L_iter10e6_$(L)__Q_$(Q)__Date_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld", "sim", sim)
#println("finished")
