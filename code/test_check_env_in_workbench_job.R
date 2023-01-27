################################################################################
# Name of file:       test_check_env_in_workbench_job.R
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

### 00 Output environment details in normal Posit Workbench session

source(here::here("code", "test_check_env_in_workbench_job_script.R"))

### 00 Launch Workbench Job ----

job_id <- launch_workbench_job(job_name = "Check Environment in Workbench Job",
                               project_path = here::here(),
                               script = "code/test_check_env_in_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

Sys.sleep(3)

rstudioapi::launcherGetJob(job_id)
