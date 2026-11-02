snapshot_normal_score <- function(theta) {
  if (length(theta) != 3 || any(!is.finite(theta)))
    stop("A normal score requires three finite mixture parameters.", call. = FALSE)
  w <- plogis(theta[1]); b <- theta[2]; r <- exp(theta[3])
  m <- c(sqrt((1 - w) / w), -sqrt(w / (1 - w))) * b / sqrt(1 + b^2)
  s2 <- c(r^2, 1) / ((1 + b^2) * (w * r^2 + 1 - w))
  list(type = "normal", weight = c(w, 1 - w), mean = m,
       variance = s2, theta = theta, valid = TRUE)
}