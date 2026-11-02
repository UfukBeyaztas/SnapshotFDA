snapshot_reconstruct <- function(object, time, response, grid = seq(0, 1, length.out = 101),
                                 variance = TRUE) {
  model <- snapshot_fitted_model(object)
  posterior <- snapshot_posterior_scores(model, time, response)
  V <- snapshot_loadings(model, grid)
  curves <- posterior$mean %*% t(V)
  curves <- sweep(curves, 2, snapshot_mean(model, grid), "+")
  uncertainty <- if (variance) matrix(0, length(time), length(grid)) else NULL
  if (variance) for (i in seq_along(time))
    uncertainty[i, ] <- pmax(0, rowSums((V %*% posterior$covariance[, , i]) * V))
  list(grid = grid, mean = curves, variance = uncertainty,
       posterior_scores = posterior)
}