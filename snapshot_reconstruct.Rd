\name{snapshot_reconstruct}
\alias{snapshot_reconstruct}
\title{Prediction of a curve from one snapshot}
\usage{
snapshot_reconstruct(
  object,
  time,
  response,
  grid = seq(0, 1, length.out = 101),
  variance = TRUE
)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time, response}{observation times and responses, one pair for each subject.}

\item{grid}{times at which the curves are predicted.}

\item{variance}{also return the conditional variances.}
}
\value{
A list with \code{grid}, \code{mean} (a row for each subject and a column for each
  grid point), \code{variance} (the same layout, or \code{NULL}) and
  \code{posterior_scores}.
}
\description{
Conditional mean and variance of the latent curve X(s), on a grid, given one observation
\eqn{(T_i, Y_i)}{(T_i, Y_i)}.
}
\details{
\eqn{E\{X(s) \mid T_i, Y_i\} = \mu(s) + v(s)^\top E(\zeta \mid T_i, Y_i)}{E(X(s) | T_i, Y_i) = mu(s) + v(s)' E(zeta | T_i, Y_i)}
and \eqn{\mathrm{var}\{X(s) \mid T_i, Y_i\} = v(s)^\top \mathrm{cov}(\zeta \mid T_i, Y_i) v(s)}{var(X(s) | T_i, Y_i) = v(s)' cov(zeta | T_i, Y_i) v(s)},
with the conditional law of the scores of \code{\link{snapshot_posterior_scores}}. The
predictor is nonlinear in \eqn{Y_i}{Y_i}. The simulation study reports the mean
integrated squared error of this prediction for new subjects, and the oracle error obtained
with the true parameters.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# curve MISE for the 2000 test subjects: fitted model and oracle
test <- d$test$data
w <- snapshot_trapezoid_weights(grid)
ise <- function(pred) apply((pred$mean - d$test$curves)^2, 1, function(e) sum(w * e))
c(fitted = mean(ise(snapshot_reconstruct(fit, test$time, test$response, grid))),
  oracle = mean(ise(snapshot_reconstruct(d$truth, test$time, test$response, grid))))
}
}
\seealso{
\code{\link{snapshot_posterior_scores}}, \code{\link{snapshot_reconstruct_quantile}}
}
