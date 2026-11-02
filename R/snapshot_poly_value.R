snapshot_poly_value <- function(a, time) {
  out <- rep(0, length(time))
  for (j in rev(seq_along(a))) out <- out * time + a[j]
  out
}
