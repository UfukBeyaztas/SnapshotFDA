\name{snapshot_covariance}
\alias{snapshot_covariance}
\title{Covariance function}
\usage{
snapshot_covariance(object, s, t = s)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{s, t}{times in [0, 1].}
}
\value{
The matrix with entries \eqn{C(s_i, t_j)}{C(s_i, t_j)}.
}
\description{
The covariance \eqn{C(s, t) = v_1(s) v_1(t) + v_2(s) v_2(t)}{C(s, t) = v_1(s) v_1(t) + v_2(s) v_2(t)}
of a fitted or a true model.
}
\details{
With Gaussian scores only \eqn{C(t, t) + \sigma^2}{C(t, t) + sigma^2} is determined by
the snapshot law (Proposition 2.1). With non-Gaussian scores, C is identified for
real-analytic loadings (Theorem 3.4) and, under further conditions, for twice
continuously differentiable loadings (Theorem 3.5). On an interval, the difference of two
covariances is bounded by the difference of the frequency kernels of their snapshot laws
(Theorem 3.8). The error of any estimator stays bounded below with positive probability
when n is small relative to the distance of the scores from Gaussian laws (Theorem 4.1)
or to the distance of 1, \eqn{v_1^2}{v_1^2} and \eqn{v_2^2}{v_2^2} from linear dependence
(Proposition 4.2). The simulation study reports the relative error
\eqn{\|\hat C - C\|_2 / \|C\|_2}{||C_hat - C||_2 / ||C||_2}.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# relative covariance error, as in the simulation study
w <- outer(snapshot_trapezoid_weights(grid), snapshot_trapezoid_weights(grid))
C <- snapshot_covariance(d$truth, grid)
C_hat <- snapshot_covariance(fit, grid)
sqrt(sum(w * (C_hat - C)^2) / sum(w * C^2))
persp(grid, grid, C_hat, theta = 30, phi = 30, zlab = "C(s, t)")
}
}
\seealso{
\code{\link{snapshot_correlation}}, \code{\link{snapshot_fpca}},
  \code{\link{snapshot_trapezoid_weights}}
}
