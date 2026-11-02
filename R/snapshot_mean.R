snapshot_mean <- function(object, time) {
  model <- snapshot_fitted_model(object)
  drop(snapshot_chebyshev(time, length(model$mu_coef) - 1) %*% model$mu_coef)
}
