################################################################################
# Name of file:       schedule_workbench_job.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Functions to programmatically schedule the launch of workbench jobs on the
# Kubernetes cluster.
################################################################################

### 00 Required packages ----

#install.packages("rstudioapi")
#install.packages("later")
#install.packages("lubridate")

### 01 schedule_workbench_job()  ----

# A function to programmatically schedule the launch of a workbench job on the
# Kubernetes cluster
schedule_workbench_job <- function(project,           # Path to project / working directory
                                   script,            # Relative path to R script to execute
                                   ncpus = NULL,      # Number of CPUs to request
                                   mem = NULL,        # Amount of memory (MB) to request
                                   job_name = NULL,   # Name to give the Workbench Job
                                   schedule_entries,  # List of dates / times when Workbench Job should be launched
                                   schedule_name) {   # A name for the schedule
  
  # Create a private event loop for the schedule
  assign(schedule_name, later::create_loop())
  
  # Schedule the job to run at each date and time listed in schedule_entries
  for (dt in schedule_entries){
    later::later(function() {
      job_id <- launch_workbench_job(project = project,
                                     script = script,
                                     ncpus = ncpus,
                                     mem = mem,
                                     job_name = job_name)
    },
    delay = as.numeric(difftime(dt, lubridate::as_datetime(Sys.time()), units = "secs")),
    loop = eval(parse(text = schedule_name)))
  }
  
  return(eval(parse(text = schedule_name)))
}

schedule_entries <- list(
  lubridate::ymd_hms("2023-01-04 15:41:00"),
  lubridate::ymd_hms("2023-01-04 15:42:00")
)

schedule_handle <- schedule_workbench_job(
  project = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  ncpus = 0.25,
  mem = 128,
  job_name = "Test Workbench Job",
  schedule_entries = schedule_entries,
  schedule_name = "Test")

later::exists_loop(schedule_handle)

