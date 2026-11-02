snapshot_fit <- function(data, spec = snapshot_spec(), control = snapshot_control(),
                         seed = NULL, starts = NULL, warm = NULL) {
  out <- snapshot_with_seed(seed, function() snapshot_fit_impl(data, spec, control, starts, warm))
  out$call <- match.call()
  out
}
