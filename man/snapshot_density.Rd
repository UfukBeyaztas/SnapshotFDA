\name{snapshot_density}
\alias{snapshot_density}
\title{Conditional density of the response given the time}
\usage{
snapshot_density(object, time, response, log = FALSE)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{response}{responses. A \code{time} or \code{response} of length one is recycled.}

\item{log}{return the log density.}
}
\value{
A vector of densities or log densities.
}
\description{
Density of Y given T = t under a fitted or a true model.
}
\details{
The snapshot law determines the conditional law of Y given T = t for every t (Lemma 3.1).
Given T = t, Y is a finite normal mixture; on the restricted sieve
\deqn{p_\theta(y \mid t) = \sum_{j,l = 1}^{2} w_{1j} w_{2l}\, \phi\{y - \mu(t) - v_1(t) m_{1j} - v_2(t) m_{2l};\ v_1(t)^2 \varsigma_{1j}^2 + v_2(t)^2 \varsigma_{2l}^2 + \sigma^2\},}{p(y | t) = sum_{j,l} w_1j w_2l phi(y - mu(t) - v_1(t) m_1j - v_2(t) m_2l; v_1(t)^2 s_1j^2 + v_2(t)^2 s_2l^2 + sigma^2),}
and on the atomic sieve the components are centred at
\eqn{\mu(t) + v_1(t) z_{1j} + v_2(t) z_{2l}}{mu(t) + v_1(t) z_1j + v_2(t) z_2l} with
variance \eqn{\sigma^2}{sigma^2}. In the simulation study, the excess negative
log-likelihood of test snapshots relative to the truth measures the fit of the snapshot
law.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# excess negative log-likelihood of the 2000 test snapshots
test <- d$test$data
mean(snapshot_density(d$truth, test$time, test$response, log = TRUE) -
     snapshot_density(fit, test$time, test$response, log = TRUE))

# density of Y given T = 0.5, fitted and true
y <- seq(-3, 4, by = 0.02)
plot(y, snapshot_density(fit, 0.5, y), type = "l", ylab = "density")
lines(y, snapshot_density(d$truth, 0.5, y), lty = 2)
}
}
\seealso{
\code{\link{snapshot_cdf}}, \code{\link{snapshot_quantile}}
}
