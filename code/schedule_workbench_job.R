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
  job_id = character(0),
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
    tibble::tibble(job_id = "",
                   job_name = job_name,
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

        # Add the job_id to workbench job to the tibble
        # 'scheduled_workbench_jobs'
        a <- job_id
        b <- job_name
        c <- schedule_name
        d <- due
        scheduled_workbench_jobs <<- within(
          scheduled_workbench_jobs,
          job_id[job_name      == b &
                 schedule_name == c &
                 due           == d] <- a
        )
        rm(list = letters[1:4])
        
        # Recursively call this function every 'rpt' seconds
        if(!is.null(rpt)) {
          
          # Calculate the date and time when the workbench job should next run
          due <<- due + lubridate::seconds(rpt)
          
          # Add the details of the next run of the workbench job to the tibble
          # 'scheduled_workbench_jobs'
          scheduled_workbench_jobs <<- dplyr::bind_rows(
            scheduled_workbench_jobs,
            tibble::tibble(job_id = "",
                           job_name = job_name,
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

cancel_schedule <- function(schedule_name){
  tryCatch(
    # Try to destroy the event loop that 'schedule_name' points to
    {
      later::destroy_loop(schedule_name)
    },
    # If an error occurs, handle this
    error = function(e) {
      message("Error in cancel_schedule(schedule_name) caught whilst trying to destroy the event loop that 'schedule_name' points to:")
      print(e)
      return()
    }
  )
  
  tryCatch(
    # If the 'schedule_name' event loop's status is 'destroyed', remove the 'schedule_name'
    # object from GlobalEnv
    {
      if(!later::exists_loop(schedule_name)) {
        rm(list = as.character(substitute(schedule_name)), envir = .GlobalEnv)
      }
    },
    # If an error occurs, handle this
    error = function(e) {
      message("Error in cancel_schedule(schedule_name) caught whilst trying to remove the 'schedule_name' object from GlobalEnv:")
      print(e)
      return()
    }
  )
}

####

schedule_workbench_job(
  job_name = "task2",
  schedule_name = "task2_schedule",
  due = lubridate::ymd_hms("2023-01-05 15:03:00"),
  rpt = 60,
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

