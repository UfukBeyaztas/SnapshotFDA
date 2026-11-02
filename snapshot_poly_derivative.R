snapshot_poly_derivative <- function(a) {
  if (length(a) == 1) return(0)
  a[-1] * seq_len(length(a) - 1)
}