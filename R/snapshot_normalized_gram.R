snapshot_normalized_gram <- function(values, weights) {
  G <- crossprod(values, values * weights)
  norms <- sqrt(pmax(0, diag(G)))
  if (any(!is.finite(norms)) || any(norms <= 1e-12))
    return(list(index = 0, matrix = G))
  H <- G / outer(norms, norms)
  list(index = max(0, min(eigen(H, symmetric = TRUE, only.values = TRUE)$values)),
       matrix = H)
}
