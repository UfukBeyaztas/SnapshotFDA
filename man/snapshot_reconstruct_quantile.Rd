\name{snapshot_reconstruct_quantile}
\alias{snapshot_reconstruct_quantile}
\title{Pointwise prediction bands for a curve from one snapshot}
\usage{
snapshot_reconstruct_quantile(
  object,
  time,
  response,
  grid = seq(0, 1, length.out = 101),
  probability = c(0.05, 0.5, 0.95)
)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time, response}{observation times and responses, one pair for each subject.}

\item{grid}{times at which the quantiles are computed.}

\item{probability}{probabilities.}
}
\value{
A list with \code{grid}, \code{quantile} (an array indexed by subject, grid point
  and probability) and \code{probability}.
}
\description{
Pointwise conditional quantiles of the latent curve X(s), on a grid, given one observation
\eqn{(T_i, Y_i)}{(T_i, Y_i)}.
}
\details{
Given \eqn{(T_i, Y_i)}{(T_i, Y_i)}, X(s) is a finite mixture over the mixture components
of the scores, with the posterior component probabilities as weights; its components are
normal, or point masses for the atomic sieve (see \code{\link{snapshot_posterior_scores}}).
The quantile of order p is the smallest x with \eqn{F(x) \ge p}{F(x) >= p}, found by
bisection, which is valid for continuous, discrete and mixed laws. The parameters of the
model are plugged in, so the bands do not include estimation error.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# 90 percent pointwise bands for three test subjects
test <- d$test$data
band <- snapshot_reconstruct_quantile(fit, test$time[1:3], test$response[1:3], grid)
matplot(grid, t(band$quantile[, , "p0.5"]), type = "l", lty = 1, ylab = "X(s)")
for (i in 1:3) {
  lines(grid, band$quantile[i, , "p0.05"], lty = 2, col = i)
  lines(grid, band$quantile[i, , "p0.95"], lty = 2, col = i)
  lines(grid, d$test$curves[i, ], lty = 3, col = i)
  points(test$time[i], test$response[i], pch = 19, col = i)
}
}
}
\seealso{
\code{\link{snapshot_reconstruct}}
}
