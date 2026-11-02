snapshot_augmented_objective <- function(q, context, multiplier, penalty) {
  snapshot_objective(q, context) + snapshot_penalty(q, context, multiplier, penalty)
}