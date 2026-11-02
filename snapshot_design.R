snapshot_design <- function(study = c("A", "B", "C", "D", "E")) {
  study <- match.arg(study, several.ok = TRUE)
  design <- rbind(
    data.frame(study = "A", scenario = rep(c("regular", "separated"), each = 6), parameter = NA_real_,
               n = c(500, 1000, 2000, 5000, 10000, 20000), replications = 100),
    data.frame(study = "B", scenario = "delta", parameter = rep(c(0.9, 0.7, 0.5, 0.35), each = 2),
               n = c(2000, 10000), replications = 100),
    data.frame(study = "C", scenario = "beta", parameter = rep(c(8, 2, 0.5, 0.1), each = 2),
               n = c(2000, 10000), replications = 100),
    data.frame(study = "D", scenario = rep(c("atomic", "skewed"), each = 3), parameter = NA_real_,
               n = c(1000, 2000, 5000), replications = 100),
    data.frame(study = "E", scenario = "regular", parameter = NA_real_, n = c(1000, 2000, 5000),
               replications = 100))
  design$truth <- ifelse(is.na(design$parameter), design$scenario,
                         sprintf("%s_%.2f", design$scenario, design$parameter))
  design <- design[design$study %in% study, ]
  rownames(design) <- NULL
  design
}