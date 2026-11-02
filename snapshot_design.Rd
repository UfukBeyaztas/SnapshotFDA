\name{snapshot_design}
\alias{snapshot_design}
\title{Cells of the simulation study}
\usage{
snapshot_design(study = c("A", "B", "C", "D", "E"))
}
\arguments{
\item{study}{letters of the studies, from \code{"A"} to \code{"E"}.}
}
\value{
A data frame with columns \code{study}, \code{scenario}, \code{parameter},
  \code{n}, \code{replications} and \code{truth}, a label of the truth.
}
\description{
The cells of Studies A to E of Section 6.
}
\details{
The simulation study has five studies, each cell with 100 replications. Study A: truths
\code{"regular"} and \code{"separated"}, n = 500, 1000, 2000, 5000, 10000 and 20000.
Study B: truth \code{"delta"} with delta = 0.9, 0.7, 0.5 and 0.35, n = 2000 and 10000.
Study C: truth \code{"beta"} with beta = 8, 2, 0.5 and 0.1, n = 2000 and 10000. Study D:
truths \code{"atomic"} and \code{"skewed"}, n = 1000, 2000 and 5000, fitted on both sieves.
Study E: truth \code{"regular"}, n = 1000, 2000 and 5000, with a paired sample of n/2
subjects observed twice for the methods that need repeated observations.
}
\examples{
\dontrun{
design <- snapshot_design()
table(design$study)

# one cell of Study B, all replications: median and interquartile range of the
# relative covariance error
settings <- snapshot_study_settings()
w <- outer(snapshot_trapezoid_weights(settings$grid),
           snapshot_trapezoid_weights(settings$grid))
cell <- design[design$study == "B" & design$parameter == 0.5 & design$n == 2000, ]
error <- sapply(seq_len(cell$replications), function(r) {
  d <- snapshot_study_data(cell$study, cell$scenario, cell$n, cell$parameter, r)
  fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
  if (!fit$success) return(NA)
  C <- snapshot_covariance(d$truth, settings$grid)
  C_hat <- snapshot_covariance(fit, settings$grid)
  sqrt(sum(w * (C_hat - C)^2) / sum(w * C^2))
})
c(median = median(error, na.rm = TRUE), iqr = IQR(error, na.rm = TRUE))
}
}
\references{
Beyaztas, U., Norouzirad, M. and Bandyopadhyay, S. (2026). The covariance
  of a random function from one observation per curve. Manuscript.
}
\seealso{
\code{\link{snapshot_study_data}}, \code{\link{snapshot_study_settings}}
}
