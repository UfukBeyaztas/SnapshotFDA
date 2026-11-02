\name{snapshot_study_settings}
\alias{snapshot_study_settings}
\title{Settings of the proposed estimator in the simulation study}
\usage{
snapshot_study_settings(trace = FALSE)
}
\arguments{
\item{trace}{passed to \code{\link{snapshot_control}}.}
}
\value{
A list with \code{spec}, \code{control}, \code{atomic_spec}, \code{atomic_control},
  \code{grid} and \code{n_test}.
}
\description{
Sieves, numerical options, evaluation grid and test sample size of the simulation study.
}
\details{
The restricted sieve \eqn{\Theta^{\mathrm{N}}_2}{Theta^N_2} with J = J_mu = 2 is fitted by
Algorithm 1 with twelve starting values and the analytic gradient. In Study D the atomic
sieve \eqn{\Theta^{\mathrm{A}}_2}{Theta^A_2} is also fitted, with four starting values, at
most 5000 iterations per run and 200 EM iterations that refine each start. Errors are
evaluated on 101 equally spaced points of [0, 1], and predictions on 2000 test snapshots.
The class constants are the defaults of \code{\link{snapshot_spec}}.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "separated", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
fit
}
}
\seealso{
\code{\link{snapshot_study_data}}, \code{\link{snapshot_fit}}
}
