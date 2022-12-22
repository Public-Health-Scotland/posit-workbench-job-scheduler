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

### 00 Required packages ----

#install.packages("rstudioapi")

### 01 launch_workbench_job()  ----

# A function to programmatically launch a workbench job on the Kubernetes
# cluster
launch_workbench_job <- function(project,           # Path to project / working directory
                                 script,            # Relative path to R script to execute
                                 ncpus = NULL,      # Number of CPUs to request
                                 mem = NULL,        # Amount of memory (MB) to request
                                 job_name = NULL) { # Name to give the Workbench Job
  if(!rstudioapi::launcherAvailable()) {
    stop("Workbench launcher is not available.")
  } else {
    
    # Retrieve Workbench Launcher Information
    launcher_info <- rstudioapi::launcherGetInfo()
    
    # Define the project's path (i.e. the working directory)
    project_path <- path.expand(project)
    if(!dir.exists(project_path)) {
      stop(paste0("The directory '", project_path, "' does not exist."))
    }
    
    # Define the R script to execute
    script_path <- path.expand(file.path(project_path, script))
    if(!file.exists(script_path)) {
      stop(paste0("The file '", script_path, "' does not exist."))
    }
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
    
    if(!is.null(ncpus)) {
      if(ncpus > cpu_count_max_value) {
        stop(paste0("'cpu_count' requested (", ncpus, ") is greater than ",
                    "maximum permitted (", cpu_count_max_value, ")."))
      }
    }
    
    # Stop if amount of memory requested is greater than maximum permitted
    mem_count_max_value <- as.numeric(
      subset(cluster_resource_limits, type == "memory")[, "maxValue"]
    )
    
    if(!is.null(mem)) {
      if(mem > mem_count_max_value) {
        stop(paste0("'memory' requested (", mem, ") is greater than ",
                    "maximum permitted (", mem_count_max_value, ")."))
      }
    }
    
    # Define the job's resource limits
    job_cpu_count <- rstudioapi::launcherResourceLimit(
      type = "cpuCount",
      value = sprintf(
        ifelse(
          is.null(ncpus),
          as.numeric(subset(cluster_resource_limits, type == "cpuCount")[, "defaultValue"]),
          ncpus
        ),
        fmt = "%#.6f"
      )
    )
    
    job_memory <- rstudioapi::launcherResourceLimit(
      type = "memory",
      value = sprintf(
        ifelse(
          is.null(mem),
          as.numeric(subset(cluster_resource_limits, type == "memory")[, "defaultValue"]),
          mem
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
    
    return(job_id)
  }
}





