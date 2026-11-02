snapshot_chebyshev_polynomials <- function(degree) {
  out <- vector("list", degree + 1)
  out[[1]] <- 1
  if (degree >= 1) out[[2]] <- c(-1, 2)
  if (degree >= 2) for (j in 2:degree)
    out[[j + 1]] <- snapshot_poly_add(
      2 * snapshot_poly_multiply(c(-1, 2), out[[j]]), -out[[j - 1]])
  out
}
