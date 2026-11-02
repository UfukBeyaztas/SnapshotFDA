snapshot_moments <- function(object, time) {
  model <- snapshot_fitted_model(object)
  v <- snapshot_loadings(model, time)
  latent <- rowSums(v^2)
  data.frame(time = time, mean = snapshot_mean(model, time), latent_variance = latent,
             response_variance = latent + model$sigma2)
}
