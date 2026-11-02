snapshot_warm_starts <- function(object, spec, n_perturb = 0, scale = 0.1) {
  snapshot_check_scalar(n_perturb, "n_perturb", 0, integer = TRUE)
  snapshot_check_scalar(scale, "scale", 0)
  model <- snapshot_fitted_model(object)
  if (spec$sieve != "normal" && !identical(model$score[[1]]$type, "atomic"))
    stop("Warm starts for the atomic sieve require an atomic model.", call. = FALSE)
  q <- pmin(1, pmax(-1, unname(snapshot_encode(model, spec))))
  out <- list(q)
  for (i in seq_len(n_perturb)) out[[i + 1]] <- pmin(1, pmax(-1, q + runif(length(q), -scale, scale)))
  out
}
