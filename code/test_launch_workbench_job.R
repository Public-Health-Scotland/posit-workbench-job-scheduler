################################################################################
# Name of file:       test_launch_workbench_job.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically launch workbench jobs on the Kubernetes
# cluster.
################################################################################

### 00 Required packages ----

#install.packages("here")

### 01 Source function script ----

source(file.path(here::here(), "code/launch_workbench_job.R"))

### 02 Launch Workbench Job ----

job_id <- launch_workbench_job(project = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               ncpus = 0.25,
                               mem = 128,
                               job_name = "Test Workbench Job")

Sys.sleep(3)

rstudioapi::launcherGetJob(job_id)