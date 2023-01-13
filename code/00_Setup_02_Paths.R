################################################################################
# Name of file:       00_Setup_02_Paths.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Define file paths
################################################################################

### 00 Define data file paths ----

basefiles_path <- file.path(here::here(), "data", "basefiles")
output_path <- file.path(here::here(), "data", "output")
temp_path <- file.path(here::here(), "data", "temp")
lookups_path <- file.path(here::here(), "data", "lookups")
