snapshot_density <- function(object, time, response, log = FALSE) {
  snapshot_density_model(snapshot_fitted_model(object), time, response, log)
}
