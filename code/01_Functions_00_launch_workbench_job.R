################################################################################
# Name of file:       launch_workbench_job.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Function to programmatically launch workbench jobs on the Kubernetes cluster.
################################################################################

### 00 launch_workbench_job()  ----

# A function to programmatically launch a workbench job on the Kubernetes
# cluster
launch_workbench_job <- function(job_name = NULL, # Name to give the Workbench Job
                                 project_path,    # Path to project / working directory
                                 script,          # Relative path to R script to execute
                                 n_cpu = NULL,    # Number of CPUs to request
                                 n_ram = NULL) {  # Amount of memory (MB) to request

  ### ---- Check if the Workbench launcher is available and configured  ---- ###
  ### ---- to support Workbench jobs                                    ---- ###
  
  if(!rstudioapi::launcherAvailable()) {
    cli::cli_abort(c(
      "x" = "The Workbench launcher is either unavailable or not configured to support Workbench jobs."))
  }
  
  ### ---- Check arguments passed to the function                       ---- ###
  
  # job_name - should be a string (one element character vector) (if not null)
  if(!is.null(job_name)){
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
        cli::cli_abort(c(
          "{.var n_cpu} must be of length 1.",
          "x" = paste0("{.var n_cpu} has length ", length(n_cpu), ".")))
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
        cli::cli_abort(c(
          "{.var n_ram} must be of length 1.",
          "x" = paste0("{.var n_ram} has length ", length(n_ram), ".")))
      }
    } else{
      cli::cli_abort(c(
        "{.var n_ram} must be an object of class {.cls {class(1)}}.",
        "x" = "{.var n_ram} is an object of class {.cls {class(n_ram)}}"))
    }
  }
  
  ### ---- END Check arguments passed to the function                   ---- ###
  
  # Retrieve Workbench Launcher Information
  launcher_info <- rstudioapi::launcherGetInfo()
  
  # Define the project's path (i.e. the working directory)
  project_path <- path.expand(project_path)

  # Define the R script to execute
  script_path <- path.expand(file.path(project_path, script))
  script_file <- basename(script_path)
  script_arg <- paste("-f", script_path)
  
  # Define a tag for the job
  job_tag <- paste("rstudio-r-script-job", script_file, sep = ":")
  
  # Get the cluster's resource limits
  cluster_resource_limits <- as.data.frame(
    do.call(rbind, launcher_info$clusters[[1]]$resourceLimits)
  )
  
  # Stop if number of CPUs requested is greater than maximum permitted
  cpu_count_max_value <- as.numeric(
    subset(cluster_resource_limits, type == "cpuCount")[, "maxValue"]
  )
  
  if(!is.null(n_cpu)) {
    if(n_cpu > cpu_count_max_value) {
      cli::cli_abort(c(
        "{.var n_cpu} must not exceed maximum permitted.",
        "x" = paste0("{.var n_cpu} requested (", n_cpu, ") is greater than ",
                     "maximum permitted (", cpu_count_max_value, ").")))
    }
  }
  
  # Stop if amount of memory requested is greater than maximum permitted
  ram_count_max_value <- as.numeric(
    subset(cluster_resource_limits, type == "memory")[, "maxValue"]
  )
  
  if(!is.null(n_ram)) {
    if(n_ram > ram_count_max_value) {
      cli::cli_abort(c(
        "{.var n_ram} must not exceed maximum permitted.",
        "x" = paste0("{.var n_ram} requested (", n_ram, ") is greater than ",
                     "maximum permitted (", ram_count_max_value, ").")))
    }
  }
  
  # Define the job's resource limits
  job_cpu_count <- rstudioapi::launcherResourceLimit(
    type = "cpuCount",
    value = sprintf(
      ifelse(
        is.null(n_cpu),
        as.numeric(subset(cluster_resource_limits, type == "cpuCount")[, "defaultValue"]),
        n_cpu
      ),
      fmt = "%#.6f"
    )
  )
  
  job_memory <- rstudioapi::launcherResourceLimit(
    type = "memory",
    value = sprintf(
      ifelse(
        is.null(n_ram),
        as.numeric(subset(cluster_resource_limits, type == "memory")[, "defaultValue"]),
        n_ram
      ),
      fmt = "%#.6f"
    )
  )
  
  job_resource_limits <- list(job_cpu_count, job_memory)
  
  # Submit the Workbench Job
  job_id <- rstudioapi::launcherSubmitJob(
    name = ifelse(is.null(job_name), script_file, job_name),
    cluster = launcher_info$clusters[[1]]$name,
    tags = c(job_tag),
    command = "R",
    args = c("--slave", "--no-save", "--no-restore", script_arg),
    workingDirectory = project_path,
    container = rstudioapi::launcherContainer(image = launcher_info$clusters[[1]]$defaultImage),
    resourceLimits = job_resource_limits,
    applyConfigSettings = TRUE
  )
  
  # Inform the user that the Workbench Job has been launched
  cli::cli_inform(c(
    "v" = paste0("A Workbench Job with id '", job_id, "' and name '",
                 ifelse(is.null(job_name), script_file, job_name), "' has ",
                 "been launched on the cluster '", launcher_info$clusters[[1]]$name, "'.")
  ))
  
  return(job_id)
}





