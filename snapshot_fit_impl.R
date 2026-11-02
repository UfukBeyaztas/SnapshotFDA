snapshot_fit_impl <- function(data, spec, control, starts, warm = NULL) {
  context <- snapshot_context(data, spec)
  if (is.null(starts)) starts <- snapshot_starting_values(context, control$n_start)
  if (!is.null(warm)) starts <- c(snapshot_warm_starts(warm, spec), starts)
  if (!is.list(starts) || !length(starts) || any(vapply(starts, length, numeric(1)) != context$layout$length))
    stop("starts must be a list of complete working-parameter vectors.", call. = FALSE)
  if (any(vapply(starts, function(z) any(!is.finite(z) | abs(z) > 1), logical(1))))
    stop("Starting values must lie in [-1, 1].", call. = FALSE)
  objective <- function(q) snapshot_objective(q, context)
  analytic <- identical(control$gradient, "analytic")
  objective_gradient <- if (analytic) function(q)
    snapshot_analytic_gradient(q, context, control$difference_step) else NULL
  runs <- candidates <- list()
  started <- proc.time()[3]
  initial <- starts
  if (spec$sieve == "atomic" && control$em_iterations > 0)
    starts <- lapply(starts, function(q) snapshot_atomic_em(context, q, control$em_iterations))
  for (i in seq_along(starts)) {
    if (control$trace) cat(sprintf("%s sieve: box start %d/%d\n", spec$sieve, i, length(starts)))
    z <- snapshot_box_minimize(objective, starts[[i]], control, context$layout$width,
                               objective_gradient)
    z$start <- i; z$stage <- "box"
    runs[[length(runs) + 1]] <- z
  }
  accepted <- which(vapply(runs, function(z) isTRUE(z$accepted), logical(1)))
  if (length(accepted)) {
    best <- accepted[which.min(vapply(runs[accepted], function(z) z$value, numeric(1)))]
    g <- snapshot_constraint_values(runs[[best]]$par, context)
    if (all(g >= 0)) {
      z <- runs[[best]]
      z$multiplier <- rep(0, length(g))
      candidates[[1]] <- z
    }
  }
  if (!length(accepted)) {
    status <- "No box run passed the optimizer and projected-gradient checks."
  } else if (!length(candidates)) {
    for (i in seq_along(runs)) {
      if (!is.finite(runs[[i]]$value)) next
      q <- runs[[i]]$par
      g <- snapshot_constraint_values(q, context)
      multiplier <- rep(0, length(g)); names(multiplier) <- names(g)
      penalty <- control$penalty_initial
      previous <- max(c(0, -g))
      for (outer in seq_len(control$outer_max)) {
        augmented <- function(p) snapshot_augmented_objective(p, context, multiplier, penalty)
        augmented_gradient <- if (analytic) function(p)
          snapshot_analytic_gradient(p, context, control$difference_step) +
          snapshot_central_gradient(function(x) snapshot_penalty(x, context, multiplier, penalty),
                                    p, control$difference_step) else NULL
        inner <- snapshot_box_minimize(augmented, q, control, context$layout$width,
                                       augmented_gradient)
        q <- inner$par
        g <- snapshot_constraint_values(q, context)
        violation <- max(c(0, -g))
        multiplier <- pmax(0, multiplier - penalty * g)
        if (control$trace && (outer == 1 || outer %% 5 == 0))
          cat(sprintf("  constrained start %d, iteration %d: violation %.3g\n", i, outer, violation))
        feasible <- violation <= control$feasibility_tol &&
          (!control$strict_feasibility || all(g >= 0))
        if (feasible && isTRUE(inner$accepted)) {
          inner$value <- objective(q); inner$par <- q
          inner$multiplier <- multiplier; inner$stage <- "augmented"
          inner$start <- i; inner$outer_iterations <- outer
          candidates[[length(candidates) + 1]] <- inner
          break
        }
        if (violation > previous / 4) penalty <- penalty * control$penalty_multiplier
        previous <- violation
        if (!is.finite(penalty) || penalty > 1e15) break
      }
    }
    status <- if (length(candidates)) "Accepted constrained numerical candidate." else
      "No constrained run passed both feasibility and optimizer checks."
  } else status <- "Accepted box numerical candidate."
  success <- length(candidates) > 0
  if (success) {
    selected <- candidates[[which.min(vapply(candidates, function(z) z$value, numeric(1)))]]
    q <- selected$par
    details <- snapshot_constraint_values(q, context, details = TRUE)
    model <- details$model
    diagnostics <- snapshot_kkt(q, context, selected$multiplier, control$difference_step)
  } else {
    selected <- NULL; q <- NULL; model <- NULL; diagnostics <- NULL; details <- NULL
  }
  out <- list(success = success, status = status, model = model, par = q,
              spec = spec, control = control, diagnostics = diagnostics,
              constraint_details = details,
              loglik = if (success) -selected$value * nrow(context$data) else NA_real_,
              n = nrow(context$data), starts = initial, refined_starts = starts,
              box_runs = runs, candidates = candidates,
              selected_run = selected, elapsed = unname(proc.time()[3] - started))
  class(out) <- "snapshot_fit"
  out
}