snapshot_box_minimize <- function(fn, q, control, parameter_scale = rep(1, length(q)), gr = NULL) {
  if (is.null(gr)) gr <- function(p) snapshot_central_gradient(fn, p, control$difference_step)
  fit <- tryCatch(optim(q, fn, gr, method = "L-BFGS-B",
                        lower = rep(-1, length(q)), upper = rep(1, length(q)),
                        control = list(maxit = control$maxit, factr = control$factr,
                                       pgtol = control$gradient_tol / 10)),
                  error = function(e) list(par = q, value = Inf, convergence = 99,
                                           message = conditionMessage(e)))
  gradient <- if (is.finite(fit$value)) gr(fit$par) else rep(Inf, length(q))
  projected <- snapshot_projected_gradient(fit$par, gradient)
  fit$gradient <- gradient
  fit$projected_gradient <- projected
  fit$projected_gradient_physical <- projected / parameter_scale
  fit$accepted <- fit$convergence == 0 && all(is.finite(projected)) &&
    max(abs(projected)) <= control$gradient_tol &&
    max(abs(fit$projected_gradient_physical)) <= control$gradient_tol
  fit
}