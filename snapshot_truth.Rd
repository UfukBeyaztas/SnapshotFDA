\name{snapshot_truth}
\alias{snapshot_truth}
\title{True models of the simulation study}
\usage{
snapshot_truth(
  scenario = c("regular", "separated", "near_gaussian", "gaussian", "atomic", "skewed",
    "delta", "beta"),
  delta = 0.7,
  beta = 1,
  atoms = 50
)
}
\arguments{
\item{scenario}{name of the model.}

\item{delta}{weight of the two-point part in \code{"delta"}, in (0, 0.99].}

\item{beta}{parameter of \code{"beta"}, nonnegative.}

\item{atoms}{number of atoms of each score law in \code{"skewed"}, at least 10.}
}
\value{
A model; see \code{\link{snapshot_model}}.
}
\description{
The models of the simulation study of Section 6.
}
\details{
All models have the mean \eqn{\mu(t) = 0.3 + 0.4\,T_1(x) - 0.15\,T_2(x)}{mu(t) = 0.3 + 0.4 T_1(x) - 0.15 T_2(x)},
x = 2t - 1, and the noise variance 0.08. All except \code{"beta"} have the loadings
\eqn{v_1 = 1 + 0.55\,T_1}{v_1 = 1 + 0.55 T_1} and
\eqn{v_2 = 0.15 + 0.9\,T_1 + 0.15\,T_2}{v_2 = 0.15 + 0.9 T_1 + 0.15 T_2}.
\describe{
  \item{regular, separated}{Two-component normal mixture scores in the restricted sieve;
    the scores of \code{"separated"} are more bimodal. Study A, and \code{"regular"} in
    Study E.}
  \item{delta}{Scores \eqn{(1 - \delta^2)^{1/2} G_k + \delta Z_k}{(1 - delta^2)^(1/2) G_k + delta Z_k},
    with \eqn{G_k}{G_k} standard normal and standardized two-point \eqn{Z_k}{Z_k},
    \eqn{P(Z_1 > 0) = 0.3}{P(Z_1 > 0) = 0.3} and \eqn{P(Z_2 < 0) = 0.65}{P(Z_2 < 0) = 0.65}:
    the construction of Section 4.1. The model lies in the restricted sieve, and ND is of
    order \eqn{\delta^3}{delta^3}. Study B, with delta = 0.9, 0.7, 0.5 and 0.35.}
  \item{beta}{Loadings the degree-2 Chebyshev truncation of
    \eqn{\{(1 + \beta t)/(1 + \beta/2)\}^{1/2} (\cos, \sin)(\pi/6 + \pi t/2)}{((1 + beta t)/(1 + beta/2))^(1/2) (cos, sin)(pi/6 + pi t/2)},
    so that \eqn{v_1^2 + v_2^2}{v_1^2 + v_2^2} is close to
    \eqn{(1 + \beta t)/(1 + \beta/2)}{(1 + beta t)/(1 + beta/2)} and gamma(v) is small for
    small beta, the mechanism of Proposition 4.2. Scores and noise of \code{"regular"}.
    Study C, with beta = 8, 2, 0.5 and 0.1.}
  \item{atomic}{Standardized three-point scores, in the atomic sieve for J >= 2 and outside
    the restricted sieve. Study D.}
  \item{skewed}{Equal-probability discretizations, with \code{atoms} points, of a
    standardized Gamma(4) law and of minus a standardized Gamma(9) law, with skewness 0.92
    and -0.62 for 50 atoms; outside both sieves. Study D.}
  \item{near_gaussian, gaussian}{Scores with ND below the default \code{nd_min}, and normal
    scores, for which C is not identified. They are not part of the simulation study.}
}
All models of the simulation study lie in the parameter class with the default constants of
\code{\link{snapshot_spec}}.
}
\examples{
\dontrun{
grid <- seq(0, 1, length.out = 101)

# Study C: the index gamma(v) of the four truths
sapply(c(8, 2, 0.5, 0.1), function(beta)
  snapshot_model_diagnostics(snapshot_truth("beta", beta = beta))$indices$gamma)

# covariance of the regular truth
persp(grid, grid, snapshot_covariance(snapshot_truth("regular"), grid),
      theta = 30, phi = 30, zlab = "C(s, t)")
}
}
\references{
Beyaztas, U., Norouzirad, M. and Bandyopadhyay, S. (2026). The covariance
  of a random function from one observation per curve. Manuscript.
}
\seealso{
\code{\link{snapshot_simulate}}, \code{\link{snapshot_design}},
  \code{\link{snapshot_model_diagnostics}}
}
