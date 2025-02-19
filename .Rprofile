source("renv/activate.R")

renv::settings$use.cache(FALSE)

renv::restore(packages = c("parallelly"), prompt = FALSE)
available_cores <- as.numeric(parallelly::availableCores())
options(Ncpus = available_cores)
Sys.setenv(MAKEFLAGS = paste("-j", as.character(available_cores), sep = ""))

# Run posit-workbench-job-scheduler
#source("code/99_Run.R")
