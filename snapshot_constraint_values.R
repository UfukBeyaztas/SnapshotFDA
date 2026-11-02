snapshot_constraint_values <- function(q, context, details = FALSE) {
  spec <- context$spec
  model <- snapshot_decode(q, spec, context$layout)
  ind <- snapshot_loading_indices(model$v_coef, context$quadrature, context$polynomials)
  nd <- vapply(model$score, snapshot_score_nd, numeric(1), u = context$u)
  g <- c(gamma = ind$gamma - spec$gamma_min,
         alpha = ind$alpha - spec$alpha_min,
         tau = ind$tau - spec$tau_min,
         nd1 = nd[1] - spec$nd_min, nd2 = nd[2] - spec$nd_min)
  if (spec$sieve == "atomic") {
    # Any simplex vector is representable with raw_sum = 1, including its
    # boundary. This normalization avoids a singular all-zero parameter.
    raw_var <- vapply(model$score, function(s) s$raw_variance, numeric(1))
    raw_sum <- vapply(model$score, function(s) s$raw_sum, numeric(1))
    g <- c(g, raw_variance1 = raw_var[1] - 0.5, raw_variance2 = raw_var[2] - 0.5,
           raw_sum1 = raw_sum[1] - 1, raw_sum2 = raw_sum[2] - 1)
  }
  moments <- vapply(model$score, snapshot_score_log_moment, numeric(1), c0 = spec$c0)
  if (spec$moment_constraints)
    g <- c(g, moment1 = log(spec$M0) - moments[1], moment2 = log(spec$M0) - moments[2])
  g[!is.finite(g)] <- -1e6
  if (details) return(list(constraints = g, indices = ind, non_gaussianity = nd,
                           log_exponential_moment = moments, model = model))
  g
}