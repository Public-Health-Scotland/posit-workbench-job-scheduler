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
#install.packages("tibble")
#install.packages("dplyr")

### 01 Define an empty tibble for recording the status of scheduled jobs ----

scheduled_workbench_jobs <- tibble::tibble(
  job_name = character(0),
  schedule_name = character(0),
  due = as.POSIXct(character())
)

### 02 schedule_workbench_job()  ----

# A function to programmatically schedule the launch of a workbench job on the
# Kubernetes cluster
schedule_workbench_job <- function(job_name,       # Name to give the Workbench Job
                                   schedule_name,  # The name of the event loop to schedule the Workbench Job on        
                                   due,            # Date / time (as POSIXct) to run the Workbench Job
                                   rpt = NULL,     # Repeat every n seconds thereafter
                                   project_path,   # Path to project / working directory
                                   script,         # Relative path to R script to execute
                                   n_cpu = NULL,   # Number of CPUs to request
                                   n_ram = NULL) { # Amount of memory (MB) to request
  
  # Create a private event loop for the schedule, if it doesn't already exist
  if(!exists(eval(schedule_name))) {
    assign(schedule_name, later::create_loop(), envir = .GlobalEnv)
  }
  
  # Add the details of the first run of the workbench job to the tibble
  # 'scheduled_workbench_jobs'
  scheduled_workbench_jobs <<- dplyr::bind_rows(
    scheduled_workbench_jobs,
    tibble::tibble(job_name = job_name,
                   schedule_name = schedule_name,
                   due = due)
  )
  
  # Schedule the first run, and all subsequent runs, of the workbench job
  initial_delay <- as.numeric(difftime(due, lubridate::as_datetime(Sys.time()), units = "secs"))
  
  later::later(
    function() {
      f <- function() {
        
        # Schedule the workbench job
        job_id <- launch_workbench_job(job_name = job_name,
                                       project_path = project_path,
                                       script = script,
                                       n_cpu = n_cpu,
                                       n_ram = n_ram)

        # Recursively call this function every 'rpt' seconds
        if(!is.null(rpt)) {
          
          # Calculate the date and time when the workbench job should next run
          due <<- due + lubridate::seconds(rpt)
          
          # Add the details of the next run of the workbench job to the tibble
          # 'scheduled_workbench_jobs'
          scheduled_workbench_jobs <<- dplyr::bind_rows(
            scheduled_workbench_jobs,
            tibble::tibble(job_name = job_name,
                           schedule_name = schedule_name,
                           due = due)
          )
          
          # Schedule the next run of the workbench job
          later::later(f, rpt)
        }
      }
      
      f()
    },
    delay = initial_delay,
    loop = eval(parse(text = schedule_name))
  )
}



####

schedule_workbench_job(
  job_name = "task1",
  schedule_name = "task1_schedule",
  due = lubridate::ymd_hms("2023-01-05 14:02:00"),
  rpt = 120,
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

