snapshot_covariance <- function(object, s, t = s) {
  tcrossprod(snapshot_loadings(object, s), snapshot_loadings(object, t))
}