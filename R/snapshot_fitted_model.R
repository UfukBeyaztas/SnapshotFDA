snapshot_fitted_model <- function(object) {
  if (inherits(object, "snapshot_fit")) {
    if (!isTRUE(object$success)) stop(object$status, call. = FALSE)
    return(object$model)
  }
  if (!isTRUE(object$valid)) stop("Invalid snapshot model.", call. = FALSE)
  object
}
