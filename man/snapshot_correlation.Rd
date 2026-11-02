\name{snapshot_correlation}
\alias{snapshot_correlation}
\title{Correlation function}
\usage{
snapshot_correlation(object, s, t = s)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{s, t}{times in [0, 1].}
}
\value{
The matrix with entries \eqn{\varrho(s_i, t_j)}{rho(s_i, t_j)}.
}
\description{
The correlation \eqn{\varrho(s, t) = C(s, t) / \{C(s, s) C(t, t)\}^{1/2}}{rho(s, t) = C(s, t) / (C(s, s) C(t, t))^(1/2)}
of a fitted or a true model.
}
\details{
The correlation is a functional of C and is identified whenever C is; see
\code{\link{snapshot_covariance}}. Entries with a zero variance are \code{NA}. The
simulation study reports \eqn{\|\hat\varrho - \varrho\|_2}{||rho_hat - rho||_2}.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# L2 error of the correlation, as in the simulation study
w <- outer(snapshot_trapezoid_weights(grid), snapshot_trapezoid_weights(grid))
R <- snapshot_correlation(d$truth, grid)
R_hat <- snapshot_correlation(fit, grid)
sqrt(sum(w * (R_hat - R)^2))
}
}
\seealso{
\code{\link{snapshot_covariance}}
}
