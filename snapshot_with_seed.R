snapshot_with_seed <- function(seed, fun) {
  if (is.null(seed)) return(fun())
  snapshot_check_scalar(seed, "seed", 0, .Machine$integer.max, integer = TRUE)
  present <- exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE)
  if (present) previous <- get(".Random.seed", envir = .GlobalEnv)
  on.exit({
    if (present) assign(".Random.seed", previous, envir = .GlobalEnv)
    else if (exists(".Random.seed", envir = .GlobalEnv, inherits = FALSE))
      rm(".Random.seed", envir = .GlobalEnv)
  }, add = TRUE)
  set.seed(seed)
  fun()
}