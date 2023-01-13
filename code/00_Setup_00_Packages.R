################################################################################
# Name of file:       00_Setup_00_Packages.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# (Install and) load required packages
################################################################################

### 00 Set up 'renv' reproducible environment ----

## Ensure that the project's default CRAN repo for package installations is
## RStudio's Public Package Manager.  Add the following line (removing the
## leading "# ") to the end of the project's .Rprofile file which will ensure
## that binary packages compatible with Red Hat Enterprise Linux 7 are
## installed.  Installing binary packages is significantly faster than
## installing packages from source.

# options(repos = c(RSPM = "https://packagemanager.rstudio.com/all/__linux__/centos7/latest"))

## Installation of 'renv' only needs to happen once at the start of the project.
## Comment out this section after 'renv' has been installed and the reproducible
## environment has been initialised.

# install.packages("renv")
# renv::init()

### 01 Restore the project's dependencies from the lockfile ----

renv::restore(
  rebuild = TRUE,
  repos = c(RSPM = "https://packagemanager.rstudio.com/all/__linux__/centos7/latest"),
  clean = TRUE,
  prompt = FALSE)
