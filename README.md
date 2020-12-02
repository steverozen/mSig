
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mSigAct

<!-- badges: start -->

[![R build
status](https://github.com/steverozen/mSigAct/workflows/R-CMD-check/badge.svg)](https://github.com/steverozen/mSigAct/actions)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/steverozen/mSigAct?branch=master&svg=true)](https://ci.appveyor.com/project/steverozen/mSigAct)

<!-- badges: end -->

Analyze the the “activities” of mutational signatures in one or more
mutational spectra. ‘mSigAct’ stands for **m**tational **Sig**nature
**Act**ivity. mSigAct can estimate (conservatively) whether there is
evidence that a particular mutational signature is present in a spectrum
and can determine a minimal subset of signatures needed to plausibly
reconstruct an observed spectrum.

License: GPL-3

## Purpose

The concepts behind the code are described in Ng et al., 2017,
“Aristolochic acids and their derivatives are widely implicated in
liver cancers in Taiwan and throughout Asia”, Science Translational
Medicine 2017 <https://doi.org/10.1126/scitranslmed.aan6446>.

## Installation

The current stable version is at

``` r
devtools::install_github(repo = "steverozen/mSigAct", ref = "version_2.0.0")
```

The alpha version used in Ng et al., 2017, “Aristolochic acids and their
derivatives are widely implicated in liver cancers in Taiwan and
throughout Asia”, Science Translational Medicine 2017
<https://doi.org/10.1126/scitranslmed.aan6446> is at
<https://github.com/steverozen/mSigAct/tree/v1.2-alpha-branch>.
