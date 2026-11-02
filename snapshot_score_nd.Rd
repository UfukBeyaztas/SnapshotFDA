\name{snapshot_score_nd}
\alias{snapshot_score_nd}
\title{Non-Gaussianity of a score law}
\usage{
snapshot_score_nd(score, u = seq(-1, 1, length.out = 401))
}
\arguments{
\item{score}{a score law, from \code{\link{snapshot_normal_score}} or
\code{\link{snapshot_atomic_score}}.}

\item{u}{points at which the maximum is taken.}
}
\value{
A number.
}
\description{
The index \eqn{\mathrm{ND}(F) = \max_{|u| \le 1} |\log \psi_F(u) + u^2/2|}{ND(F) = max_{|u| <= 1} |log psi_F(u) + u^2/2|},
with \eqn{\psi_F}{psi_F} the characteristic function, evaluated on a grid of u.
}
\details{
For a law with mean zero and variance one, \eqn{|\psi_F(u) - 1| \le 1/2}{|psi_F(u) - 1| <= 1/2}
on [-1, 1], so the principal logarithm is defined, and for laws with an exponential moment
ND(F) = 0 only for N(0, 1). The class of Section 5.1 requires
\eqn{\mathrm{ND}(F_k) \ge \delta_0}{ND(F_k) >= delta_0}. The maximum over the 401 points
\eqn{-1 + j/200}{-1 + j/200} does not exceed ND(F), so a computed value at least
\eqn{\delta_0}{delta_0} implies the exact constraint. For the scores of Study B, ND is of
order \eqn{\delta^3}{delta^3}, the regime of the lower bound of Theorem 4.1.
}
\examples{
\dontrun{
# ND of the two score laws of the Study B truths
sapply(c(0.9, 0.7, 0.5, 0.35), function(delta)
  sapply(snapshot_truth("delta", delta = delta)$score, snapshot_score_nd))
}
}
\seealso{
\code{\link{snapshot_model_diagnostics}}, \code{\link{snapshot_truth}}
}
