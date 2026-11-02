snapshot_real_roots <- function(coef, tolerance = 0.0000001) {
  scale <- max(abs(coef))
  if (!is.finite(scale) || scale == 0) return(numeric(0))
  while (length(coef) > 1 && abs(tail(coef, 1)) <= 1e-13 * scale)
    coef <- head(coef, -1)
  if (length(coef) < 2) return(numeric(0))
  z <- polyroot(coef / scale)
  z <- Re(z[abs(Im(z)) <= tolerance * (1 + abs(Re(z)))])
  z <- z[z >= -tolerance & z <= 1 + tolerance]
  unique(pmin(1, pmax(0, z)))
}
