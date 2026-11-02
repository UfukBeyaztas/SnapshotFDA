snapshot_projected_gradient <- function(q, gradient, tolerance = 1e-8) {
  out <- gradient
  out[q <= -1 + tolerance & gradient > 0] <- 0
  out[q >= 1 - tolerance & gradient < 0] <- 0
  out
}
