snapshot_study_data <- function(study, scenario, n, parameter = NA, replication = 1,
                                n_test = 2000, grid = seq(0, 1, length.out = 101)) {
  study <- match.arg(study, c("A", "B", "C", "D", "E"))
  snapshot_check_scalar(n, "n", 2, integer = TRUE)
  snapshot_check_scalar(replication, "replication", 1, integer = TRUE)
  seed <- 1e8 * match(study, LETTERS) + 1e3 * n + replication
  truth <- switch(scenario,
                  delta = snapshot_truth("delta", delta = parameter),
                  beta = snapshot_truth("beta", beta = parameter),
                  snapshot_truth(scenario))
  sample <- snapshot_simulate(n, truth, grid = grid, seed = seed)
  test <- snapshot_simulate(n_test, truth, grid = grid, seed = seed + 5e8)
  pairs <- if (study == "E")
    snapshot_simulate(n / 2, truth, visits = 2, grid = grid, seed = seed + 1e9)$data else NULL
  list(train = sample$data, sample = sample, test = test, pairs = pairs, truth = truth,
       seed = seed, study = study, scenario = scenario, parameter = parameter, n = n,
       replication = replication)
}
