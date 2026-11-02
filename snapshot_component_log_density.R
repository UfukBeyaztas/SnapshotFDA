snapshot_component_log_density <- function(comp, response) {
  if (any(comp$variance <= 0)) stop("Conditional mixture variances must be positive.", call. = FALSE)
  z <- -0.5 * (log(2 * pi) + log(comp$variance) +
                 (response - comp$mean)^2 / comp$variance)
  z + rep(log(comp$weight), each = nrow(z))
}