snapshot_control <- function(n_start = 12, maxit = 800, outer_max = 25,
                             gradient_tol = 0.0001, feasibility_tol = 0.000001,
                             difference_step = 0.00001, factr = 10000,
                             penalty_initial = 1, penalty_multiplier = 10,
                             strict_feasibility = TRUE, trace = TRUE,
                             gradient = c("central", "analytic"), em_iterations = 0) {
  gradient <- match.arg(gradient)
  snapshot_check_scalar(n_start, "n_start", 1, integer = TRUE)
  snapshot_check_scalar(maxit, "maxit", 1, integer = TRUE)
  snapshot_check_scalar(outer_max, "outer_max", 1, integer = TRUE)
  snapshot_check_scalar(em_iterations, "em_iterations", 0, integer = TRUE)
  for (nm in c("gradient_tol", "feasibility_tol", "difference_step", "factr",
               "penalty_initial")) snapshot_check_scalar(get(nm), nm, 0, strict_lower = TRUE)
  snapshot_check_scalar(penalty_multiplier, "penalty_multiplier", 1, strict_lower = TRUE)
  out <- as.list(environment())
  out[c("n_start", "maxit", "outer_max", "gradient_tol", "feasibility_tol",
        "difference_step", "factr", "penalty_initial", "penalty_multiplier",
        "strict_feasibility", "trace", "gradient", "em_iterations")]
}
