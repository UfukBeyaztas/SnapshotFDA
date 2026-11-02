\name{snapshot_study_data}
\alias{snapshot_study_data}
\title{Samples of one replication of the simulation study}
\usage{
snapshot_study_data(
  study,
  scenario,
  n,
  parameter = NA,
  replication = 1,
  n_test = 2000,
  grid = seq(0, 1, length.out = 101)
)
}
\arguments{
\item{study}{letter of the study, from \code{"A"} to \code{"E"}.}

\item{scenario}{truth of the cell, a scenario of \code{\link{snapshot_truth}}.}

\item{n}{number of training snapshots.}

\item{parameter}{delta for \code{"delta"} and beta for \code{"beta"}; not used otherwise.}

\item{replication}{index of the replication.}

\item{n_test}{number of test snapshots.}

\item{grid}{times at which the latent curves are returned.}
}
\value{
A list with \code{train} (the training data), \code{sample} and \code{test} (outputs
  of \code{\link{snapshot_simulate}}), \code{pairs} (Study E; otherwise \code{NULL}),
  \code{truth}, \code{seed}, and the description of the cell.
}
\description{
The training sample, the test sample and, in Study E, the paired sample of one replication
of a cell, drawn with the seeds of the simulation study.
}
\details{
The simulation study has five studies, each cell with 100 replications. Study A: truths
\code{"regular"} and \code{"separated"}, n = 500, 1000, 2000, 5000, 10000 and 20000.
Study B: truth \code{"delta"} with delta = 0.9, 0.7, 0.5 and 0.35, n = 2000 and 10000.
Study C: truth \code{"beta"} with beta = 8, 2, 0.5 and 0.1, n = 2000 and 10000. Study D:
truths \code{"atomic"} and \code{"skewed"}, n = 1000, 2000 and 5000, fitted on both sieves.
Study E: truth \code{"regular"}, n = 1000, 2000 and 5000, with a paired sample of n/2
subjects observed twice for the methods that need repeated observations.

Replication r of the cell of study s (A = 1, ..., E = 5) with n training snapshots uses the
seed 1e8 s + 1e3 n + r for the training sample and for the fit, this seed plus 5e8 for the
test sample, and this seed plus 1e9 for the paired sample of Study E. These are the draws
of the simulation study.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()

# one replication of each study
dA <- snapshot_study_data("A", "regular", 500)
dB <- snapshot_study_data("B", "delta", 10000, parameter = 0.35)
dC <- snapshot_study_data("C", "beta", 2000, parameter = 0.1)
dD <- snapshot_study_data("D", "skewed", 1000)
dE <- snapshot_study_data("E", "regular", 2000)
head(dE$pairs)

fit <- snapshot_fit(dC$train, settings$spec, settings$control, seed = dC$seed)
c(sigma2 = fit$model$sigma2, true = dC$truth$sigma2)
}
}
\seealso{
\code{\link{snapshot_design}}, \code{\link{snapshot_study_settings}}
}
