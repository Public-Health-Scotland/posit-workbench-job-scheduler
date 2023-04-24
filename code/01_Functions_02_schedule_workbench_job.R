################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Function to programmatically schedule the launch of workbench jobs on the
# Kubernetes cluster.
################################################################################

### 00 schedule_workbench_job()  ----

# A function to programmatically schedule the launch of a workbench job on the
# Kubernetes cluster
schedule_workbench_job <- function(
                                   schedule_name,  # The name of the event loop to schedule the Workbench Job on        
                                   due,            # Date / time (as POSIXct) to run the Workbench Job
                                   rpt = NULL,     # Repeat every n seconds thereafter
                                   job_name,       # Name to give the Workbench Job
                                   project_path,   # Path to project / working directory
                                   script,         # Relative path to R script to execute
                                   n_cpu = NULL,   # Number of CPUs to request
                                   n_ram = NULL) { # Amount of memory (MB) to request
  
  ### ---- Check arguments passed to the function                       ---- ###
  
  # job_name - should be a string (one element character vector)
  if(!inherits(job_name, "character")){
    write_stderr("✖ job_name must be an object of class 'character'.\n")
    stop("job_name is an object of class ", class(job_name), ".")
  } else{
    if (!length(job_name) == 1){
      write_stderr("✖ job_name must be a 'character' vector of length 1.\n")
      stop("job_name is a ", class(job_name), " vector of length ", length(job_name), ".")
    }
  }

  # schedule_name - should be a string (one element character vector)
  if(!inherits(schedule_name, "character")){
    write_stderr("✖ schedule_name must be an object of class 'character'.\n")
    stop("schedule_name is an object of class ", class(schedule_name), ".")
  } else{
    if (!length(schedule_name) == 1){
      write_stderr("✖ schedule_name must be a 'character' vector of length 1.\n")
      stop("schedule_name is a ", class(schedule_name), " vector of length ", length(schedule_name), ".")
    }
  }
  
  # due - should be a single object of class POSIXct 
  if(!length(due) == 1){
    write_stderr("✖ due must be of length 1.\n")
    stop("due has length ", length(due), ".")
  } else{
      if(!inherits(due, "POSIXct")){
        write_stderr("✖ due must be an object of class 'POSIXct'.\n")
        stop("due is an object of class ", class(due), ".")
      }
  }

  # rpt - should be a single object of class numeric (if not null)
  if(!is.null(rpt)){
    if(inherits(rpt, "numeric")){
      if((is.vector(rpt) && length(rpt) > 1) | is.list(rpt)){
        write_stderr("✖ rpt must be of length 1.\n")
        stop("rpt has length ", length(rpt), ".")
      }
    } else{
      write_stderr("✖ rpt must be an object of class numeric.\n")
      stop("rpt is an object of class ", class(rpt), ".")
    }
  }
  
  # project_path - should be a string (one element character vector) containing
  #                the path to an existing directory
  if(!inherits(project_path, "character")){
    write_stderr("✖ project_path must be an object of class 'character'.\n")
    stop("project_path is an object of class ", class(project_path), ".")
  } else{
    if (!length(project_path) == 1){
      write_stderr("✖ project_path must be a 'character' vector of length 1.\n")
      stop("project_path is a ", class(project_path), " vector of length ", length(project_path), ".")
    } else{
      if(!dir.exists(path.expand(project_path))){
        write_stderr("✖ project_path must be a path to an existing directory.\n")
        stop("The directory ", project_path, " does not exist.")
      }
    }
  }
  
  # script - should be a string (one element character vector) containing the 
  #          path to an existing R script, relative to the project_path
  if(!inherits(script, "character")){
    write_stderr("✖ script must be an object of class 'character'.\n")
    stop("script is an object of class ", class(script), ".")
  } else{
    if (!length(script) == 1){
      write_stderr("✖ script must be a 'character' vector of length 1.\n")
      stop("script is a ", class(script), " vector of length ", length(script), ".")
    } else{
      if(!file.exists(file.path(path.expand(project_path), script))){
        write_stderr("✖ script must be a path to an existing file, relative to project_path.\n")
        stop("The file ", file.path(path.expand(project_path), script), " does not exist.")
      }
    }
  }
  
  # n_cpu - should be a single object of class numeric (if not null)
  if(!is.null(n_cpu)){
    if(inherits(n_cpu, "numeric")){
      if((is.vector(n_cpu) && length(n_cpu) > 1) | is.list(n_cpu)){
        write_stderr("✖ n_cpu must be of length 1.\n")
        stop("n_cpu has length ", length(n_cpu), ".")
      }
    } else{
      write_stderr("✖ n_cpu must be an object of class numeric.\n")
      stop("n_cpu is an object of class ", class(n_cpu), ".")
    }
  }
  
  # n_ram - should be a single object of class numeric (if not null)
  if(!is.null(n_ram)){
    if(inherits(n_ram, "numeric")){
      if((is.vector(n_ram) && length(n_ram) > 1) | is.list(n_ram)){
        write_stderr("✖ n_ram must be of length 1.\n")
        stop("n_ram has length ", length(n_ram), ".")
      }
    } else{
      write_stderr("✖ n_ram must be an object of class numeric.\n")
      stop("n_ram is an object of class ", class(n_ram), ".")
    }
  }
  
  ### ---- END Check arguments passed to the function                   ---- ###
  
  # Calculate the initial delay for the first run
  initial_delay <- as.numeric(difftime(due, lubridate::as_datetime(Sys.time()), units = "secs"))
  
  # Check that 'due' is later than current date and time
  if(initial_delay <= 0){
    write_stderr("✖ due must be later than the current system date and time.\n")
    stop("due is earlier than the current system date and time.")
  }
  
  # Create a private event loop for the schedule, if it doesn't already exist
  if(!exists(eval(schedule_name))) {
    assign(schedule_name, later::create_loop(), envir = .GlobalEnv)
  }
  
  # Inform the user that the first run of the workbench job will be launched at
  # the requested time
  write_stdout(paste0("ℹ The schedule '", schedule_name, "' will submit a Workbench ",
                      "Job with the name '", job_name, "' to be launched on ",
                      lubridate::stamp("Friday 31 January 6161", quiet = TRUE)(due),
                      " at ", lubridate::stamp("23:59:59", quiet = TRUE)(due), ".\n"))
  
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

        # Recursively call this function every 'rpt' seconds
        if(!is.null(rpt)) {
          
          # Calculate the date and time when the workbench job should next run
          due <<- due + lubridate::seconds(rpt)
          
          # Inform the user that the next run of the workbench job will be
          # launched at the requested time
          write_stdout(paste0("ℹ The schedule '", schedule_name, "' will submit a Workbench ",
                              "Job with the name '", job_name, "' to be launched on ",
                              lubridate::stamp("Friday 31 January 6161", quiet = TRUE)(due),
                              " at ", lubridate::stamp("23:59:59", quiet = TRUE)(due), ".\n"))
          
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
