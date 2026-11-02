snapshot_log_sum_exp <- function(x) {
  a <- max(x)
  if (!is.finite(a)) return(a)
  a + log(sum(exp(x - a)))
}
