% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SignaturePresenceTest1.R
\name{SignaturePresenceTest1}
\alias{SignaturePresenceTest1}
\title{Test whether a given signature is plausibly present in a spectrum.}
\usage{
SignaturePresenceTest1(spectrum, sigs, target.sig.index, m.opts)
}
\arguments{
\item{spectrum}{The spectrum to analyze.}

\item{sigs}{A catalog of signatures from which to choose.}

\item{target.sig.index}{The index of the signature the presence
of which we want to test.}

\item{m.opts}{For documentation
see \code{\link{DefaultManyOpts}}.}
}
\description{
For backward compatibility. See also \code{\link{AnySigSubsetPresent}}.
}
