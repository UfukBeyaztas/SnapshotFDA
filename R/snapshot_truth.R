snapshot_truth <- function(scenario = c("regular", "separated", "near_gaussian", "gaussian",
                                        "atomic", "skewed", "delta", "beta"),
                           delta = 0.7, beta = 1, atoms = 50) {
  scenario <- match.arg(scenario)
  mu <- c(0.3, 0.4, -0.15)
  loadings <- cbind(c(1, 0.55, 0), c(0.15, 0.9, 0.15))
  sigma2 <- 0.08
  two_point <- function(d) {
    snapshot_check_scalar(d, "delta", 0, 0.99, strict_lower = TRUE)
    b <- d / sqrt(1 - d^2)
    list(snapshot_normal_score(c(qlogis(0.3), b, 0)), snapshot_normal_score(c(qlogis(0.65), -b, 0)))
  }
  regular <- lapply(list(c(qlogis(0.3), 1.8, log(1.2)), c(qlogis(0.65), -1.5, log(0.85))),
                    snapshot_normal_score)
  scores <- switch(scenario,
                   regular = regular,
                   separated = lapply(list(c(qlogis(0.3), 4, log(1.2)), c(qlogis(0.65), -3.5, log(0.85))),
                                      snapshot_normal_score),
                   near_gaussian = lapply(list(c(0, 0.2, 0), c(0, 0.2, 0)), snapshot_normal_score),
                   gaussian = lapply(list(c(0, 0, 0), c(0, 0, 0)), snapshot_normal_score),
                   atomic = list(snapshot_atomic_score(c(0.25, 0.15, 0.6), c(-1, 0, 1)),
                                 snapshot_atomic_score(c(0.55, 0.3, 0.15), c(-1, 0, 1))),
                   skewed = {
                     snapshot_check_scalar(atoms, "atoms", 10, integer = TRUE)
                     gamma_atoms <- function(shape) {
                       edges <- qgamma(seq(0, 1, length.out = atoms + 1), shape)
                       shape * atoms * diff(pgamma(edges, shape + 1))
                     }
                     list(snapshot_atomic_score(rep(1, atoms), gamma_atoms(4)),
                          snapshot_atomic_score(rep(1, atoms), -gamma_atoms(9)))
                   },
                   delta = two_point(delta),
                   beta = regular)
  if (scenario == "beta") {
    snapshot_check_scalar(beta, "beta", 0)
    nodes <- 64
    x <- cos(pi * (seq_len(nodes) - 0.5) / nodes); time <- (x + 1) / 2
    angle <- pi / 6 + pi * time / 2
    values <- sqrt((1 + beta * time) / (1 + beta / 2)) * cbind(cos(angle), sin(angle))
    loadings <- sapply(0:2, function(j) (2 - (j == 0)) / nodes *
                         colSums(values * cos(j * pi * (seq_len(nodes) - 0.5) / nodes)))
    loadings <- t(loadings)
  }
  snapshot_model(mu, loadings, sigma2, scores)
}
