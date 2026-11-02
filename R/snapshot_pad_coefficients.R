snapshot_pad_coefficients <- function(coef, size) {
  if (length(coef) > size && any(coef[(size + 1):length(coef)] != 0))
    stop("The model has a nonzero coefficient above the specified degree.", call. = FALSE)
  c(head(coef, size), rep(0, max(0, size - length(coef))))
}
