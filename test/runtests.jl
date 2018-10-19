using MyProject_1
using Test

A = load_data("Chicago")
B = load_data("Chicago", false)

show_results(A)
show_results(B)
practice_plots(A)

