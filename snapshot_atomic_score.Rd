\name{snapshot_atomic_score}
\alias{snapshot_atomic_score}
\title{Score law of the atomic sieve}
\usage{
snapshot_atomic_score(raw_weight, grid)
}
\arguments{
\item{raw_weight}{nonnegative weights of the atoms.}

\item{grid}{distinct atoms before standardization.}
}
\value{
A score law: a list with \code{type}, \code{weight}, \code{mean} (the standardized
  atoms), \code{variance} (zeros), the raw weights, the grid mean and variance, and
  \code{valid}.
}
\description{
The standardized law \eqn{F_{J,w}}{F_J,w} with probabilities w on a grid of atoms.
}
\details{
For a probability vector w on grid points \eqn{g_j}{g_j}, with grid mean
\eqn{\bar z_w = \sum_j w_j g_j}{z_w = sum_j w_j g_j} and grid variance
\eqn{\varsigma_w^2 = \sum_j w_j (g_j - \bar z_w)^2}{s_w^2 = sum_j w_j (g_j - z_w)^2}, the law
assigns mass \eqn{w_j}{w_j} to \eqn{(g_j - \bar z_w)/\varsigma_w}{(g_j - z_w)/s_w}, so that it
has mean zero and variance one. The weights are \code{raw_weight / sum(raw_weight)}. The
atomic sieve uses the grid of the points j/J, |j| <= J^2, and requires a grid variance of at
least 1/2. A law with degenerate weights is returned with \code{valid = FALSE}.
}
\examples{
\dontrun{
# the three-point score laws of the atomic truth (Study D)
s1 <- snapshot_atomic_score(c(0.25, 0.15, 0.6), c(-1, 0, 1))
s2 <- snapshot_atomic_score(c(0.55, 0.3, 0.15), c(-1, 0, 1))
rbind(atoms = s1$mean, weights = s1$weight)

# a law on the grid of the atomic sieve with J = 2
grid <- snapshot_spec(degree = 2, sieve = "atomic")$grid
s <- snapshot_atomic_score(dbinom(0:8, 8, 0.3), grid)
snapshot_score_cumulants(s, 4)$cumulant
}
}
\seealso{
\code{\link{snapshot_normal_score}}, \code{\link{snapshot_spec}}
}
