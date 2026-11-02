snapshot_cdf <- function(object, time, response) {
  model <- snapshot_fitted_model(object)
  if (length(response) == 1) response <- rep(response, length(time))
  if (length(time) == 1) time <- rep(time, length(response))
  if (length(time) != length(response)) stop("Incompatible lengths.", call. = FALSE)
  comp <- snapshot_components(model, time)
  probabilities <- pnorm((response - comp$mean) / sqrt(comp$variance))
  drop(probabilities %*% comp$weight)
}