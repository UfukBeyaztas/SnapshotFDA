\name{snapshot_cumulant_curves}
\alias{snapshot_cumulant_curves}
\title{Cumulant curves of the response given the time}
\usage{
snapshot_cumulant_curves(object, time, max_order = 8, derivative = 0)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{max_order}{highest order, between 2 and 20.}

\item{derivative}{0 for the curves, 1 or 2 for their derivatives.}
}
\value{
A matrix with a row for each time and a column for each order.
}
\description{
The cumulants \eqn{\kappa_r(t)}{kappa_r(t)} of Y given T = t, r = 1, ..., max_order, or
their derivatives in t.
}
\details{
By the independence of the scores and the noise,
\eqn{\kappa_1 = \mu}{kappa_1 = mu}, \eqn{\kappa_2 = C(t, t) + \sigma^2}{kappa_2 = C(t, t) + sigma^2} and
\deqn{\kappa_r(t) = \kappa_r(\zeta_1) v_1(t)^r + \kappa_r(\zeta_2) v_2(t)^r, \qquad r \ge 3.}{kappa_r(t) = kappa_r(zeta_1) v_1(t)^r + kappa_r(zeta_2) v_2(t)^r,   r >= 3.}
The snapshot law determines these curves (Lemma 3.1); for r >= 3 they satisfy the
differential equation of Proposition 3.2. For the scores of Study B,
\eqn{\kappa_r(\zeta_k) = \delta^r \kappa_r(Z_k)}{kappa_r(zeta_k) = delta^r kappa_r(Z_k)}, so
the curves of order three and higher vanish as \eqn{\delta \to 0}{delta -> 0}.
}
\examples{
\dontrun{
grid <- seq(0, 1, length.out = 101)

# third and fourth cumulant curves of the Study B truths
K_strong <- snapshot_cumulant_curves(snapshot_truth("delta", delta = 0.9), grid, 4)
K_weak <- snapshot_cumulant_curves(snapshot_truth("delta", delta = 0.35), grid, 4)
matplot(grid, cbind(K_strong[, 3:4], K_weak[, 3:4]), type = "l", lty = c(1, 1, 2, 2),
        col = c(1, 2, 1, 2), ylab = "cumulant")
}
}
\seealso{
\code{\link{snapshot_ode_coefficients}}, \code{\link{snapshot_bin_cumulants}}
}
