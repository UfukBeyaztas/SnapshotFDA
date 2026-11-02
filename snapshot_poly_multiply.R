snapshot_poly_multiply <- function(a, b) {
  out <- numeric(length(a) + length(b) - 1)
  for (j in seq_along(a))
    out[j + seq_along(b) - 1] <- out[j + seq_along(b) - 1] + a[j] * b
  out
}