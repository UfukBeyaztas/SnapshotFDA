\name{snapshot_data}
\alias{snapshot_data}
\title{Snapshot data}
\usage{
snapshot_data(time, response, id = seq_along(time))
}
\arguments{
\item{time}{observation times \eqn{T_i}{T_i} in [0, 1].}

\item{response}{responses \eqn{Y_i}{Y_i}, one for each time.}

\item{id}{distinct subject identifiers.}
}
\value{
A data frame with columns \code{id}, \code{time} and \code{response}.
}
\description{
Data frame of a snapshot sample: one observation time and one response for each of n
independent subjects.
}
\details{
The snapshot likelihood treats the rows as independent subjects, each observed once, so
the identifiers must be distinct. Times must lie in [0, 1]; rescale other time ranges
before fitting.
}
\examples{
\dontrun{
# the training sample of Study A, truth "regular", n = 2000
d <- snapshot_study_data("A", "regular", 2000)
train <- snapshot_data(d$train$time, d$train$response)
head(train)
}
}
\seealso{
\code{\link{snapshot_fit}}, \code{\link{snapshot_simulate}}
}
