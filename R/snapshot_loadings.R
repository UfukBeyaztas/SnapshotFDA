snapshot_loadings <- function(object, time, derivative = 0) {
  model <- snapshot_fitted_model(object)
  snapshot_chebyshev(time, nrow(model$v_coef) - 1, derivative) %*% model$v_coef
}
