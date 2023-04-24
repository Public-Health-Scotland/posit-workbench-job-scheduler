################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically cancel a schedule of workbench jobs
# created by the function 'schedule_workbench_job()'.
################################################################################

### 00 Cancel Workbench Job ----

#### 00 Schedule multiple Workbench Jobs on multiple schedules ----

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
  Sys.sleep(60)
}

#### 00 Test Argument Handling - schedule_name ----

cancel_workbench_job_schedule(1)

cancel_workbench_job_schedule(c("schedule_1", "schedule_2"))

cancel_workbench_job_schedule("a_schedule_that_does_not_exist")

an_object_that_is_not_an_event_loop <- 1
cancel_workbench_job_schedule("an_object_that_is_not_an_event_loop")

### 03 Cancel some of the schedules at a later point ----

later::later(function() {
  for(i in seq(3, 5)){
    cancel_workbench_job_schedule(paste0("schedule_", i))
  }
}, 10)





