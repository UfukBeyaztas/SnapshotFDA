snapshot_decode <- function(q, spec, layout = snapshot_parameter_layout(spec)) {
  if (length(q) != layout$length || any(!is.finite(q)))
    stop("Incorrect working-parameter vector.", call. = FALSE)
  p <- layout$center + layout$width * q
  scores <- if (spec$sieve == "normal")
    list(snapshot_normal_score(p[layout$score1]), snapshot_normal_score(p[layout$score2]))
  else list(snapshot_atomic_score(p[layout$score1], spec$grid),
            snapshot_atomic_score(p[layout$score2], spec$grid))
  list(mu_coef = p[layout$mu], v_coef = cbind(p[layout$v1], p[layout$v2]),
       sigma2 = exp(p[layout$noise]), score = scores,
       valid = all(vapply(scores, function(z) isTRUE(z$valid), logical(1))), spec = spec)
}