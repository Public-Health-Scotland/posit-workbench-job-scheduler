################################################################################
# Name of file:       test_schedule_workbench_job.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically schedule workbench jobs on the Kubernetes
# cluster.
################################################################################

### 00 Schedule Workbench Job ----

# Schedule a workbench job
schedule_workbench_job(
  job_name = "job_name_1",
  schedule_name = "schedule_1",
  due = lubridate::now() + lubridate::seconds(10),
  rpt = as.numeric(lubridate::as.duration("3 days")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)
