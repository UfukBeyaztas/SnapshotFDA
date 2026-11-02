\name{snapshot_bin_cumulants}
\alias{snapshot_bin_cumulants}
\title{Cumulants of the response within time bins under a model}
\usage{
snapshot_bin_cumulants(
  object,
  breaks = seq(0, 1, length.out = 11),
  nodes = NULL
)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{breaks}{increasing bin boundaries in [0, 1].}

\item{nodes}{number of Gauss-Legendre nodes in each bin.}
}
\value{
A data frame with a row for each bin: its limits, its midpoint and kappa1 to kappa4.
}
\description{
The first four cumulants of Y given that T falls in each bin, for T uniform within the bin.
}
\details{
The raw moments of Y given T = t follow from the cumulant curves of
\code{\link{snapshot_cumulant_curves}}; they are averaged over the bin by Gauss-Legendre
quadrature and then converted to cumulants. Averaging the conditional cumulants instead
would give a different quantity. The result is comparable with
\code{\link{snapshot_empirical_cumulants}}.
}
\examples{
\dontrun{
# bin cumulants of the Study D truths
breaks <- seq(0, 1, length.out = 21)
snapshot_bin_cumulants(snapshot_truth("atomic"), breaks)
snapshot_bin_cumulants(snapshot_truth("skewed"), breaks)
}
}
\seealso{
\code{\link{snapshot_empirical_cumulants}}
}
