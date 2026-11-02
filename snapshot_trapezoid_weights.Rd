\name{snapshot_trapezoid_weights}
\alias{snapshot_trapezoid_weights}
\title{Trapezoid weights}
\usage{
snapshot_trapezoid_weights(grid)
}
\arguments{
\item{grid}{increasing grid.}
}
\value{
A vector of weights.
}
\description{
Weights of the trapezoid rule on an increasing grid.
}
\details{
With these weights \eqn{w}{w}, \eqn{\sum_j w_j f(s_j)}{sum_j w_j f(s_j)} approximates
\eqn{\int f}{the integral of f}, and \code{outer(w, w)} gives the double integrals of the
L2 errors of covariance and correlation surfaces used in the simulation study.
}
\examples{
\dontrun{
grid <- seq(0, 1, length.out = 101)
w <- snapshot_trapezoid_weights(grid)
sum(w * grid^2)
}
}
\seealso{
\code{\link{snapshot_covariance}}, \code{\link{snapshot_reconstruct}}
}
