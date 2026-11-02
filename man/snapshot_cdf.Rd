\name{snapshot_cdf}
\alias{snapshot_cdf}
\title{Conditional distribution function of the response given the time}
\usage{
snapshot_cdf(object, time, response)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times in [0, 1].}

\item{response}{responses. A \code{time} or \code{response} of length one is recycled.}
}
\value{
A vector of probabilities.
}
\description{
Distribution function of Y given T = t under a fitted or a true model.
}
\details{
Given T = t, Y is a finite normal mixture with weights \eqn{w_c}{w_c}, means
\eqn{m_c(t)}{m_c(t)} and variances \eqn{s_c^2(t)}{s_c^2(t)}, so
\eqn{F(y \mid t) = \sum_c w_c \Phi[\{y - m_c(t)\}/s_c(t)]}{F(y | t) = sum_c w_c Phi((y - m_c(t))/s_c(t))};
see \code{\link{snapshot_density}}. Under the true model the values
\eqn{F(Y_i \mid T_i)}{F(Y_i | T_i)} are uniform on [0, 1].
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# probability integral transforms of the test snapshots
test <- d$test$data
u <- snapshot_cdf(fit, test$time, test$response)
hist(u, breaks = 20)
}
}
\seealso{
\code{\link{snapshot_density}}, \code{\link{snapshot_quantile}}
}
