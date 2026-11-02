snapshot_density_model <- function(model, time, response, log = FALSE) {
  if (length(response) == 1) response <- rep(response, length(time))
  if (length(time) == 1) time <- rep(time, length(response))
  if (length(time) != length(response) || any(!is.finite(response)))
    stop("time and response must have compatible lengths.", call. = FALSE)
  lp <- snapshot_log_density_values(model, time, response)
  if (log) lp else exp(lp)
}
