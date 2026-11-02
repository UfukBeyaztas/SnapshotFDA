\name{snapshot_simulate}
\alias{snapshot_simulate}
\title{Simulation of snapshot data}
\usage{
snapshot_simulate(
  n,
  model = NULL,
  scenario = c("regular", "separated", "near_gaussian", "gaussian", "atomic", "skewed",
    "delta", "beta"),
  visits = 1,
  grid = seq(0, 1, length.out = 101),
  seed = NULL,
  ...
)
}
\arguments{
\item{n}{number of subjects.}

\item{model}{a model or a \code{snapshot_fit} object. If \code{NULL}, the model
\code{snapshot_truth(scenario, ...)}.}

\item{scenario}{a scenario of \code{\link{snapshot_truth}}.}

\item{visits}{number of observations of each curve.}

\item{grid}{times at which the latent curves are returned.}

\item{seed}{optional seed. The random number state of the session is restored afterwards.}

\item{...}{\code{delta}, \code{beta} or \code{atoms}, passed to \code{\link{snapshot_truth}}.}
}
\value{
A list with \code{data} (from \code{\link{snapshot_data}} when \code{visits = 1},
  otherwise a data frame with columns \code{id}, \code{visit}, \code{time} and
  \code{response}), \code{latent_at_time}, \code{scores}, \code{curves} (the latent curves
  on the grid, a row for each subject), \code{grid}, \code{truth}, \code{visits} and
  \code{scenario}.
}
\description{
Draws snapshots, or repeated observations, from a model.
}
\details{
For each of n subjects, the scores are drawn from the score laws, the latent curve is
X(t) = mu(t) + v_1(t) zeta_1 + v_2(t) zeta_2, the times are uniform on [0, 1], and
Y = X(T) + eps with \eqn{\varepsilon \sim N(0, \sigma^2)}{eps ~ N(0, sigma^2)}. With
\code{visits = 1} each subject gives one snapshot, the design of the paper. With
\code{visits = 2} each curve is observed at two independent uniform times; Study E gives
this paired sample of n/2 subjects to the methods that need repeated observations, so that
all methods use n measurements. The draws are made in a fixed order: the mixture component
and score of factor 1, then of factor 2, the times subject by subject, and the noise.
}
\examples{
\dontrun{
# snapshots from the Study B truth with delta = 0.5
sim <- snapshot_simulate(2000, scenario = "delta", delta = 0.5, seed = 1)
plot(sim$data$time, sim$data$response, pch = 20, cex = 0.5, xlab = "t", ylab = "y")
matlines(sim$grid, t(sim$curves[1:10, ]), lty = 1)

# the paired design of Study E: 1000 subjects observed twice
paired <- snapshot_simulate(1000, scenario = "regular", visits = 2, seed = 2)$data
head(paired)
}
}
\seealso{
\code{\link{snapshot_study_data}}, \code{\link{snapshot_truth}}
}
