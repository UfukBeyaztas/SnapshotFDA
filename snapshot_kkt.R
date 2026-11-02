snapshot_kkt <- function(q, context, multiplier, step = 0.00001) {
  g <- snapshot_constraint_values(q, context)
  lagrangian <- function(p) snapshot_objective(p, context) -
    sum(multiplier * snapshot_constraint_values(p, context))
  gradient <- snapshot_central_gradient(lagrangian, q, step)
  projected <- snapshot_projected_gradient(q, gradient)
  list(primal_violation = max(c(0, -g)),
       stationarity = max(abs(projected / context$layout$width)),
       stationarity_working = max(abs(projected)),
       complementarity = max(abs(multiplier * g)),
       dual_violation = max(c(0, -multiplier)),
       multipliers_average_objective = multiplier,
       multipliers_total_objective = nrow(context$data) * multiplier,
       constraints = g, strictly_feasible = all(g >= 0),
       box_violation = max(c(0, abs(q) - 1)))
}