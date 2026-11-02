snapshot_study_settings <- function(trace = FALSE) {
  list(spec = snapshot_spec(degree = 2, mean_degree = 2, sieve = "normal"),
       control = snapshot_control(n_start = 12, gradient = "analytic", trace = trace),
       atomic_spec = snapshot_spec(degree = 2, mean_degree = 2, sieve = "atomic"),
       atomic_control = snapshot_control(n_start = 4, maxit = 5000, gradient = "analytic",
                                         em_iterations = 200, trace = trace),
       grid = seq(0, 1, length.out = 101), n_test = 2000)
}