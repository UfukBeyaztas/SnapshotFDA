snapshot_poly_add <- function(a, b) {
  length(a) <- length(b) <- max(length(a), length(b))
  a[is.na(a)] <- 0; b[is.na(b)] <- 0
  a + b
}
