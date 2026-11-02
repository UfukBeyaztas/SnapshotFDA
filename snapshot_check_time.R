snapshot_check_time <- function(time) {
  if (!is.numeric(time) || !length(time) || any(!is.finite(time)) ||
      any(time < 0 | time > 1)) {
    stop("Observation times must be finite and in [0, 1].", call. = FALSE)
  }
  as.numeric(time)
}