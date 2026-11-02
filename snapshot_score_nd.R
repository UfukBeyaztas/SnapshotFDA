snapshot_score_nd <- function(score, u = seq(-1, 1, length.out = 401)) {
  if (!isTRUE(score$valid)) return(0)
  cf <- snapshot_score_cf(score, u)
  if (any(!is.finite(cf)) || any(Mod(cf) == 0)) return(0)
  max(Mod(log(cf) + u^2 / 2))
}