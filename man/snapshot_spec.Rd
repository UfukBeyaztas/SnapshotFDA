\name{snapshot_spec}
\alias{snapshot_spec}
\title{Parameter class and sieve}
\usage{
snapshot_spec(
  degree = 2,
  mean_degree = degree,
  sieve = c("normal", "atomic"),
  A = 3,
  rho = 1.5,
  A_mu = 2.5,
  rho_mu = 1.5,
  sigma2_min = 0.01,
  sigma2_max = 3,
  alpha_min = 0.01,
  gamma_min = 1e-04,
  tau_min = 0.02,
  nd_min = 0.002,
  c0 = 0.3,
  M0 = 10,
  w_min = 0.1,
  b_max = 6,
  r_max = 3,
  nd_points = 401
)
}
\arguments{
\item{degree}{degree J of the loadings.}

\item{mean_degree}{degree \eqn{J_\mu}{J_mu} of the mean.}

\item{sieve}{\code{"normal"} for the restricted sieve, \code{"atomic"} for the atomic
sieve. The atomic sieve requires \code{mean_degree = degree}.}

\item{A, rho}{bounds on the loading coefficients.}

\item{A_mu, rho_mu}{bounds on the mean coefficients.}

\item{sigma2_min, sigma2_max}{range of the noise variance.}

\item{alpha_min, gamma_min, tau_min}{the constants \eqn{\alpha_0}{alpha_0},
\eqn{\gamma_0}{gamma_0} and \eqn{\tau_0}{tau_0}.}

\item{nd_min}{the constant \eqn{\delta_0}{delta_0}.}

\item{c0, M0}{the constants of the moment condition.}

\item{w_min, b_max, r_max}{box of the normal-mixture parameters: mixture weight in
[w_min, 1 - w_min], separation |b| <= b_max, and ratio of the component standard
deviations in [1/r_max, r_max].}

\item{nd_points}{number of equally spaced points of [-1, 1] at which ND is evaluated.
With 401 points the computed ND does not exceed ND.}
}
\value{
A list of class \code{snapshot_spec} with the arguments and \code{mixture_box},
  \code{grid} (atomic sieve), \code{normal_moment_bound} and \code{moment_constraints}.
}
\description{
Degrees of the Chebyshev expansions, the sieve for the score laws, and the constants of
the compact parameter class of Section 5.1.
}
\details{
The mean and the loadings are expansions in \eqn{T_j(2t - 1)}{T_j(2t - 1)}, with
\eqn{|\mu_j| \le A_\mu \rho_\mu^{-j}}{|mu_j| <= A_mu rho_mu^(-j)} and
\eqn{|v_{kj}| \le A \rho^{-j}}{|v_kj| <= A rho^(-j)}. With the normalized Gram matrix
\eqn{\Gamma}{Gamma}, the class requires
\eqn{\alpha(v) = \lambda_{\min}\{\Gamma(v_1, v_2)\} \ge \alpha_0}{alpha(v) = lambda_min Gamma(v_1, v_2) >= alpha_0},
\eqn{\gamma(v) = \lambda_{\min}\{\Gamma(1, v_1^2, v_2^2)\} \ge \gamma_0}{gamma(v) = lambda_min Gamma(1, v_1^2, v_2^2) >= gamma_0}
and \eqn{\tau(v) = \min_k \min_t \{v_k(t)^2 + v_k'(t)^2\}^{1/2} \ge \tau_0}{tau(v) = min_k min_t (v_k(t)^2 + v_k'(t)^2)^(1/2) >= tau_0},
score laws with mean zero, variance one,
\eqn{E\, e^{c_0 |\zeta_k|} \le M_0}{E exp(c_0 |zeta_k|) <= M_0} and
\eqn{\mathrm{ND}(F_k) \ge \delta_0}{ND(F_k) >= delta_0}, where
\eqn{\mathrm{ND}(F) = \max_{|u| \le 1} |\log \psi_F(u) + u^2/2|}{ND(F) = max_{|u| <= 1} |log psi_F(u) + u^2/2|}
and \eqn{\psi_F}{psi_F} is the characteristic function, and
\eqn{\sigma^2_{\min} \le \sigma^2 \le \sigma^2_{\max}}{sigma2_min <= sigma^2 <= sigma2_max}.
These bounds separate the class from linearly dependent loadings, variance confounding and
Gaussian scores. The constants are fixed before the data are examined; membership of the
true parameter in the class is an identifying assumption.

The restricted sieve \eqn{\Theta^{\mathrm{N}}_J}{Theta^N_J} has a mean of degree
\code{mean_degree}, loadings of degree J = \code{degree}, and score laws
\eqn{F_\vartheta}{F_theta} (see \code{\link{snapshot_normal_score}}) with
\eqn{\vartheta}{theta} in the box given by \code{w_min}, \code{b_max} and \code{r_max}. The
atomic sieve \eqn{\Theta^{\mathrm{A}}_J}{Theta^A_J} has mean and loadings of degree J and
standardized score laws on the grid of the points j/J, |j| <= J^2, with grid variance at
least 1/2 (see \code{\link{snapshot_atomic_score}}). For the restricted sieve the moment
condition holds on the whole box when \code{M0} is at least
\eqn{2\exp(c_0 \bar m + c_0^2 \bar\varsigma^2/2)}{2 exp(c_0 m + c_0^2 s^2 / 2)}, the bound
returned as \code{normal_moment_bound}; it is then not imposed as a constraint. The
defaults are the constants of the simulation study.
}
\examples{
\dontrun{
# the two sieves of the simulation study, J = J_mu = 2
spec <- snapshot_spec(degree = 2, mean_degree = 2)
spec$normal_moment_bound
spec$moment_constraints
atomic_spec <- snapshot_spec(degree = 2, mean_degree = 2, sieve = "atomic")
atomic_spec$grid
}
}
\references{
Beyaztas, U., Norouzirad, M. and Bandyopadhyay, S. (2026). The covariance
  of a random function from one observation per curve. Manuscript.
}
\seealso{
\code{\link{snapshot_control}}, \code{\link{snapshot_fit}},
  \code{\link{snapshot_model_diagnostics}}
}
