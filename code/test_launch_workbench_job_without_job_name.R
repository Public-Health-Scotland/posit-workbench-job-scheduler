################################################################################
# Name of file:       test_launch_workbench_job_without_job_name.R
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

### 00 Launch Workbench Job ----

job_id <- launch_workbench_job(project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R")

Sys.sleep(3)

rstudioapi::launcherGetJob(job_id)
