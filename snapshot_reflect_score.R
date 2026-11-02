snapshot_reflect_score <- function(score) {
  if (identical(score$type, "normal")) return(snapshot_normal_score(score$theta * c(1, -1, 1)))
  if (!isTRUE(all.equal(rev(score$grid), -score$grid)))
    stop("Reflection of an atomic score requires a symmetric grid.", call. = FALSE)
  snapshot_atomic_score(rev(score$raw_weight), score$grid)
}