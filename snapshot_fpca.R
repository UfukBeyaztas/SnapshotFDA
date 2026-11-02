snapshot_fpca <- function(object, time = seq(0, 1, length.out = 101)) {
  model <- snapshot_fitted_model(object)
  quad <- snapshot_gauss_legendre(2 * (nrow(model$v_coef) - 1) + 2)
  v <- snapshot_loadings(model, quad$time)
  G <- crossprod(v, v * quad$weight)
  eig <- eigen(G, symmetric = TRUE)
  keep <- eig$values > max(eig$values) * 1e-12
  lambda <- eig$values[keep]
  phi <- snapshot_loadings(model, time) %*% eig$vectors[, keep, drop = FALSE]
  phi <- sweep(phi, 2, sqrt(lambda), "/")
  list(time = time, eigenvalues = lambda, eigenfunctions = phi,
       loading_gram = G, repeated_eigenvalue = length(lambda) == 2 &&
         abs(diff(lambda)) <= 1e-8 * max(lambda))
}