\name{snapshot_score_density}
\alias{snapshot_score_density}
\title{Density of a normal-mixture score law}
\usage{
snapshot_score_density(score, x)
}
\arguments{
\item{score}{a score law with positive component variances.}

\item{x}{points at which the density is evaluated.}
}
\value{
A vector.
}
\description{
Density of a score law of the restricted sieve, or of another finite normal mixture.
}
\details{
The density is \eqn{\sum_j w_j \phi(x; m_j, s_j^2)}{sum_j w_j phi(x; m_j, s_j^2)}. Atomic
laws have no density; use \code{\link{snapshot_score_cdf}} for them.
}
\examples{
\dontrun{
# score laws of the Study B truths, delta = 0.9 and 0.35
x <- seq(-4, 4, by = 0.01)
strong <- snapshot_truth("delta", delta = 0.9)$score[[1]]
weak <- snapshot_truth("delta", delta = 0.35)$score[[1]]
plot(x, snapshot_score_density(strong, x), type = "l", ylab = "density")
lines(x, snapshot_score_density(weak, x), lty = 2)
lines(x, dnorm(x), col = 2)
}
}
\seealso{
\code{\link{snapshot_score_cdf}}, \code{\link{snapshot_normal_score}}
}
