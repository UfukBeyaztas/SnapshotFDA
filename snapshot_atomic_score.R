snapshot_atomic_score <- function(raw_weight, grid) {
  if (!is.numeric(grid) || length(grid) < 2 || any(!is.finite(grid)) || anyDuplicated(grid))
    stop("The raw atomic grid must contain distinct finite numbers.", call. = FALSE)
  total <- sum(raw_weight)
  if (any(!is.finite(raw_weight)) || any(raw_weight < 0) ||
      length(raw_weight) != length(grid) || total <= 1e-14)
    return(list(type = "atomic", valid = FALSE, raw_sum = total, raw_variance = 0))
  w <- raw_weight / total
  m <- sum(w * grid); s2 <- sum(w * (grid - m)^2)
  if (!is.finite(s2) || s2 <= 1e-14)
    return(list(type = "atomic", valid = FALSE, raw_sum = total, raw_variance = s2))
  list(type = "atomic", weight = w, mean = (grid - m) / sqrt(s2),
       variance = rep(0, length(grid)), raw_weight = raw_weight,
       raw_mean = m, raw_variance = s2, raw_sum = total, grid = grid, valid = TRUE)
}