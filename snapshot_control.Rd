\name{snapshot_control}
\alias{snapshot_control}
\title{Numerical options of Algorithm 1}
\usage{
snapshot_control(
  n_start = 12,
  maxit = 800,
  outer_max = 25,
  gradient_tol = 1e-04,
  feasibility_tol = 1e-06,
  difference_step = 1e-05,
  factr = 10000,
  penalty_initial = 1,
  penalty_multiplier = 10,
  strict_feasibility = TRUE,
  trace = TRUE,
  gradient = c("central", "analytic"),
  em_iterations = 0
)
}
\arguments{
\item{n_start}{number of random starting values.}

\item{maxit}{maximum number of iterations of each L-BFGS-B run.}

\item{outer_max}{maximum number of augmented Lagrangian iterations from each start.}

\item{gradient_tol}{tolerance on the projected gradient of -L_n/n, in working and in
original coordinates.}

\item{feasibility_tol}{largest constraint violation of an accepted constrained candidate.}

\item{difference_step}{step of the central differences.}

\item{factr}{\code{factr} of L-BFGS-B; see \code{\link[stats]{optim}}.}

\item{penalty_initial}{initial penalty for -L_n/n, which corresponds to c_pen = n for -L_n.}

\item{penalty_multiplier}{factor applied to the penalty.}

\item{strict_feasibility}{if \code{TRUE}, every computed constraint must be nonnegative
at an accepted candidate. If \code{FALSE}, violations up to \code{feasibility_tol} are
accepted, which can place the candidate outside the parameter class.}

\item{trace}{print the progress of the runs.}

\item{gradient}{\code{"central"} for the central differences of Algorithm 1, or
\code{"analytic"} for the analytic gradient of -L_n/n, with the difference quotient
where a zero-weight atomic term overflows. The penalty of the augmented Lagrangian is
differenced centrally in both cases. The estimator, the boxes, the constraints and the
acceptance rules do not depend on this choice.}

\item{em_iterations}{number of EM iterations that refine each starting value of the
atomic sieve before the box runs.}
}
\value{
A list of options.
}
\description{
Multistart, stopping, penalty and gradient options of \code{\link{snapshot_fit}}.
}
\details{
Algorithm 1 (Section 5.3) minimizes -L_n/n over the coefficient and mixture boxes by
L-BFGS-B from \code{n_start} starting values. The mean coefficients of the starts are
the least-squares coefficients of Y, the log noise variance is the log of a quarter of the
residual variance, and the other coordinates are uniform on the boxes shrunk by one half.
A run is accepted when the optimizer reports convergence and the projected gradient is
below \code{gradient_tol} in every coordinate. If the best accepted run satisfies the
class constraints it is returned. Otherwise each box run is continued by an augmented
Lagrangian, with penalty c_pen = n for -L_n, multiplied by \code{penalty_multiplier} when
the violation does not fall below a quarter of its previous value, for at most
\code{outer_max} iterations, until the violation is below \code{feasibility_tol}. The
optimizer works in box coordinates q in [-1, 1], p = center + width * q.
}
\examples{
\dontrun{
# options of the simulation study: restricted sieve and atomic sieve
control <- snapshot_control(n_start = 12, gradient = "analytic")
atomic_control <- snapshot_control(n_start = 4, maxit = 5000, gradient = "analytic",
                                   em_iterations = 200)
}
}
\seealso{
\code{\link{snapshot_fit}}, \code{\link{snapshot_study_settings}}
}
