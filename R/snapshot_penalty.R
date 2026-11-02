snapshot_penalty <- function(q, context, multiplier, penalty) {
  g <- snapshot_constraint_values(q, context)
  sum(pmax(0, multiplier - penalty * g)^2 - multiplier^2) / (2 * penalty)
}
