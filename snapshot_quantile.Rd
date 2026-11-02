\name{snapshot_quantile}
\alias{snapshot_quantile}
\title{Conditional quantiles of the response given the time}
\usage{
snapshot_quantile(object, time, probability = c(0.025, 0.5, 0.975))
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{probability}{probabilities in [0, 1].}
}
\value{
A matrix with a row for each time and a column for each probability.
}
\description{
Quantiles of Y given T = t under a fitted or a true model.
}
\details{
The quantile of order p is the root of \eqn{F(y \mid t) = p}{F(y | t) = p} for the
normal mixture of \code{\link{snapshot_cdf}}, computed by \code{\link[stats]{uniroot}}.
Pairs of quantiles give prediction intervals for a new snapshot at time t.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# coverage of the 90 percent prediction intervals for the test snapshots
test <- d$test$data
q <- snapshot_quantile(fit, test$time, c(0.05, 0.95))
mean(test$response >= q[, 1] & test$response <= q[, 2])

# quantile curves of Y given T, fitted and true
matplot(grid, snapshot_quantile(fit, grid, c(0.05, 0.5, 0.95)), type = "l", lty = 1,
        col = 1, ylab = "y")
matlines(grid, snapshot_quantile(d$truth, grid, c(0.05, 0.5, 0.95)), lty = 2, col = 2)
}
}
\seealso{
\code{\link{snapshot_cdf}}, \code{\link{snapshot_reconstruct_quantile}}
}
