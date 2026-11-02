\docType{package}
\name{SnapshotFDA-package}
\alias{SnapshotFDA}
\alias{SnapshotFDA-package}
\title{SnapshotFDA: covariance of a random function from one observation per curve}
\description{
Estimation of the mean, the covariance and the score laws of a random function from
snapshot data, in which each of n independent subjects contributes one noisy
observation at a random time.
}
\details{
For t in [0, 1] the model is
\deqn{X(t) = \mu(t) + v_1(t)\zeta_1 + v_2(t)\zeta_2, \qquad Y = X(T) + \varepsilon,}{X(t) = mu(t) + v_1(t) zeta_1 + v_2(t) zeta_2,   Y = X(T) + eps,}
where the scores \eqn{\zeta_1, \zeta_2}{zeta_1, zeta_2} are independent with mean zero
and variance one, \eqn{\varepsilon \sim N(0, \sigma^2)}{eps ~ N(0, sigma^2)}, and T has a
density on [0, 1] and is independent of the scores and the noise. The covariance is
\eqn{C(s, t) = v_1(s) v_1(t) + v_2(s) v_2(t)}{C(s, t) = v_1(s) v_1(t) + v_2(s) v_2(t)}.
The data are the pairs \eqn{(T_i, Y_i)}{(T_i, Y_i)}, i = 1, ..., n.

With Gaussian scores the law of (T, Y) depends on the covariance only through
C(t, t) + sigma^2, and time-dependent rotations of the loadings leave the snapshot law
unchanged while changing C (Proposition 2.1). With non-Gaussian scores, real-analytic
and linearly independent loadings, and 1, \eqn{v_1^2}{v_1^2}, \eqn{v_2^2}{v_2^2} linearly
independent, the law of one snapshot determines mu, sigma^2, and the loadings and score
laws up to a signed permutation of the two factors, and hence C (Theorem 3.4). The
cumulant curves of Y given T carry this information (Proposition 3.2, Section 3.4).
Identification is weak when the scores are close to Gaussian (Theorem 4.1) or when
1, \eqn{v_1^2}{v_1^2} and \eqn{v_2^2}{v_2^2} are close to linear dependence
(Proposition 4.2).

Estimation is by sieve maximum likelihood over a compact class of Chebyshev expansions
and score laws (Section 5): \code{\link{snapshot_spec}} sets the class and the sieve,
\code{\link{snapshot_control}} the numerical options, and \code{\link{snapshot_fit}} runs
Algorithm 1. The restricted sieve uses standardized two-component normal mixtures for
the score laws and the atomic sieve standardized laws on a grid; the estimators are
consistent under the conditions of Theorem 5.6.

Fitted quantities: \code{\link{snapshot_mean}}, \code{\link{snapshot_loadings}},
\code{\link{snapshot_covariance}}, \code{\link{snapshot_correlation}},
\code{\link{snapshot_moments}}, \code{\link{snapshot_fpca}},
\code{\link{snapshot_cumulant_curves}}, and the conditional law of Y given T,
\code{\link{snapshot_density}}, \code{\link{snapshot_cdf}}, \code{\link{snapshot_quantile}}.
Prediction of a curve from one snapshot: \code{\link{snapshot_posterior_scores}},
\code{\link{snapshot_reconstruct}}, \code{\link{snapshot_reconstruct_quantile}}.
Diagnostics: \code{\link{snapshot_model_diagnostics}},
\code{\link{snapshot_ode_coefficients}}, \code{\link{snapshot_frequency_gram}},
\code{\link{snapshot_empirical_cumulants}}, \code{\link{snapshot_bin_cumulants}}.
Simulation study (Section 6): \code{\link{snapshot_truth}}, \code{\link{snapshot_simulate}},
\code{\link{snapshot_design}}, \code{\link{snapshot_study_settings}},
\code{\link{snapshot_study_data}}.
}
\author{
\strong{Maintainer}: Ufuk Beyaztas \email{ufuk.beyaztas@marmara.edu.tr} (\href{https://orcid.org/0000-0002-5208-4950}{ORCID})

Authors:
\itemize{
  \item Ufuk Beyaztas \email{ufuk.beyaztas@marmara.edu.tr} (\href{https://orcid.org/0000-0002-5208-4950}{ORCID})
  \item Mina Norouzirad \email{m.norouzirad@fct.unl.pt} (\href{https://orcid.org/0000-0003-0311-6888}{ORCID})
  \item Soutir Bandyopadhyay \email{sbandyopadhyay@mines.edu} (\href{https://orcid.org/0000-0003-2213-3333}{ORCID})
}

}
