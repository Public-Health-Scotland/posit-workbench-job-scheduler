################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Function to programmatically cancel a schedule of workbench jobs created by
# the function 'schedule_workbench_job()'.
################################################################################

### 00 cancel_workbench_job_schedule() ----

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
      if(!exists(schedule_name, envir = .GlobalEnv)){
        cli::cli_abort(c(
          "{.var schedule_name} must match the name of an object in the .GlobalEnv.",
          "x" = paste0("An object with the name '", schedule_name, "' does not exist in the .GlobalEnv.")))
      } else{
        if(class(get(schedule_name, envir = .GlobalEnv)) != class(later::global_loop())){
          cli::cli_abort(c(
            "{.var schedule_name} must match the name of an object of class {.cls {class(later::global_loop())}}.",
            "x" = paste0("The object '", schedule_name, "' in the Global Environnment is of class {.cls {class(get(schedule_name, envir = .GlobalEnv))}}.")))
        }
      }
    }
  }
  
  ### ---- END Check arguments passed to the function                   ---- ###
  
  # Destroy the event loop that 'schedule_name' points to
  later::destroy_loop(get(schedule_name, envir = .GlobalEnv))
  
  # If the 'schedule_name' event loop's status is 'destroyed', remove the
  # 'schedule_name' object from GlobalEnv
  if(!later::exists_loop(get(schedule_name, envir = .GlobalEnv))) {
    cli::cli_inform(c(
      "v" = paste0("The schedule '", schedule_name, "' has successfully been cancelled."),
      "i" = paste0("No further Workbench Jobs that were scheduled on '", schedule_name, "' will be launched.")
    ))
    rm(list = as.character(schedule_name), envir = .GlobalEnv)
  } else{
    cli::cli_abort(c(
      paste0("Unable to remove {.var ", schedule_name, "} from {.code .GlobalEnv}."),
      "x" = paste0("The event loop {.var ", schedule_name, "} still exists."),
      "i" = paste0("Ensure that the event loop is destroyed first: {.code later::destroy_loop(", schedule_name, ")}.")))
  }
  
  # Inform the user of the remaining schedules
  r <- lapply(ls(envir = .GlobalEnv), function(x){
    if(class(get(x, envir = .GlobalEnv)) == class(later::global_loop())){
        cli::cli_inform(c(
          "i" = paste0("The schedule '", x, "' is still active.")
        ))
    }
  })
}
