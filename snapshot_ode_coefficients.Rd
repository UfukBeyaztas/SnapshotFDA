\name{snapshot_ode_coefficients}
\alias{snapshot_ode_coefficients}
\title{Coefficients of the differential equation of the cumulant curves}
\usage{
snapshot_ode_coefficients(object, time, tolerance = 1e-08)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{tolerance}{threshold below which a loading or a difference of logarithmic
derivatives is treated as zero.}
}
\value{
A list with \code{time}, \code{xi} (a matrix with \code{NA} where the
  coefficients are not defined), \code{logarithmic_derivative} and \code{valid}.
}
\description{
The functions \eqn{\xi_1, \ldots, \xi_4}{xi_1, ..., xi_4} of Proposition 3.2, computed
from the loadings of a model.
}
\details{
Let \eqn{\ell_k = v_k'/v_k}{l_k = v_k'/v_k} and
\deqn{\xi_1 = \frac{\ell_1 \ell_2' - \ell_2 \ell_1'}{\ell_1 - \ell_2}, \quad \xi_2 = -\ell_1 \ell_2, \quad \xi_3 = \frac{\ell_1' - \ell_2'}{\ell_1 - \ell_2}, \quad \xi_4 = \ell_1 + \ell_2.}{xi_1 = (l_1 l_2' - l_2 l_1')/(l_1 - l_2),  xi_2 = -l_1 l_2,  xi_3 = (l_1' - l_2')/(l_1 - l_2),  xi_4 = l_1 + l_2.}
Where \eqn{v_1 v_2 W[v_1, v_2] \ne 0}{v_1 v_2 W[v_1, v_2] != 0}, with W the Wronskian,
every cumulant curve of order r >= 3 satisfies
\deqn{\kappa_r'' = (\xi_3 + r\xi_4)\kappa_r' + (r\xi_1 + r^2\xi_2)\kappa_r,}{kappa_r'' = (xi_3 + r xi_4) kappa_r' + (r xi_1 + r^2 xi_2) kappa_r,}
with the same four functions for every r. The logarithmic derivatives are the roots of
\eqn{z^2 - \xi_4 z - \xi_2}{z^2 - xi_4 z - xi_2}, so \eqn{(\xi_2, \xi_4)}{(xi_2, xi_4)}
determine them up to their labels, and hence each loading up to a constant factor.
\code{\link{snapshot_frequency_gram}}
recovers the same coefficients from the snapshot law.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

time <- seq(0.05, 0.95, by = 0.1)
xi <- snapshot_ode_coefficients(d$truth, time)$xi
xi_hat <- snapshot_ode_coefficients(fit, time)$xi
round(cbind(xi, xi_hat), 3)
}
}
\seealso{
\code{\link{snapshot_frequency_gram}}, \code{\link{snapshot_cumulant_curves}}
}
