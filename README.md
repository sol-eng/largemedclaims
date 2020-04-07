
# Sample RMarkdown and plumber workflows for Health Claims

<!-- badges: start -->
[![R build status](https://github.com/kasaai/largemedclaims/workflows/Report/badge.svg)](https://github.com/kasaai/largemedclaims/actions)[![R build status](https://github.com/kasaai/largemedclaims/workflows/API/badge.svg)](https://github.com/kasaai/largemedclaims/actions)
<!-- badges: end -->

This repository contains a couple examples demonstrating [RMarkdown](https://rmarkdown.rstudio.com/)
and [plumber](https://www.rplumber.io/).

- `reports/`: A Paid Charges Exceeding Deductible Amounts report, aggreated by
ICD codes. The deductible amount is a parameter that can be set by the end user.
    - https://colorado.rstudio.com/rsc/med-claims-summary/sample_report.html
- `ml_api/`: A TensorFlow model for predicting claims costs using various
claims characteristics, exposed via a plumber API.
    - https://colorado.rstudio.com/rsc/large_claims_model/
    
In our example, the assets are deployed via GitHub Actions (see `.github/workflows/`)
to [RStudio Connect](https://rstudio.com/products/connect/), but other frameworks,
such as Travis and Jenkins, or manual deployemnt, can also be used.