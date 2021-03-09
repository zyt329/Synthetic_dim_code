include("MC_Wolff.jl")

"""
Run the simulation for a series of different temps.

Output:

Simulation::Array{Array,1} : It's an array that is of length 5.
    1st entry : An array of Average E values for the simulated ranges of temperatures.
    2nd entry : An array of Average C values for the simulated ranges of temperatures.
    3rd entry : An array of Average Binder's ratios for the simulated ranges of temperatures.
    4th entry : An array of ranges of temperatures that is simulated for different J1 values. Each entry correspond to one J1 value.
    5th entry : An array of simulated J1 values.

"""
function driver(;
    L = 8,
    Q = 16,
    J1 = [range(0.0, 1.0, length = 5); 0.4; 0.45],
    sweeps = 10^6,
    Temp = range(0.3,0.7,length=50),
)
    #Temp = [0.4, 0.6]
    #L = 16##more variables can be specified here

    Esim = []
    Csim = []
    Bsim = []
    simulation = []
    #=Temps = [
        [0.598,0.603],
        [0.573,0.588],
        [0.552,0.557],
        [0.5899,0.5904],
        [0.55,0.60],
        [0.556,0.561],
        [0.555,0.560],
    ]=#
    Temperatures = []
    for k = 1:length(J1)
        #=Temp = range(Temps[k][1], Temps[k][2], length = 5)=#
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
        push!(Temperatures, Temp)
    end
    push!(simulation, Esim)
    push!(simulation, Csim)
    push!(simulation, Bsim)
    push!(simulation, Temperatures)
    push!(simulation, J1)
    #plot(Temp, Esamples)
    #plot!(Temp, Csamples)

    return simulation

end
L = 12; Q = 16
J1 = [range(0.0, 1.0, length = 5); 0.4; 0.45];sweeps = 10^6
content = "Wolff_test"
@time sim = driver(L = L, Q = Q, J1 = J1, sweeps = sweeps)

my_time = Dates.now()
save_path = "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/test/"
time_finished = "Date_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS"))"
save_name = save_path*content*"_L_$(L)__Q_$(Q)__sweeps_$(sweeps)_"*time_finished*".jld"
save(save_name, "sim", [sim,(content, L, Q, sweeps)])
#=save(
    "/nfs/home/zyt329/Research/Synthetic_dim_code/Bcrossing_result/Metropolis_Wolff_fineTemp4_L_$(L)__Q_$(Q)__sweeps_10e7_Date_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld",
    "sim",
    sim,
)
println("L=$L, Q=$Q, Wolff_fineTemp4_10e7 finished at $(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS"))")=#
#=save(
    "E:/UC Davis/Research/Synthetic Dimensions/Synthetic_dim_code/test/"*content*"_L_$(L)__Q_$(Q)__sweeps_$(sweeps)_Date_$(Dates.format(my_time, "e_dd_u_yyyy_HH_MM_SS")).jld",
    "sim",
    sim,
)=#
println("L=$L, Q=$Q,"*content*" finished at "*time_finished)
