snapshot_parameter_layout <- function(spec) {
  nmu <- spec$mean_degree + 1; nv <- spec$degree + 1
  nscore <- if (spec$sieve == "normal") 3 else length(spec$grid)
  mu <- seq_len(nmu)
  v1 <- nmu + seq_len(nv); v2 <- nmu + nv + seq_len(nv)
  noise <- nmu + 2 * nv + 1
  score1 <- noise + seq_len(nscore); score2 <- noise + nscore + seq_len(nscore)
  center <- rep(0, noise + 2 * nscore)
  width <- c(spec$A_mu * spec$rho_mu^-(0:spec$mean_degree),
             rep(spec$A * spec$rho^-(0:spec$degree), 2),
             diff(log(c(spec$sigma2_min, spec$sigma2_max))) / 2,
             rep(if (spec$sieve == "normal") spec$mixture_box else rep(0.5, nscore), 2))
  center[noise] <- mean(log(c(spec$sigma2_min, spec$sigma2_max)))
  if (spec$sieve == "atomic") center[c(score1, score2)] <- 0.5
  labels <- c(paste0("mu_", 0:spec$mean_degree), paste0("v1_", 0:spec$degree),
              paste0("v2_", 0:spec$degree), "log_sigma2",
              paste0("score1_", seq_len(nscore)), paste0("score2_", seq_len(nscore)))
  list(mu = mu, v1 = v1, v2 = v2, noise = noise, score1 = score1, score2 = score2,
       center = center, width = width, names = labels, length = length(center))
}
