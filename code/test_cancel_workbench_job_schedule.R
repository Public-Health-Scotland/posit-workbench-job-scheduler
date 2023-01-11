################################################################################
# Name of file:       test_cancel_workbench_job_schedule.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically cancel a schedule of workbench jobs
# created by the function 'schedule_workbench_job()'.
################################################################################

### 00 Required packages ----

#install.packages("here")
#install.packages("lubridate")

### 01 Source function script ----

source(file.path(here::here(), "code/launch_workbench_job.R"))
source(file.path(here::here(), "code/schedule_workbench_job.R"))
source(file.path(here::here(), "code/cancel_workbench_job_schedule.R"))

### 02 Schedule multiple Workbench Jobs on multiple schedules ----

# Schedule multiple Workbench Jobs on multiple schedules
for(i in seq(1, 9)){
  schedule_workbench_job(
    job_name = paste0("job_name_", i),
    schedule_name = paste0("schedule_", i),
    due = lubridate::now() + lubridate::minutes(1),
    rpt = as.numeric(lubridate::as.duration("5 minutes")),
    project_path = here::here(),
    script = "code/test_launch_workbench_job_script.R",
    n_cpu = 0.25,
    n_ram = 128
  )  
}

# View the tibble (10 seconds later) containing the details of the scheduled
# workbench jobs
later::later(function() {View(scheduled_workbench_jobs)}, 10)


### 03 Cancel some of the schedules ----

for(i in seq(3, 5)){
  cancel_workbench_job_schedule(paste0("schedule_", i))
}

# View the tibble (10 seconds later) containing the details of the scheduled
# workbench jobs
later::later(function() {View(scheduled_workbench_jobs)}, 10)


