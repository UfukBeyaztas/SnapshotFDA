snapshot_simulate <- function(n, model = NULL, scenario = c("regular", "separated", "near_gaussian",
                                                            "gaussian", "atomic", "skewed", "delta", "beta"),
                              visits = 1, grid = seq(0, 1, length.out = 101), seed = NULL, ...) {
  scenario <- match.arg(scenario)
  snapshot_check_scalar(n, "n", 1, integer = TRUE)
  snapshot_check_scalar(visits, "visits", 1, integer = TRUE)
  grid <- snapshot_check_time(grid)
  custom_model <- !is.null(model)
  model <- if (custom_model) snapshot_fitted_model(model) else snapshot_truth(scenario, ...)
  snapshot_with_seed(seed, function() {
    scores <- matrix(0, n, 2)
    for (k in seq_len(2)) {
      s <- model$score[[k]]
      component <- sample(seq_along(s$weight), n, replace = TRUE, prob = s$weight)
      scores[, k] <- rnorm(n, s$mean[component], sqrt(s$variance[component]))
    }
    time <- as.vector(t(matrix(runif(n * visits), n, visits, byrow = TRUE)))
    id <- rep(seq_len(n), each = visits)
    V <- snapshot_loadings(model, time)
    latent <- snapshot_mean(model, time) + rowSums(V * scores[id, , drop = FALSE])
    response <- latent + rnorm(n * visits, sd = sqrt(model$sigma2))
    curves <- scores %*% t(snapshot_loadings(model, grid))
    curves <- sweep(curves, 2, snapshot_mean(model, grid), "+")
    data <- if (visits == 1) snapshot_data(time, response) else
      data.frame(id = id, visit = rep(seq_len(visits), n), time = time, response = response)
    list(data = data, latent_at_time = latent, scores = scores, curves = curves, grid = grid,
         truth = model, visits = visits, scenario = if (custom_model) "custom" else scenario)
  })
}
