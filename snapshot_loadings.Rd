\name{snapshot_loadings}
\alias{snapshot_loadings}
\title{Loadings and their derivatives}
\usage{
snapshot_loadings(object, time, derivative = 0)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{derivative}{order of the derivative: 0, 1 or 2.}
}
\value{
A matrix with a row for each time and a column for each factor.
}
\description{
The loadings \eqn{(v_1, v_2)}{(v_1, v_2)}, or their first or second derivatives, of a
fitted or a true model.
}
\details{
Under the conditions of Theorem 3.4, the snapshot law determines the loadings up to a
signed permutation S of the two factors, \eqn{\tilde v(t) = S v(t)}{v~(t) = S v(t)}, and
C does not depend on S. Errors of estimated loadings are therefore computed after
alignment, as in the metric d of Theorem 5.4; see \code{\link{snapshot_align_model}}.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# sup-norm loading error after the signed permutation that matches the truth
aligned <- snapshot_align_model(fit, d$truth, grid)
max(abs(snapshot_loadings(aligned, grid) - snapshot_loadings(d$truth, grid)))
matplot(grid, snapshot_loadings(aligned, grid), type = "l", lty = 1, ylab = "v(t)")
matlines(grid, snapshot_loadings(d$truth, grid), lty = 2)
}
}
\seealso{
\code{\link{snapshot_align_model}}, \code{\link{snapshot_covariance}}
}
