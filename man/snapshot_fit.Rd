\name{snapshot_fit}
\alias{snapshot_fit}
\alias{print.snapshot_fit}
\title{Sieve maximum likelihood from snapshot data}
\usage{
snapshot_fit(
  data,
  spec = snapshot_spec(),
  control = snapshot_control(),
  seed = NULL,
  starts = NULL,
  warm = NULL
)

\method{print}{snapshot_fit}(x, ...)
}
\arguments{
\item{data}{data frame with columns \code{time} and \code{response}, and optionally
distinct subject identifiers \code{id}; see \code{\link{snapshot_data}}.}

\item{spec}{parameter class and sieve, from \code{\link{snapshot_spec}}.}

\item{control}{numerical options, from \code{\link{snapshot_control}}.}

\item{seed}{optional seed of the random starting values. The random number state of the
session is restored afterwards.}

\item{starts}{optional list of starting values in working coordinates, for instance from
\code{\link{snapshot_encode}}.}

\item{warm}{optional fit of the same sieve, for instance of lower degree, whose parameter,
padded with zeros, is added as a further start.}

\item{x}{a \code{snapshot_fit} object.}

\item{...}{not used.}
}
\value{
An object of class \code{snapshot_fit}, a list with components \code{success},
  \code{status}, \code{model} (the fitted model), \code{par} (its working coordinates),
  \code{loglik}, \code{n}, \code{diagnostics} (constraint violation, stationarity of the
  Lagrangian, complementarity and multipliers), \code{constraint_details},
  \code{box_runs}, \code{candidates}, \code{selected_run}, \code{elapsed} and \code{call}.
}
\description{
Fits the snapshot model by Algorithm 1 over the restricted or the atomic sieve.
}
\details{
The model is
\deqn{X(t) = \mu(t) + v_1(t)\zeta_1 + v_2(t)\zeta_2, \qquad Y = X(T) + \varepsilon,}{X(t) = mu(t) + v_1(t) zeta_1 + v_2(t) zeta_2,   Y = X(T) + eps,}
with independent standardized scores, \eqn{\varepsilon \sim N(0, \sigma^2)}{eps ~ N(0, sigma^2)}
and T independent of the scores and the noise. Since the density of T does not depend on
the parameter, the log-likelihood is
\eqn{L_n(\theta) = \sum_{i=1}^n \log p_\theta(Y_i \mid T_i)}{L_n(theta) = sum_i log p(Y_i | T_i)}.
On the restricted sieve
\deqn{p_\theta(y \mid t) = \sum_{j,l = 1}^{2} w_{1j} w_{2l}\, \phi\{y - \mu(t) - v_1(t) m_{1j} - v_2(t) m_{2l};\ v_1(t)^2 \varsigma_{1j}^2 + v_2(t)^2 \varsigma_{2l}^2 + \sigma^2\},}{p(y | t) = sum_{j,l} w_1j w_2l phi(y - mu(t) - v_1(t) m_1j - v_2(t) m_2l; v_1(t)^2 s_1j^2 + v_2(t)^2 s_2l^2 + sigma^2),}
where \eqn{w_{kj}}{w_kj}, \eqn{m_{kj}}{m_kj} and \eqn{\varsigma_{kj}^2}{s_kj^2} are the
weights, means and variances of the two components of the k-th score law. On the atomic
sieve the score laws are atoms \eqn{z_{kj}}{z_kj} with weights \eqn{w_{kj}}{w_kj}, and
the component variance is \eqn{\sigma^2}{sigma^2}. The estimator is any point of the sieve
with \eqn{n^{-1} L_n(\hat\theta_n) \ge \sup n^{-1} L_n - \eta_n}{L_n(theta_hat)/n >= sup L_n/n - eta_n},
and \eqn{\hat C_n = C_{\hat\theta_n}}{C_hat = C(theta_hat)} has rank at most two.
By Theorem 5.6, the restricted sieve gives a consistent estimator when it contains the
truth, and the atomic sieve does so for a truth in the interior of the class with a degree
\eqn{J_n \to \infty}{J_n -> infinity}.

Algorithm 1 runs L-BFGS-B in the boxes of the sieve from several starts and continues
with an augmented Lagrangian when the best accepted run violates a class constraint (see
\code{\link{snapshot_control}}). The selected candidate is feasible and passes the
stopping rules, and its Karush-Kuhn-Tucker conditions are reported. Whether it attains
the global supremum, as Theorem 5.6 assumes, is not checked; several starts reduce the
risk of a local maximum.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()

# Study A: regular truth, n = 2000, first replication
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
fit

# relative covariance error on the evaluation grid
grid <- settings$grid
w <- outer(snapshot_trapezoid_weights(grid), snapshot_trapezoid_weights(grid))
C <- snapshot_covariance(d$truth, grid)
C_hat <- snapshot_covariance(fit, grid)
sqrt(sum(w * (C_hat - C)^2) / sum(w * C^2))

# Study D: three-point scores, restricted and atomic sieves
d <- snapshot_study_data("D", "atomic", 1000)
fit_normal <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
fit_atomic <- snapshot_fit(d$train, settings$atomic_spec, settings$atomic_control,
                           seed = d$seed)
c(normal = fit_normal$loglik, atomic = fit_atomic$loglik)
}
}
\seealso{
\code{\link{snapshot_spec}}, \code{\link{snapshot_control}},
  \code{\link{snapshot_covariance}}, \code{\link{snapshot_reconstruct}},
  \code{\link{snapshot_study_data}}
}
