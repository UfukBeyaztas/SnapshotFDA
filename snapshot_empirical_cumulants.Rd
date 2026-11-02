\name{snapshot_empirical_cumulants}
\alias{snapshot_empirical_cumulants}
\title{Empirical cumulants of the response within time bins}
\usage{
snapshot_empirical_cumulants(
  time,
  response,
  breaks = seq(0, 1, length.out = 11),
  bootstrap = 200,
  seed = NULL
)
}
\arguments{
\item{time, response}{observation times and responses.}

\item{breaks}{increasing bin boundaries in [0, 1].}

\item{bootstrap}{number of bootstrap samples in each bin.}

\item{seed}{optional seed of the bootstrap. The random number state of the session is
restored afterwards.}
}
\value{
A data frame with a row for each bin: its limits, the mean time, the number of
  observations, kappa1 to kappa4 and their standard errors.
}
\description{
The k-statistics of the responses in each time bin, with bootstrap standard errors.
}
\details{
The k-statistics are the unbiased estimators of the first four cumulants. In each bin they
estimate the cumulants of Y given that T falls in the bin, not given one exact time; compare
them with \code{\link{snapshot_bin_cumulants}} of a fitted model. Third and fourth
cumulants away from zero show the non-Gaussian scores that identify the covariance
(Lemma 3.1, Proposition 3.2). Bins with fewer than eight observations are omitted.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 5000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)

# 20 bins: empirical, fitted and true cumulants of order three
breaks <- seq(0, 1, length.out = 21)
empirical <- snapshot_empirical_cumulants(d$train$time, d$train$response, breaks,
                                          seed = 1)
fitted <- snapshot_bin_cumulants(fit, breaks)
true <- snapshot_bin_cumulants(d$truth, breaks)
plot(empirical$time, empirical$kappa3, ylim = range(empirical$kappa3, true$kappa3),
     xlab = "t", ylab = "kappa3")
lines(fitted$time, fitted$kappa3)
lines(true$time, true$kappa3, lty = 2)
}
}
\seealso{
\code{\link{snapshot_bin_cumulants}}, \code{\link{snapshot_cumulant_curves}}
}
