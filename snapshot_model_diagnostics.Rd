\name{snapshot_model_diagnostics}
\alias{snapshot_model_diagnostics}
\title{Class constraints of a model}
\usage{
snapshot_model_diagnostics(object, spec = NULL)
}
\arguments{
\item{object}{a \code{snapshot_fit} object, or a model from \code{\link{snapshot_model}} or
\code{\link{snapshot_truth}}.}

\item{spec}{a \code{snapshot_spec}. By default the one stored in the model, or the default
class for the degrees of the model.}
}
\value{
A list with \code{indices} (alpha, gamma, tau and their Gram matrices),
  \code{non_gaussianity}, \code{exponential_moment}, \code{class_constraints} (nonnegative
  when the constraint holds), \code{in_compact_class} and \code{score_moments}.
}
\description{
Values of the functionals that define the parameter class of Section 5.1, and the slack
of each constraint.
}
\details{
The class requires \eqn{\alpha(v) \ge \alpha_0}{alpha(v) >= alpha_0},
\eqn{\gamma(v) \ge \gamma_0}{gamma(v) >= gamma_0}, \eqn{\tau(v) \ge \tau_0}{tau(v) >= tau_0},
\eqn{\mathrm{ND}(F_k) \ge \delta_0}{ND(F_k) >= delta_0},
\eqn{E\, e^{c_0|\zeta_k|} \le M_0}{E exp(c_0 |zeta_k|) <= M_0}, the noise range and the
coefficient boxes (see \code{\link{snapshot_spec}}). The functionals alpha and gamma are
smallest eigenvalues of normalized Gram matrices, computed exactly by Gauss-Legendre
quadrature; tau is attained at an end point or at a real root of v' or v + v''. Every truth
of the simulation study lies in the class with the default constants. Membership of a
particular sieve is not checked.
}
\examples{
\dontrun{
# functionals of the simulation truths, with the constants of the study
design <- snapshot_design()
cells <- design[!duplicated(design$truth), ]
settings <- snapshot_study_settings()
truth_of <- function(scenario, parameter) switch(scenario,
  delta = snapshot_truth("delta", delta = parameter),
  beta = snapshot_truth("beta", beta = parameter),
  snapshot_truth(scenario))
truths <- t(sapply(seq_len(nrow(cells)), function(i) {
  spec <- if (cells$scenario[i] == "atomic") settings$atomic_spec else settings$spec
  check <- snapshot_model_diagnostics(truth_of(cells$scenario[i], cells$parameter[i]), spec)
  c(alpha = check$indices$alpha, gamma = check$indices$gamma, tau = check$indices$tau,
    nd1 = check$non_gaussianity[1], nd2 = check$non_gaussianity[2],
    in_class = check$in_compact_class)
}))
rownames(truths) <- cells$truth
round(truths, 4)
}
}
\seealso{
\code{\link{snapshot_spec}}, \code{\link{snapshot_score_nd}}
}
