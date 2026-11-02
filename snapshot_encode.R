snapshot_encode <- function(model, spec = NULL) {
  model <- snapshot_fitted_model(model)
  if (is.null(spec)) spec <- model$spec
  if (is.null(spec)) stop("Supply a snapshot_spec for this model.", call. = FALSE)
  layout <- snapshot_parameter_layout(spec)
  p <- layout$center
  p[layout$mu] <- snapshot_pad_coefficients(model$mu_coef, length(layout$mu))
  p[layout$v1] <- snapshot_pad_coefficients(model$v_coef[, 1], length(layout$v1))
  p[layout$v2] <- snapshot_pad_coefficients(model$v_coef[, 2], length(layout$v2))
  p[layout$noise] <- log(model$sigma2)
  if (spec$sieve == "normal") {
    if (any(vapply(model$score, function(s) is.null(s$theta) || length(s$theta) != 3,
                   logical(1))))
      stop("The normal sieve requires its three-parameter score representation.", call. = FALSE)
    p[layout$score1] <- model$score[[1]]$theta
    p[layout$score2] <- model$score[[2]]$theta
  } else {
    for (k in seq_len(2)) {
      s <- model$score[[k]]
      if (is.null(s$grid) || any(s$variance != 0))
        stop("The atomic sieve requires standardized grid scores.", call. = FALSE)
      position <- match(s$grid, spec$grid)
      if (any(is.na(position) & s$weight > 0))
        stop("A positive-weight raw atom is absent from the requested sieve grid.", call. = FALSE)
      weight <- numeric(length(spec$grid))
      active <- which(s$weight > 0)
      weight[position[active]] <- s$weight[active]
      p[if (k == 1) layout$score1 else layout$score2] <- weight
    }
  }
  q <- (p - layout$center) / layout$width
  names(q) <- layout$names
  q
}