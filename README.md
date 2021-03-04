
<!-- README.md is generated from README.Rmd. Please edit that file -->

# mSigAct

<!-- badges: start -->

[![R build
status](https://github.com/steverozen/mSigAct/workflows/R-CMD-check/badge.svg)](https://github.com/steverozen/mSigAct/actions)
[![AppVeyor build
status](https://ci.appveyor.com/api/projects/status/github/steverozen/mSigAct?branch=master&svg=true)](https://ci.appveyor.com/project/steverozen/mSigAct)
[![License: GPL
v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)

<!-- badges: end -->

Analyze the the “activities” of mutational signatures in one or more
mutational spectra. ‘mSigAct’ stands for **m**utational **Sig**nature
**Act**ivity. mSigAct can estimate (conservatively) whether there is
evidence that a particular mutational signature is present in a spectrum
and can determine a minimal subset of signatures needed to plausibly
reconstruct an observed spectrum.

## Purpose

The concepts behind the code are described in Ng et al., 2017,
“Aristolochic acids and their derivatives are widely implicated in
liver cancers in Taiwan and throughout Asia”, Science Translational
Medicine 2017 <https://doi.org/10.1126/scitranslmed.aan6446>.

## Installation

### Get the stable version

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github(repo = "steverozen/mSigAct", ref = "v2.0.2-branch")
```

The alpha version used in Ng et al., 2017, “Aristolochic acids and their
derivatives are widely implicated in liver cancers in Taiwan and
throughout Asia”, Science Translational Medicine 2017
<https://doi.org/10.1126/scitranslmed.aan6446> is at
<https://github.com/steverozen/mSigAct/tree/v1.2-alpha-branch>.

### Get the development version

To use new features in the development version, you can install mSigAct
from the master branch on [GitHub](https://github.com/), which may not
be stable:

``` r
if (!requireNamespace("remotes", quietly = TRUE)) {
  install.packages("remotes")
}
remotes::install_github(repo = "steverozen/mSigAct", ref = "master")
```

## Reference manual

<https://github.com/steverozen/mSigAct/blob/master/data-raw/mSigAct_2.1.0.9006.pdf>
