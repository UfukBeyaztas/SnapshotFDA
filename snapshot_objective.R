snapshot_objective <- function(q, context) {
  model <- snapshot_decode(q, context$spec, context$layout)
  if (!model$valid) {
    raw_variance <- vapply(model$score, function(s) if (is.null(s$raw_variance)) 0 else s$raw_variance,
                           numeric(1))
    return(1e8 + 1e5 * sum(pmax(0, 0.5 - raw_variance)^2))
  }
  lp <- snapshot_log_density_values(model, context$data$time, context$data$response,
                                    context$B_mu, context$B_v)
  out <- -mean(lp)
  if (is.finite(out)) out else 1e12
}