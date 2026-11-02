\name{snapshot_frequency_gram}
\alias{snapshot_frequency_gram}
\title{Frequency kernels and Gram matrices of the snapshot law}
\usage{
snapshot_frequency_gram(
  object,
  time,
  frequency_radius = NULL,
  nodes = 80,
  rank_tolerance = 1e-10
)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model with a \code{spec} component.}

\item{time}{times in [0, 1].}

\item{frequency_radius}{radius r of the frequency interval.}

\item{nodes}{number of Gauss-Legendre nodes.}

\item{rank_tolerance}{relative threshold on the singular values for the numerical rank.}
}
\value{
A list with \code{time}, \code{gram} (a 4 x 4 x length(time) array), \code{xi},
  \code{numerical_rank}, \code{smallest_eigenvalue}, \code{condition_number},
  \code{imaginary_residual}, \code{frequency_radius} and
  \code{conservative_analytic_radius_satisfied}.
}
\description{
The Gram matrices of Section 3.4 and the coefficients xi recovered from them.
}
\details{
With the cumulant generating functions of the scores, put
\eqn{N(u, t) = \log \psi_{P_{\theta,t}}(u) - i u \kappa_1(t) + u^2 \kappa_2(t)/2}{N(u, t) = log psi_t(u) - i u kappa_1(t) + u^2 kappa_2(t)/2},
the conditional cumulant transform of Y given T = t for |u| <= r, and, with the Euler
operator \eqn{E = u\,\partial/\partial u}{E = u d/du},
\eqn{N_1 = EN}{N_1 = E N}, \eqn{N_2 = E^2 N}{N_2 = E^2 N},
\eqn{N_3 = \partial N/\partial t}{N_3 = dN/dt}, \eqn{N_4 = E\,\partial N/\partial t}{N_4 = E dN/dt}
and \eqn{N_5 = \partial^2 N/\partial t^2}{N_5 = d^2N/dt^2}. The Gram matrix
\eqn{G_{ij}(t) = \langle N_i, N_j \rangle}{G_ij(t) = <N_i, N_j>}, i, j <= 4, in
\eqn{L^2[-r, r]}{L2[-r, r]}, and \eqn{b_i(t) = \langle N_i, N_5 \rangle}{b_i(t) = <N_i, N_5>}
are determined by the snapshot law. G(t) is positive definite outside a finite set of
times, and at such times with \eqn{v_1(t) v_2(t) \ne 0}{v_1(t) v_2(t) != 0},
\eqn{\xi(t) = G(t)^{-1} b(t)}{xi(t) = G(t)^(-1) b(t)} gives the coefficients of
Proposition 3.2 (Lemma 3.7). The smallest eigenvalue of G(t) controls the constants of the
local stability bounds of Theorem 3.8.

The kernels are evaluated at the nodes of a Gauss-Legendre rule on [-r, r]. The default
radius r lies in a disc on which the characteristic functions of all score laws of the class
have no zeros. This disc is small, and the Gram matrices on it are close to singular in
floating point. A larger \code{frequency_radius} can be used while the characteristic
functions of the score laws of the model stay away from zero; the function stops otherwise.
The model must carry its \code{snapshot_spec}, as fitted models do.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

time <- seq(0.05, 0.95, by = 0.1)
g <- snapshot_frequency_gram(fit, time, frequency_radius = 0.5)
g$numerical_rank
g$smallest_eigenvalue
max(abs(g$xi - snapshot_ode_coefficients(fit, time)$xi))
}
}
\seealso{
\code{\link{snapshot_ode_coefficients}}
}
