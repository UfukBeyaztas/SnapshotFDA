\name{snapshot_score_cdf}
\alias{snapshot_score_cdf}
\title{Distribution function of a score law}
\usage{
snapshot_score_cdf(score, x)
}
\arguments{
\item{score}{a score law.}

\item{x}{points at which the distribution function is evaluated.}
}
\value{
A vector of probabilities.
}
\description{
Distribution function of a score law of either sieve.
}
\details{
The distribution function is
\eqn{\sum_j w_j \Phi\{(x - m_j)/s_j\}}{sum_j w_j Phi((x - m_j)/s_j)}, with a step at each
atom of zero variance. The simulation study compares fitted and true score laws, after the
alignment of \code{\link{snapshot_align_model}}, by the Kolmogorov distance.
}
\examples{
\dontrun{
# the atomic truth of Study D against its fit on the atomic sieve
settings <- snapshot_study_settings()
d <- snapshot_study_data("D", "atomic", 1000)
fit <- snapshot_fit(d$train, settings$atomic_spec, settings$atomic_control, seed = d$seed)
aligned <- snapshot_align_model(fit, d$truth, settings$grid)
x <- sort(c(seq(-4, 4, length.out = 2001), aligned$score[[1]]$mean, d$truth$score[[1]]$mean))
plot(x, snapshot_score_cdf(d$truth$score[[1]], x), type = "s", ylab = "F(x)")
lines(x, snapshot_score_cdf(aligned$score[[1]], x), type = "s", col = 2)
}
}
\seealso{
\code{\link{snapshot_align_model}}, \code{\link{snapshot_score_density}}
}
