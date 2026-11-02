\name{snapshot_encode}
\alias{snapshot_encode}
\title{Working coordinates of a model}
\usage{
snapshot_encode(model, spec = NULL)
}
\arguments{
\item{model}{a \code{snapshot_fit} object or a model.}

\item{spec}{a \code{snapshot_spec}. By default the one stored in the model.}
}
\value{
A named vector.
}
\description{
The box coordinates q of a model in a sieve, for use as a starting value of
\code{\link{snapshot_fit}}.
}
\details{
Algorithm 1 works with \eqn{q \in [-1, 1]^p}{q in [-1, 1]^p}, where the parameter is
p = center + width * q and the widths are the coefficient and mixture boxes of
\code{\link{snapshot_spec}}. Coefficients above the degrees of the sieve must be zero.
Entries outside [-1, 1] show that the model lies outside the box. Starting the algorithm
at the true parameter, as below, checks whether the random starts reach the largest
likelihood.
}
\examples{
\dontrun{
# Study B, delta = 0.35: random starts against a start at the truth
settings <- snapshot_study_settings()
d <- snapshot_study_data("B", "delta", 2000, parameter = 0.35)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
q0 <- snapshot_encode(d$truth, settings$spec)
fit0 <- snapshot_fit(d$train, settings$spec, settings$control, starts = list(q0))
c(random_starts = fit$loglik, truth_start = fit0$loglik)
}
}
\seealso{
\code{\link{snapshot_fit}}
}
