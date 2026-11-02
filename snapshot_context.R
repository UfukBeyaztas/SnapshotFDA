snapshot_context <- function(data, spec) {
  data <- snapshot_data(data$time, data$response,
                        if (is.null(data$id)) seq_along(data$time) else data$id)
  quad <- snapshot_gauss_legendre(2 * spec$degree + 2)
  list(data = data, spec = spec, layout = snapshot_parameter_layout(spec),
       B_mu = snapshot_chebyshev(data$time, spec$mean_degree),
       B_v = snapshot_chebyshev(data$time, spec$degree), quadrature = quad,
       polynomials = snapshot_chebyshev_polynomials(spec$degree),
       u = seq(-1, 1, length.out = spec$nd_points))
}