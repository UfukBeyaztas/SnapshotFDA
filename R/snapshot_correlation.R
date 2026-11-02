snapshot_correlation <- function(object, s, t = s) {
  V_s <- snapshot_loadings(object, s); V_t <- snapshot_loadings(object, t)
  denominator <- sqrt(outer(rowSums(V_s^2), rowSums(V_t^2)))
  correlation <- tcrossprod(V_s, V_t) / denominator
  correlation[denominator == 0] <- NA_real_
  correlation
}
