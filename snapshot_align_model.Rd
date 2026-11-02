\name{snapshot_align_model}
\alias{snapshot_align_model}
\title{Alignment of the two factors with a reference model}
\usage{
snapshot_align_model(object, reference, grid = seq(0, 1, length.out = 101))
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{reference}{a model or a \code{snapshot_fit} object.}

\item{grid}{integration grid.}
}
\value{
The aligned model, with the chosen permutation and signs in \code{alignment}.
}
\description{
Applies the signed permutation of the two factors that best matches the loadings of a
reference model.
}
\details{
The snapshot law determines the parameter up to the group \eqn{\mathcal{S}_2}{S_2} of the
eight signed permutations S of the two factors, which act by
\eqn{v \mapsto S v}{v -> S v} and \eqn{\zeta \mapsto S \zeta}{zeta -> S zeta}
(Theorem 3.4). The function chooses S to minimize the integrated squared distance of the
loadings to those of the reference, and applies it to the loadings and the score laws; the
law of (T, Y) and the covariance are unchanged. Comparisons of loadings and score laws with
a truth, as in the metric d of Theorem 5.4, are made after this alignment.
}
\examples{
\dontrun{
settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", 2000)
fit <- snapshot_fit(d$train, settings$spec, settings$control, seed = d$seed)
grid <- settings$grid

# Kolmogorov distance between the fitted and the true score laws, after alignment
aligned <- snapshot_align_model(fit, d$truth, grid)
x <- seq(-6, 6, length.out = 4001)
sapply(1:2, function(k) max(abs(snapshot_score_cdf(aligned$score[[k]], x) -
                                snapshot_score_cdf(d$truth$score[[k]], x))))
}
}
\seealso{
\code{\link{snapshot_loadings}}, \code{\link{snapshot_score_cdf}}
}
