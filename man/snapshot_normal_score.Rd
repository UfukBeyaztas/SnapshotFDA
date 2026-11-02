\name{snapshot_normal_score}
\alias{snapshot_normal_score}
\title{Score law of the restricted sieve}
\usage{
snapshot_normal_score(theta)
}
\arguments{
\item{theta}{the vector \eqn{(\vartheta_1, \vartheta_2, \vartheta_3)}{(theta_1, theta_2, theta_3)}.}
}
\value{
A score law: a list with \code{type}, \code{weight}, \code{mean},
  \code{variance}, \code{theta} and \code{valid}.
}
\description{
The standardized two-component normal mixture \eqn{F_\vartheta}{F_theta} of the restricted
sieve.
}
\details{
For \eqn{\vartheta = (\vartheta_1, \vartheta_2, \vartheta_3)}{theta = (theta_1, theta_2, theta_3)},
let \eqn{w = 1/(1 + e^{-\vartheta_1})}{w = 1/(1 + exp(-theta_1))},
\eqn{m_1 = \{(1 - w)/w\}^{1/2} \vartheta_2 / (1 + \vartheta_2^2)^{1/2}}{m_1 = ((1 - w)/w)^(1/2) theta_2 / (1 + theta_2^2)^(1/2)},
\eqn{m_2 = -\{w/(1 - w)\}^{1/2} \vartheta_2 / (1 + \vartheta_2^2)^{1/2}}{m_2 = -(w/(1 - w))^(1/2) theta_2 / (1 + theta_2^2)^(1/2)},
\eqn{\varsigma_2^2 = 1/\{(1 + \vartheta_2^2)(w e^{2\vartheta_3} + 1 - w)\}}{s_2^2 = 1/((1 + theta_2^2)(w exp(2 theta_3) + 1 - w))}
and \eqn{\varsigma_1 = e^{\vartheta_3} \varsigma_2}{s_1 = exp(theta_3) s_2}. Then
\eqn{F_\vartheta = w N(m_1, \varsigma_1^2) + (1 - w) N(m_2, \varsigma_2^2)}{F_theta = w N(m_1, s_1^2) + (1 - w) N(m_2, s_2^2)}
has mean zero and variance one for every \eqn{\vartheta}{theta}. The restricted sieve
takes \eqn{\vartheta}{theta} in the box of \code{\link{snapshot_spec}}. The scores of the
regular truth of the simulation study have \eqn{\vartheta = (\mathrm{logit}\,0.3, 1.8, \log 1.2)}{theta = (logit 0.3, 1.8, log 1.2)}
and \eqn{(\mathrm{logit}\,0.65, -1.5, \log 0.85)}{(logit 0.65, -1.5, log 0.85)}.
}
\examples{
\dontrun{
# score laws of the regular and the separated truths (Study A)
regular <- snapshot_normal_score(c(qlogis(0.3), 1.8, log(1.2)))
separated <- snapshot_normal_score(c(qlogis(0.3), 4, log(1.2)))
x <- seq(-4, 4, by = 0.01)
plot(x, snapshot_score_density(separated, x), type = "l", ylab = "density")
lines(x, snapshot_score_density(regular, x), lty = 2)
c(regular = snapshot_score_nd(regular), separated = snapshot_score_nd(separated))
}
}
\seealso{
\code{\link{snapshot_atomic_score}}, \code{\link{snapshot_model}},
  \code{\link{snapshot_score_nd}}
}
