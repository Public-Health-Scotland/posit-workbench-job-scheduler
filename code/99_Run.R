#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Name of file:       99_Run.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### -- Source R scripts ----

# Restore the project's dependencies from the lockfile
renv::restore(
  rebuild = TRUE,
  clean = TRUE,
  prompt = FALSE)

# Set R, knitr and project-specific options
source(file.path(here::here(), "code", "00_Setup_01_Options.R"))

# Define file paths
source(file.path(here::here(), "code", "00_Setup_02_Paths.R"))

# Define functions to write to stdout and stderr
source(file.path(here::here(), "code", "01_Functions_00_write_output_to_stdout_or_stderr.R"))

# Define launch_workbench_job()
source(file.path(here::here(), "code", "01_Functions_01_launch_workbench_job.R"))

# Define schedule_workbench_job()
source(file.path(here::here(), "code", "01_Functions_02_schedule_workbench_job.R"))

# Define cancel_workbench_job_schedule()
source(file.path(here::here(), "code", "01_Functions_03_cancel_workbench_job_schedule.R"))

#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

### -- Inform user that the Posit Workbench Job Scheduler is now running ----

cli::cli_inform(c(
  "v" = "Posit Workbench Job Scheduler is running",
  "i" = "Please ensure that you do not quit this Posit Workbench session!"
))