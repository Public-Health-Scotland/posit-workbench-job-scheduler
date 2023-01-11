################################################################################
# Name of file:       cancel_workbench_job_schedule.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Function to programmatically cancel a schedule of workbench jobs created by
# the function 'schedule_workbench_job()'.
################################################################################

### 00 Required packages ----


### 01 cancel_workbench_job_schedule() ----

cancel_workbench_job_schedule <- function(schedule_name){ # The name of the schedule (event loop) to cancel
  
  ### ---- Check arguments passed to the function                       ---- ###
  
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
    } else{
      if(!exists(substitute(schedule_name), envir = .GlobalEnv)){
        cli::cli_abort(c(
          "{.var schedule_name} must match the name of an object in the Global Environment.",
          "x" = paste0("An object with the name '", schedule_name, "' does not exist in the Global Environment.")))
      } else{
        if(class(get(schedule_name, envir = .GlobalEnv)) != class(later::global_loop())){
          cli::cli_abort(c(
            "{.var schedule_name} must match the name of an object of class {.cls {class(later::global_loop())}}.",
            "x" = paste0("The object '", schedule_name, "' in the Global Environnment is of class {.cls {class(get(schedule_name, envir = .GlobalEnv))}}.")))
        }
      }
    }
  }
}
  
  ### ---- END Check arguments passed to the function                   ---- ###
  
  
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


