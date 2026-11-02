\name{snapshot_moments}
\alias{snapshot_moments}
\title{Mean and variances of the latent process and the response}
\usage{
snapshot_moments(object, time)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}
}
\value{
A data frame with columns \code{time}, \code{mean}, \code{latent_variance} and
  \code{response_variance}.
}
\description{
The mean, the variance \eqn{C(t, t)}{C(t, t)} of X(t), and the variance
\eqn{C(t, t) + \sigma^2}{C(t, t) + sigma^2} of Y given T = t.
}
\details{
The second conditional cumulant \eqn{\kappa_2(t) = C(t, t) + \sigma^2}{kappa_2(t) = C(t, t) + sigma^2}
is all that a Gaussian working likelihood can identify; non-Gaussian scores separate
C(t, t) from \eqn{\sigma^2}{sigma^2} when 1, \eqn{v_1^2}{v_1^2} and \eqn{v_2^2}{v_2^2}
are linearly independent.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

m_hat <- snapshot_moments(fit, grid)
m <- snapshot_moments(d$truth, grid)
c(noise_error = abs(fit$model$sigma2 - d$truth$sigma2),
  variance_sup = max(abs(m_hat$latent_variance - m$latent_variance)))
}
}
\seealso{
\code{\link{snapshot_cumulant_curves}}
}
