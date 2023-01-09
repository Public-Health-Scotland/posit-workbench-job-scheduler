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
  
  ### ---- Check arguments passed to the function                       ---- ###
  
  # job_name - should be a string (one element character vector)
  if(!inherits(job_name, "character")){
    cli::cli_abort(c(
      "{.var job_name} must be an object of class {.cls {class('character')}}.",
      "x" = "{.var job_name} is an object of class {.cls {class(job_name)}}."))
  } else{
    if (!length(job_name) == 1){
      cli::cli_abort(c(
        "{.var job_name} must be a {.cls {class('character')}} vector of length 1.",
        "x" = paste0("{.var job_name} is a {.cls {class(job_name)}} vector of length ", length(job_name), ".")))
    }
  }
  
  # schedule_name - should be a string (one element character vector)
  if(!inherits(schedule_name, "character")){
    cli::cli_abort(c(
      "{.var schedule_name} must be an object of class {.cls {class('character')}}.",
      "x" = "{.var schedule_name} is an object of {.cls {class(schedule_name)}}."))
  } else{
    if (!length(schedule_name) == 1){
      cli::cli_abort(c(
        "{.var schedule_name} must be a {.cls {class('character')}} vector of length 1.",
        "x" = paste0("{.var schedule_name} is a {.cls {class(schedule_name)}} vector of length ", length(schedule_name), ".")))
    }
  }
  
  # due - should be a single object of class POSIXct 
  if(inherits(due, "POSIXct")){
    if(is.vector(due) | is.list(due)){
      cli::cli_abort(
        "{.var due} must be of length 1.",
        "x" = paste0("{.var due} has length ", length(due), "."))
    }
  } else{
    cli::cli_abort(c(
        "{.var due} must be an object of class {.cls {class(lubridate::as_datetime(Sys.time()))}}.",
        "x" = "{.var due} is an object of class {.cls {class(due)}}"))
  }

  # rpt - should be a single object of class numeric (if not null)
  if(!is.null(rpt)){
    if(inherits(rpt, "numeric")){
      if((is.vector(rpt) && length(rpt) > 1) | is.list(rpt)){
        cli::cli_abort(
          "{.var rpt} must be of length 1.",
          "x" = paste0("{.var rpt} has length ", length(rpt), "."))
      }
    } else{
      cli::cli_abort(c(
        "{.var rpt} must be an object of class {.cls {class(1)}}.",
        "x" = "{.var rpt} is an object of class {.cls {class(rpt)}}"))
    }
  }
  
  # project_path - should be a string (one element character vector) containing
  #                the path to an existing directory
  if(!inherits(project_path, "character")){
    cli::cli_abort(c(
      "{.var project_path} must be an object of class {.cls {class('character')}}.",
      "x" = "{.var project_path} is an object of class {.cls {class(project_path)}}."))
  } else{
    if (!length(project_path) == 1){
      cli::cli_abort(c(
        "{.var project_path} must be a {.cls {class('character')}} vector of length 1.",
        "x" = paste0("{.var project_path} is a {.cls {class(project_path)}} vector of length ", length(project_path), ".")))
    } else{
      if(!dir.exists(path.expand(project_path))){
        cli::cli_abort(c(
        "{.var project_path} must be a path to an existing directory.",
        "x" = paste0("The directory ", project_path, " does not exist.")))
      }
    }
  }
  
  # script - should be a string (one element character vector) containing the 
  #          path to an existing R script, relative to the project_path
  if(!inherits(script, "character")){
    cli::cli_abort(c(
      "{.var script} must be an object of class {.cls {class('character')}}.",
      "x" = "{.var script} is an object of class {.cls {class(script)}}."))
  } else{
    if (!length(script) == 1){
      cli::cli_abort(c(
        "{.var script} must be a {.cls {class('character')}} vector of length 1.",
        "x" = paste0("{.var script} is a {.cls {class(script)}} vector of length ", length(script), ".")))
    } else{
      if(!file.exists(file.path(path.expand(project_path), script))){
        cli::cli_abort(c(
        "{.var script} must be a path to an existing file, relative to {.var project_path}",
        "x" = paste0("The file ", file.path(path.expand(project_path), script), " does not exist.")))
      }
    }
  }
  
  # n_cpu - should be a single object of class numeric (if not null)
  if(!is.null(n_cpu)){
    if(inherits(n_cpu, "numeric")){
      if((is.vector(n_cpu) && length(n_cpu) > 1) | is.list(n_cpu)){
        cli::cli_abort(
          "{.var n_cpu} must be of length 1.",
          "x" = paste0("{.var n_cpu} has length ", length(n_cpu), "."))
      }
    } else{
      cli::cli_abort(c(
        "{.var n_cpu} must be an object of class {.cls {class(1)}}.",
        "x" = "{.var n_cpu} is an object of class {.cls {class(n_cpu)}}"))
    }
  }
  
  # n_ram - should be a single object of class numeric (if not null)
  if(!is.null(n_ram)){
    if(inherits(n_ram, "numeric")){
      if((is.vector(n_ram) && length(n_ram) > 1) | is.list(n_ram)){
        cli::cli_abort(
          "{.var n_ram} must be of length 1.",
          "x" = paste0("{.var n_ram} has length ", length(n_ram), "."))
      }
    } else{
      cli::cli_abort(c(
        "{.var n_ram} must be an object of class {.cls {class(1)}}.",
        "x" = "{.var n_ram} is an object of class {.cls {class(n_ram)}}"))
    }
  }
  
  ### ---- END Check arguments passed to the function                   ---- ###
  

  # Calculate the initial delay for the first run
  initial_delay <- as.numeric(difftime(due, lubridate::as_datetime(Sys.time()), units = "secs"))
  
  # Check that 'due' is later than current date and time
  if(initial_delay <= 0){
    cli::cli_abort(c(
      "{.var due} must be later than the current system date and time.",
      "x" = "{.var due} is earlier than the current system date and time."
    ))
  }
  
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
  job_name = "job_name_1",
  schedule_name = "schedule_1",
  due = lubridate::ymd_hms("2023-01-10 22:00:00"),
  rpt = as.numeric(lubridate::as.duration("7 days")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)



