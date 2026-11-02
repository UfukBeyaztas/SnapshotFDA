\name{snapshot_posterior_scores}
\alias{snapshot_posterior_scores}
\title{Conditional law of the scores given one snapshot}
\usage{
snapshot_posterior_scores(object, time, response)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time, response}{observation times and responses, one pair for each subject.}
}
\value{
A list with \code{mean} (a matrix with two columns), \code{covariance} (a
  2 x 2 x n array) and \code{mixture_probability} (a row for each subject and a column for
  each mixture component).
}
\description{
Conditional means and covariances of the scores \eqn{(\zeta_1, \zeta_2)}{(zeta_1, zeta_2)}
given one observation \eqn{(T_i, Y_i)}{(T_i, Y_i)} of each subject.
}
\details{
Given the mixture component c = (j, l), the scores have independent normal laws with means
\eqn{a_c}{a_c} and variances \eqn{D_c}{D_c} (point masses for the atomic sieve), and
\eqn{Y = \mu(T) + v(T)^\top \zeta + \varepsilon}{Y = mu(T) + v(T)' zeta + eps}. Hence, given
\eqn{(T_i, Y_i)}{(T_i, Y_i)} and c, the scores are normal with mean
\eqn{a_c + D_c v(T_i)\{Y_i - m_c(T_i)\}/s_c^2(T_i)}{a_c + D_c v(T_i) (Y_i - m_c(T_i)) / s_c^2(T_i)}
and covariance
\eqn{D_c - D_c v(T_i) v(T_i)^\top D_c / s_c^2(T_i)}{D_c - D_c v(T_i) v(T_i)' D_c / s_c^2(T_i)},
where \eqn{m_c}{m_c} and \eqn{s_c^2}{s_c^2} are the component mean and variance of Y given
T, and the components have posterior probabilities proportional to
\eqn{w_c \phi\{Y_i; m_c(T_i), s_c^2(T_i)\}}{w_c phi(Y_i; m_c(T_i), s_c^2(T_i))}. The
parameters of the model are plugged in.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "separated", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)

# predicted against true scores of the test subjects: fitted model after alignment,
# and the oracle with the true parameters
aligned <- snapshot_align_model(fit, d$truth, settings$grid)
test <- d$test$data
fitted <- snapshot_posterior_scores(aligned, test$time, test$response)
oracle <- snapshot_posterior_scores(d$truth, test$time, test$response)
rbind(fitted = diag(cor(fitted$mean, d$test$scores)),
      oracle = diag(cor(oracle$mean, d$test$scores)))
}
}
\seealso{
\code{\link{snapshot_reconstruct}}, \code{\link{snapshot_align_model}}
}
