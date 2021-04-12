function Temp_range_gen(; J = 0, T_range = 0.02, length = 10)
    @assert(
        J >= 0 && J <= 1.08,
        "Not enough data to estimate Critical temperature position"
    )
    J_rough = range(0, 1.08, length = 28)
    Tc_data =
        [0.622 0.618 0.615 0.609 0.605 0.603 0.596 0.589 0.585 0.578 0.576 0.576 0.576 0.577 0.578 0.583 0.586 0.594 0.603 0.611 0.617 0.63 0.645 0.65 0.66 0.67 0.68 0.69]
    Tc_est =
        Tc_data[Int(floor(J / 0.04))+1] +
        (Tc_data[Int(floor(J / 0.04))+2] - Tc_data[Int(floor(J / 0.04))+1]) / 0.04 *
        mod(J, 0.04)
    Temp_range = range(Tc_est - T_range / 2, Tc_est + T_range / 2, length = length)

    return Temp_range
end

#println(Temp_range_gen(J = 0.02))
