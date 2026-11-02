# SnapshotFDA

`SnapshotFDA` is an R package for estimating the covariance of a random
function when each subject contributes one noisy observation at a random
time. It fits a two-factor model by sieve maximum likelihood and provides
estimates of the mean, covariance, score distributions, and measurement error
variance. The fitted model also gives conditional predictions of curves from
single observations.

The [user manual](SnapshotFDA_0.1.0.pdf) gives the model assumptions, function
arguments, return values, and further examples.

## Installation

Install the package from GitHub using `remotes`:

```r
install.packages("remotes")
remotes::install_github("UfukBeyaztas/SnapshotFDA", upgrade = "never")

library(SnapshotFDA)
```

R 3.5.0 or later is required. The package imports `stats` and `utils`, which
are distributed with R. The installation command above also updates an
existing installation when the GitHub source has changed.

After installation, the reference pages are available within R:

```r
help(package = "SnapshotFDA")
?snapshot_fit
?snapshot_spec
```

## Model and data

For time $t$ in $[0,1]$, the model is

$$
X(t) = \mu(t) + v_1(t)\zeta_1 + v_2(t)\zeta_2,
\qquad Y = X(T) + \varepsilon.
$$

Here, $\mu$ is the population mean, $v_1$ and $v_2$ are loading functions,
and $\zeta_1$ and $\zeta_2$ are independent scores with mean zero and variance
one. The measurement error $\varepsilon$ is independent Gaussian noise, and
the observation time $T$ is independent of the scores and the noise. The
covariance is

$$
C(s,t) = v_1(s)v_1(t) + v_2(s)v_2(t).
$$

Covariance identification uses non-Gaussian scores and the loading and
separation conditions in the accompanying paper. For the analytic model,
these include linear independence of the loadings and of $1$, $v_1^2$, and
$v_2^2$. The Gaussian case and weakly identified settings are included among
the simulation scenarios.

The fitting data have columns `time` and `response`, with an optional `id`
column containing distinct subject identifiers. `snapshot_data()` checks
this format and requires one observation per subject. Times must lie in
`[0, 1]`; data collected on another interval should be rescaled before fitting.

## Example

Generate 2,000 independent snapshots from the regular simulation model and
fit the normal-mixture score sieve:

```r
library(SnapshotFDA)

sim <- snapshot_simulate(n = 2000, scenario = "regular", seed = 2026)

spec <- snapshot_spec(
  degree = 2,
  mean_degree = 2,
  sieve = "normal"
)

control <- snapshot_control(
  n_start = 12,
  maxit = 2000,
  gradient = "analytic",
  trace = FALSE
)

fit <- snapshot_fit(sim$data, spec, control, seed = 2027)
print(fit)

if (!isTRUE(fit$success)) {
  stop(fit$status)
}
```

The simulator returns the observed snapshots in `sim$data`, the latent curves
in `sim$curves`, and the generating model in `sim$truth`. Only `sim$data` is
passed to the estimator.

Evaluate the fitted mean and covariance, and obtain the functional principal
components:

```r
grid <- seq(0, 1, length.out = 101)

mean_hat <- snapshot_mean(fit, grid)
covariance_hat <- snapshot_covariance(fit, grid)
fpca <- snapshot_fpca(fit, grid)

fpca$eigenvalues
```

The estimated covariance can be displayed as a surface:

```r
persp(
  grid, grid, covariance_hat,
  theta = -40, phi = 25, expand = 0.65,
  col = "#A5C7D3", border = NA, shade = 0.25,
  ticktype = "detailed",
  xlab = "s", ylab = "t", zlab = "Covariance",
  cex.lab = 1.2, cex.axis = 1.0
)
```

Since this example is simulated, the generating covariance is available for
assessment. A trapezoidal approximation to the relative Hilbert--Schmidt
error is

```r
covariance_true <- snapshot_covariance(sim$truth, grid)
w <- snapshot_trapezoid_weights(grid)
W <- outer(w, w)

sqrt(sum(W * (covariance_hat - covariance_true)^2) /
       sum(W * covariance_true^2))
```

For prediction, generate three new subjects with one observation each:

```r
new_data <- snapshot_simulate(n = 3, model = sim$truth, seed = 2028)$data

prediction <- snapshot_reconstruct(
  fit,
  time = new_data$time,
  response = new_data$response,
  grid = grid
)

matplot(
  grid, t(prediction$mean),
  type = "l", lty = 1, lwd = 2,
  xlab = "Time", ylab = "Conditional mean"
)
```

Rows of `prediction$mean` correspond to subjects, and columns correspond to
the evaluation grid. `prediction$variance` contains the conditional variance
of the latent curve under the fitted model. These quantities condition on
the estimated parameters; they do not include parameter-estimation uncertainty.

## Main functions

| Purpose | Functions |
| --- | --- |
| Prepare snapshot data | `snapshot_data()` |
| Specify the parameter class and numerical options | `snapshot_spec()`, `snapshot_control()` |
| Fit the model | `snapshot_fit()` |
| Estimate the mean and dependence | `snapshot_mean()`, `snapshot_covariance()`, `snapshot_correlation()` |
| Evaluate loadings and principal components | `snapshot_loadings()`, `snapshot_fpca()` |
| Evaluate the response distribution given time | `snapshot_density()`, `snapshot_cdf()`, `snapshot_quantile()` |
| Predict latent curves and scores | `snapshot_reconstruct()`, `snapshot_reconstruct_quantile()`, `snapshot_posterior_scores()` |
| Examine model constraints and identification diagnostics | `snapshot_model_diagnostics()`, `snapshot_ode_coefficients()`, `snapshot_frequency_gram()` |
| Generate models and observations | `snapshot_truth()`, `snapshot_simulate()` |
| Obtain the paper's simulation designs and settings | `snapshot_design()`, `snapshot_study_settings()`, `snapshot_study_data()` |

## Parameter classes and diagnostics

`snapshot_spec(sieve = "normal")` uses standardized two-component normal
mixtures for the two score distributions. `snapshot_spec(sieve = "atomic")`
uses standardized discrete laws on a grid and requires equal degrees for the
mean and loadings. Both sieves use Chebyshev expansions and constraints on
the coefficients, noise variance, score moments, and separation indices.
The degrees, bounds, and thresholds specify the fitted parameter class.

Inspect the model and solver diagnostics after fitting:

```r
snapshot_model_diagnostics(fit)
fit$diagnostics
fit$loglik
```

The solver uses multiple starting values and returns an accepted numerical
candidate when its feasibility and stopping checks pass. It does not certify
a global likelihood maximum. Fitted values can depend on the starting values
and numerical settings. The non-Gaussianity diagnostic is evaluated on a
frequency grid, with 401 points by default. See `?snapshot_control` and
`?snapshot_spec` for the acceptance rules and class constraints.

## Simulation designs

The package includes the models, settings, and data generators for Studies
A--E of the paper:

```r
design <- snapshot_design(c("A", "B", "C", "D", "E"))
head(design)

settings <- snapshot_study_settings()
d <- snapshot_study_data("A", "regular", n = 2000, replication = 1)
```

`d$train` contains the training snapshots, `d$test` contains an independent
assessment sample, and `d$truth` contains the generating model. Study E also
returns two-visit data in `d$pairs`. These functions generate the designs and
individual replications; fitting and summarizing a full Monte Carlo study
requires a replication loop.


Questions and reproducible bug reports can be submitted through
[GitHub Issues](https://github.com/UfukBeyaztas/SnapshotFDA/issues).

License: GPL-3, as specified in [DESCRIPTION](DESCRIPTION).
