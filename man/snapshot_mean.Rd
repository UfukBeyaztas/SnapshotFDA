\name{snapshot_mean}
\alias{snapshot_mean}
\title{Mean function}
\usage{
snapshot_mean(object, time)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}
}
\value{
A vector.
}
\description{
The mean \eqn{\mu(t) = \sum_j \mu_j T_j(2t - 1)}{mu(t) = sum_j mu_j T_j(2t - 1)} of a
fitted or a true model.
}
\details{
The mean is identified from the first conditional cumulant,
\eqn{\mu(t) = E(Y \mid T = t)}{mu(t) = E(Y | T = t)}, for any score laws.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# sup-norm error of the mean on the evaluation grid
max(abs(snapshot_mean(fit, grid) - snapshot_mean(d$truth, grid)))
}
}
\seealso{
\code{\link{snapshot_covariance}}, \code{\link{snapshot_moments}}
}
