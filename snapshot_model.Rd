\name{snapshot_model}
\alias{snapshot_model}
\title{Model object}
\usage{
snapshot_model(mu_coef, v_coef, sigma2, score, spec = NULL)
}
\arguments{
\item{mu_coef}{coefficients \eqn{\mu_0, \mu_1, \ldots}{mu_0, mu_1, ...} of the mean.}

\item{v_coef}{matrix of the coefficients of the loadings, a column for each factor.}

\item{sigma2}{noise variance.}

\item{score}{list of two score laws, from \code{\link{snapshot_normal_score}} or
\code{\link{snapshot_atomic_score}}.}

\item{spec}{optional \code{snapshot_spec} stored with the model.}
}
\value{
A list with \code{mu_coef}, \code{v_coef}, \code{sigma2}, \code{score},
  \code{valid} and \code{spec}.
}
\description{
A model given by its mean coefficients, loading coefficients, noise variance and two score
laws.
}
\details{
The mean is \eqn{\mu(t) = \sum_j \mu_j T_j(2t - 1)}{mu(t) = sum_j mu_j T_j(2t - 1)} and the
loadings are \eqn{v_k(t) = \sum_j v_{kj} T_j(2t - 1)}{v_k(t) = sum_j v_kj T_j(2t - 1)}, with
the Chebyshev polynomials \eqn{T_j}{T_j} and no half factor on \eqn{T_0}{T_0}. The score
laws must be centred and standardized. Models are used as truths in
\code{\link{snapshot_simulate}} and in all functions for fitted quantities.
}
\examples{
\dontrun{
# the regular truth of the simulation study, built by hand
score <- list(snapshot_normal_score(c(qlogis(0.3), 1.8, log(1.2))),
              snapshot_normal_score(c(qlogis(0.65), -1.5, log(0.85))))
model <- snapshot_model(c(0.3, 0.4, -0.15), cbind(c(1, 0.55, 0), c(0.15, 0.9, 0.15)),
                        0.08, score)
all.equal(model, snapshot_truth("regular"))
}
}
\seealso{
\code{\link{snapshot_truth}}, \code{\link{snapshot_simulate}}
}
