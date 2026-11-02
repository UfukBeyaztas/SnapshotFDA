snapshot_check_scalar <- function(x, name, lower = -Inf, upper = Inf,
                                  integer = FALSE, strict_lower = FALSE) {
  if (!is.numeric(x) || length(x) != 1 || !is.finite(x) ||
      x > upper || if (strict_lower) x <= lower else x < lower) {
    stop(name, " is outside its permitted range.", call. = FALSE)
  }
  if (integer && x != round(x)) stop(name, " must be an integer.", call. = FALSE)
  invisible(x)
}
