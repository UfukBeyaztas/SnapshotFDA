snapshot_trapezoid_weights <- function(grid) {
  if (length(grid) < 2 || any(!is.finite(grid)) || any(diff(grid) <= 0))
    stop("Supply an increasing integration grid.", call. = FALSE)
  d <- diff(grid)
  c(d[1], head(d, -1) + tail(d, -1), tail(d, 1)) / 2
}