\name{snapshot_fpca}
\alias{snapshot_fpca}
\title{Eigenvalues and eigenfunctions of the covariance operator}
\usage{
snapshot_fpca(object, time = seq(0, 1, length.out = 101))
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{time}{times at which the eigenfunctions are evaluated.}
}
\value{
A list with \code{time}, \code{eigenvalues}, \code{eigenfunctions} (a column for
  each eigenvalue), the Gram matrix \code{loading_gram}, and \code{repeated_eigenvalue},
  which is \code{TRUE} when the two eigenvalues coincide and the eigenfunctions are not
  unique.
}
\description{
The nonzero eigenvalues and the eigenfunctions of the integral operator with kernel C.
}
\details{
The operator has rank at most two. With the Gram matrix
\eqn{B = (\langle v_k, v_l \rangle)_{k,l = 1}^2}{B = (<v_k, v_l>)} of the loadings in
\eqn{L^2[0, 1]}{L2[0, 1]}, eigenvalues \eqn{\lambda_1 \ge \lambda_2}{lambda_1 >= lambda_2}
and orthonormal eigenvectors \eqn{e_j}{e_j}, the eigenvalues of the operator are
\eqn{\lambda_1, \lambda_2}{lambda_1, lambda_2} and its orthonormal eigenfunctions are
\eqn{\varphi_j = \lambda_j^{-1/2}(e_{j1} v_1 + e_{j2} v_2)}{phi_j = lambda_j^(-1/2) (e_j1 v_1 + e_j2 v_2)}.
B is computed by Gauss-Legendre quadrature, which is exact for polynomial loadings.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# relative error of the two eigenvalues
pc <- snapshot_fpca(d$truth, grid)
pc_hat <- snapshot_fpca(fit, grid)
sqrt(sum((pc_hat$eigenvalues - pc$eigenvalues)^2) / sum(pc$eigenvalues^2))
matplot(grid, pc_hat$eigenfunctions, type = "l", lty = 1, ylab = "eigenfunction")
}
}
\seealso{
\code{\link{snapshot_covariance}}
}
