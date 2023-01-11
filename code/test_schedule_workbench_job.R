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

### 00 Required packages ----

#install.packages("here")
#install.packages("lubridate")

### 01 Source function script ----

source(file.path(here::here(), "code/launch_workbench_job.R"))
source(file.path(here::here(), "code/schedule_workbench_job.R"))

### 02 Schedule Workbench Job ----

# Schedule a workbench job
schedule_workbench_job(
  job_name = "job_name_1",
  schedule_name = "schedule_1",
  due = lubridate::now() + lubridate::seconds(10),
  rpt = as.numeric(lubridate::as.duration("7 days")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

# View the tibble (10 seconds later) containing the details of the scheduled
# workbench jobs
later::later(function() {View(scheduled_workbench_jobs)}, 10)

# Destroy the private event loop created to schedule the workbench job on a few
# seconds later
later::later(function() {
  later::destroy_loop(schedule_1)
  rm(schedule_1)  
},
20)






