snapshot_align_model <- function(object, reference, grid = seq(0, 1, length.out = 101)) {
  model <- snapshot_fitted_model(object)
  reference <- snapshot_fitted_model(reference)
  aligned <- snapshot_align_loadings(snapshot_loadings(model, grid), snapshot_loadings(reference, grid),
                                     snapshot_trapezoid_weights(grid))
  p <- aligned$transformation$permutation; s <- aligned$transformation$sign
  score <- model$score[p]
  for (k in 1:2) if (s[k] < 0) score[[k]] <- snapshot_reflect_score(score[[k]])
  out <- model
  out$v_coef <- sweep(model$v_coef[, p, drop = FALSE], 2, s, "*")
  out$score <- score
  out$alignment <- aligned$transformation
  out
}
