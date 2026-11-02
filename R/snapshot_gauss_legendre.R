snapshot_gauss_legendre <- function(n) {
  snapshot_check_scalar(n, "n", 2, integer = TRUE)
  j <- seq_len(n - 1)
  off <- j / sqrt(4 * j^2 - 1)
  jacobi <- matrix(0, n, n)
  jacobi[cbind(j, j + 1)] <- off
  jacobi[cbind(j + 1, j)] <- off
  eig <- eigen(jacobi, symmetric = TRUE)
  ord <- order(eig$values)
  list(time = (eig$values[ord] + 1) / 2,
       weight = eig$vectors[1, ord]^2)
}
