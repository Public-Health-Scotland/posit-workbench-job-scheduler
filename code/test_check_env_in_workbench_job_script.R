################################################################################
# Name of file:       test_check_env_in_workbench_job.R
# Type of script:     R
#
# Original author:    Terry McLaughlin
#
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Simple script to run in Workbench Job as part of test of function to
# programmatically launch workbench jobs on the Kubernetes cluster.
################################################################################

sys_getenv <- Sys.getenv()

file_out <- paste0(sys_getenv[['HOSTNAME']], ".out")

cat(paste("HOME", sys_getenv['HOME'], sep = "\t"), file = file_out, sep = "\n")
cat(paste("HOSTNAME", sys_getenv['HOSTNAME'], sep = "\t"), file = file_out, sep = "\n", append = TRUE)
cat(paste("LD_LIBRARY_PATH", sys_getenv['LD_LIBRARY_PATH'], sep = "\t"), file = file_out, sep = "\n", append = TRUE)
cat(paste("PATH", sys_getenv['PATH'], sep = "\t"), file = file_out, sep = "\n", append = TRUE)
cat(paste("R_HOME", sys_getenv['R_HOME'], sep = "\t"), file = file_out, sep = "\n", append = TRUE)
cat(paste("R_LIBS_USER", sys_getenv['R_LIBS_USER'], sep = "\t"), file = file_out, sep = "\n", append = TRUE)
