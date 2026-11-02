\name{snapshot_score_cumulants}
\alias{snapshot_score_cumulants}
\title{Moments and cumulants of a score law}
\usage{
snapshot_score_cumulants(score, max_order = 8)
}
\arguments{
\item{score}{a score law.}

\item{max_order}{highest order, between 2 and 20.}
}
\value{
A list with \code{moment} (orders 0 to \code{max_order}) and \code{cumulant}
  (orders 1 to \code{max_order}).
}
\description{
Raw moments and cumulants of a score law up to a given order.
}
\details{
The moments of each normal component follow from
\eqn{E Z^r = m E Z^{r-1} + (r - 1) s^2 E Z^{r-2}}{E Z^r = m E Z^(r-1) + (r - 1) s^2 E Z^(r-2)}
for \eqn{Z \sim N(m, s^2)}{Z ~ N(m, s^2)}, and the cumulants from the moments by the
recursion \eqn{\kappa_r = \mu_r - \sum_{k=1}^{r-1} \binom{r-1}{k-1} \kappa_k \mu_{r-k}}{kappa_r = mu_r - sum_k choose(r - 1, k - 1) kappa_k mu_(r-k)}.
The cumulants of order r >= 3 of the scores scale the cumulant curves of Y given T; see
\code{\link{snapshot_cumulant_curves}}.
}
\examples{
\dontrun{
# skewness of the score laws of the skewed truth (Study D)
sapply(snapshot_truth("skewed")$score, function(s) snapshot_score_cumulants(s, 3)$cumulant[3])
}
}
\seealso{
\code{\link{snapshot_cumulant_curves}}
}
