snapshot_atomic_em <- function(context, q, iterations = 200, tolerance = 1e-9) {
  spec <- context$spec; layout <- context$layout
  model <- snapshot_decode(q, spec, layout)
  if (!model$valid) return(q)
  B <- context$B_v; y <- context$data$response; n <- length(y)
  grid <- spec$grid; K <- length(grid)
  w1 <- model$score[[1]]$weight; w2 <- model$score[[2]]$weight
  sd1 <- sqrt(model$score[[1]]$raw_variance); sd2 <- sqrt(model$score[[2]]$raw_variance)
  c1 <- model$v_coef[, 1] / sd1; c2 <- model$v_coef[, 2] / sd2
  b0 <- model$mu_coef - c1 * model$score[[1]]$raw_mean - c2 * model$score[[2]]$raw_mean
  s2 <- model$sigma2
  g1 <- rep(grid, times = K); g2 <- rep(grid, each = K)
  BtB <- crossprod(B); p <- ncol(B); previous <- -Inf; trace <- numeric(0)
  for (it in seq_len(iterations)) {
    resid <- (y - drop(B %*% b0)) - outer(drop(B %*% c1), g1) - outer(drop(B %*% c2), g2)
    L <- resid^2 * (-0.5 / s2) + rep(log(pmax(rep(w1, times = K) * rep(w2, each = K), 1e-300)), each = n)
    top <- L[cbind(seq_len(n), max.col(L, ties.method = "first"))]
    E <- exp(L - top); total <- rowSums(E)
    loglik <- sum(top + log(total)) - 0.5 * n * log(2 * pi * s2)
    trace <- c(trace, loglik)
    if (loglik - previous < tolerance * abs(loglik)) break
    previous <- loglik
    r <- E / total
    cr <- colSums(r)
    w1 <- vapply(seq_len(K), function(j) sum(cr[(seq_len(K^2) - 1) %% K + 1 == j]), numeric(1)) / n
    w2 <- vapply(seq_len(K), function(l) sum(cr[(seq_len(K^2) - 1) %/% K + 1 == l]), numeric(1)) / n
    m1 <- drop(r %*% g1); m2 <- drop(r %*% g2)
    m11 <- drop(r %*% g1^2); m22 <- drop(r %*% g2^2); m12 <- drop(r %*% (g1 * g2))
    W <- function(x) crossprod(B * x, B)
    A <- rbind(cbind(BtB, W(m1), W(m2)), cbind(W(m1), W(m11), W(m12)), cbind(W(m2), W(m12), W(m22)))
    cv <- c(crossprod(B, y), crossprod(B, y * m1), crossprod(B, y * m2))
    th <- tryCatch(solve(A, cv), error = function(e) NULL)
    if (is.null(th)) break
    b0 <- th[seq_len(p)]; c1 <- th[p + seq_len(p)]; c2 <- th[2 * p + seq_len(p)]
    s2 <- min(spec$sigma2_max, max(spec$sigma2_min, (sum(y^2) - 2 * sum(cv * th) + sum(th * (A %*% th))) / n))
  }
  z1 <- sum(w1 * grid); z2 <- sum(w2 * grid)
  sd1 <- sqrt(sum(w1 * (grid - z1)^2)); sd2 <- sqrt(sum(w2 * (grid - z2)^2))
  par <- layout$center
  par[layout$mu] <- b0 + c1 * z1 + c2 * z2
  par[layout$v1] <- sd1 * c1; par[layout$v2] <- sd2 * c2
  par[layout$noise] <- log(s2)
  par[layout$score1] <- w1 / max(w1); par[layout$score2] <- w2 / max(w2)
  out <- pmin(1, pmax(-1, (par - layout$center) / layout$width))
  attr(out, "loglik") <- trace
  out
}
