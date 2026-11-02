snapshot_data <- function(time, response, id = seq_along(time)) {
  time <- snapshot_check_time(time)
  if (!is.numeric(response) || length(response) != length(time) ||
      any(!is.finite(response))) {
    stop("Supply one finite response per observation time.", call. = FALSE)
  }
  if (length(id) != length(time) || anyNA(id) || anyDuplicated(id)) {
    stop("The snapshot likelihood requires one observation per independent subject.",
         call. = FALSE)
  }
  data.frame(id = id, time = time, response = as.numeric(response))
}
