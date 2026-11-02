snapshot_model_diagnostics <- function(object, spec = NULL) {
  model <- snapshot_fitted_model(object)
  if (is.null(spec)) spec <- model$spec
  if (is.null(spec)) spec <- snapshot_spec(degree = max(1, nrow(model$v_coef) - 1),
                                           mean_degree = max(1, length(model$mu_coef) - 1))
  ind <- snapshot_loading_indices(model$v_coef)
  nd <- vapply(model$score, snapshot_score_nd, numeric(1),
               u = seq(-1, 1, length.out = spec$nd_points))
  moment <- exp(vapply(model$score, snapshot_score_log_moment, numeric(1), c0 = spec$c0))
  mu_bounds <- spec$A_mu * spec$rho_mu^-(0:(length(model$mu_coef) - 1))
  v_bounds <- spec$A * spec$rho^-(0:(nrow(model$v_coef) - 1))
  g <- c(alpha = ind$alpha - spec$alpha_min,
         gamma = ind$gamma - spec$gamma_min, tau = ind$tau - spec$tau_min,
         nd1 = nd[1] - spec$nd_min, nd2 = nd[2] - spec$nd_min,
         moment1 = spec$M0 - moment[1], moment2 = spec$M0 - moment[2],
         noise_lower = model$sigma2 - spec$sigma2_min,
         noise_upper = spec$sigma2_max - model$sigma2,
         mean_box = min(mu_bounds - abs(model$mu_coef)),
         loading_box = min(v_bounds - abs(model$v_coef)))
  moments <- lapply(model$score, snapshot_score_cumulants)
  list(indices = ind, non_gaussianity = nd, exponential_moment = moment,
       class_constraints = g, in_compact_class = all(g >= 0),
       score_moments = moments)
}