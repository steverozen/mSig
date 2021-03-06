#' For each combination of several signatures, determine if the combination is plausibly needed to reconstruct a spectrum.
#'
#' @description Please see \strong{Details}.
#'
#' @param spect The spectrum to be reconstructed, as single column matrix or
#'  \code{\link[ICAMS]{ICAMS}} catalog.
#'
#' @param all.sigs The matrix or catalog of all signatures of possible interest,
#' which consist of the signatures for \eqn{H_0} and for the alternative
#' hypotheses.
#'
#' @param Ha.sigs.indices An integer vector of the indices of the signatures
#' that are in the various \eqn{H_a}'s.
#'
#' @param m.opts Controls the numerical search for maximum likelihood
#'    reconstructions of \code{spect} plus some additional
#'    flags; see \code{\link{DefaultManyOpts}}.
#'
#' @param max.mc.cores
#'   The maximum number of cores to use.
#'   If \code{NULL} defaults to \eqn{2^{n_a} - 1},
#'    where \eqn{n_a} is the length of \code{Ha.sigs.indices} -- except on
#'    MS Windows machines, where it defaults to 1.
#'
#' @details
#' Let \eqn{H_0} be the likelihood that
#' the signatures specified by \code{all.sigs[, -Ha.sigs.indicies, drop = FALSE]}
#' generated the observed spectrum, \code{spect}.
#' For each non-empty subset, \eqn{S},
#' of \code{Ha.sigs.indices} let \eqn{H_a}
#' be the likelihood that all the signatures in \eqn{H_0}
#' plus the signatures specified by \eqn{S} generated \code{spect}.
#' Return a list with the results of likelihood ratio tests of
#' all \eqn{H_a}'s against \eqn{H_0}.
#'
#' @return A list with two elements: \describe{
#'
#' \item{\code{H0.info}}{contains a 1-row \code{\link[tibble]{tibble}}
#'    with the columns \describe{
#'
#'       \item{\code{loglh}}{The log likelihood associated with \eqn{H_0}.}
#'
#'       \item{\code{exposure}}{A named numeric vector
#'         with the signature attributions (exposures) corresponding
#'         to the \eqn{H_0} log likelihood.}
#'       \item{\code{warnings}}{A character vector of warnings.}
#        \item{\code{maxeval.warnings}}{Deprecated; debugging information.}
#'       \item{\code{global.search.diagnostics}}{Information on
#'           the numerical optimization that provided \code{loglh}.}
#'       \item{\code{local.search.diagnostics}}{Information on
#'           the numerical optimization that provided \code{loglh}.}

#  End inner \describe
#' }
#'
#  End outer \item
#' }
#'
#' \item{\code{all.Ha.info}}{A \code{\link[tibble]{tibble}}
#'    with one Row for each non-empty subset of \code{Ha.sigs.indices}.
#'    The columns are \describe{
#
#'   \item{\code{sigs.added}}{The identifiers of the (additional) signatures
#'        tested.}
#'
#'   \item{\code{p}}{The \eqn{p} value for the likelihood-ratio test. This
#'   this \eqn{p} value can be \code{NaN} when the likelihoods of (\eqn{H_0} and \eqn{H_a})
#'   are both \code{-Inf}. This can occur if there are are mutation classes in the spectra
#'   that are > 0 but that have 0 probability in all the available input signatures.
#'   This is unlikely to occur, since most spectra have non-0 (albeit very small)
#'   probabilities for most mutation classes.}
#'
#'   \item{\code{df}}{The degrees of freedom of the likelihood-ratio test
#'      (equal to the number of signatures in \code{sigs.added}).}
#'
#      End inner \describe
#'      }
#'
#' The remaining columns are as in \code{H0.info}.
#'
#  End top level \item
#' }
#  End top level \describe
#' }
#'
#'
#' @keywords internal

AnySigSubsetPresent <- function(spect,
                                all.sigs,
                                Ha.sigs.indices,
                                m.opts = DefaultManyOpts(),
                                max.mc.cores = 10) {

    H0.sigs <- all.sigs[ , -Ha.sigs.indices, drop = FALSE]  # H0.sigs a matrix of sigs

    start <- OptimizeExposure(spectrum    = spect,
                              sigs        = H0.sigs,
                              m.opts      = m.opts)

    H0.lh <- start$loglh  # The likelihood with only H0.sigs
    start.exp <- start$exposure
    zero.exposures <- which(start.exp < 0.5)
    if (length(zero.exposures) > 0) {
      zero.exposure.msg <-
        paste("There were some signatures with no expsoures in H0:",
              paste(names(start.exp)[zero.exposures], collapse = ", "))
      if (m.opts$trace > 0) message(zero.exposure.msg)
      start$warnings <- c(start$warnings, zero.exposure.msg)
    }

    # For information, in case some signatures are useless
    non.0.exp <- names(start.exp)[which(start.exp > 0.5)]

    # if (m.opts$trace > 0) {
    #  message('H0 sigs are', paste(colnames(H0.sigs), collapse = ','),'\n')
    # }

    # new.subsets contains all non-empty subsets of more.sigs (2^as.set(c()))
    # is the powerset of the empty set, i.e. {{}}).
    new.subsets <- 2^sets::as.set(Ha.sigs.indices) - 2^sets::as.set(c())

    inner.fn <- function(sigs.to.add) {
      df <- sets::set_cardinality(sigs.to.add) # degrees of freedom for likelihood ratio test
      Ha.info <- OptimizeExposure(
        spectrum  = spect,
        sigs        = cbind(all.sigs[ , unlist(sigs.to.add), drop = FALSE ], H0.sigs),
        m.opts      = m.opts)

      statistic <- 2 * (Ha.info$loglh - H0.lh)
      p <- stats::pchisq(statistic, df, lower.tail = FALSE)
      return(c(list(p          = p,
                    sigs.added = paste(colnames(all.sigs)[unlist(sigs.to.add)],
                                       collapse = ","),
                    statistic  = statistic,
                    df        = df),
               Ha.info))

      # loglh                     = Ha.info$loglh,
      # exposure                  = Ha.info$exposure,
      # warnings                  = Ha.info$warnings,
      # maxeval.warning           = Ha.info$maxeval.warning,
      # global.search.diagnostics = Ha.info$global.search.diagnostics,
      # local.search.diagnostics  = Ha.info$local.search.diagnostics))
    }

    if (is.null(max.mc.cores)) {
       max.mc.cores <- 2^length(Ha.sigs.indices) - 1
    }

    mc.cores <- Adj.mc.cores(max.mc.cores) # Set to 1 if OS is MS Windows

    out <- parallel::mclapply(new.subsets, inner.fn, mc.cores = mc.cores)

    # H0.info <- start
    # The remainder is temporary until these are removed from OptimizeExposure
    # H0.info$objective    <- NULL
    # H0.info$obj.fn.value <- NULL
    # H0.info$global.res <- NULL
    # H0.info$local.res  <- NULL
    # H0.info$solution   <- NULL

    return(list(H0.info     = List2TibbleRow(start),
                all.Ha.info = ListOfList2Tibble(out)))
  }
