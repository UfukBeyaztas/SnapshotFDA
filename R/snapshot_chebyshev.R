snapshot_chebyshev <- function(time, degree, derivative = 0) {
  time <- snapshot_check_time(time)
  snapshot_check_scalar(degree, "degree", 0, integer = TRUE)
  snapshot_check_scalar(derivative, "derivative", 0, 2, integer = TRUE)
  x <- 2 * time - 1
  B <- D <- DD <- matrix(0, length(time), degree + 1)
  B[, 1] <- 1
  if (degree >= 1) { B[, 2] <- x; D[, 2] <- 2 }
  if (degree >= 2) for (j in 2:degree) {
    B[, j + 1] <- 2 * x * B[, j] - B[, j - 1]
    D[, j + 1] <- 4 * B[, j] + 2 * x * D[, j] - D[, j - 1]
    DD[, j + 1] <- 8 * D[, j] + 2 * x * DD[, j] - DD[, j - 1]
  }
  colnames(B) <- colnames(D) <- colnames(DD) <- paste0("T", 0:degree)
  switch(derivative + 1, B, D, DD)
}
