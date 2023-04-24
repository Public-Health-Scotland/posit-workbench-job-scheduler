################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically launch workbench jobs on the Kubernetes
# cluster.
################################################################################

### 00 Launch Workbench Job ----

#### 00 Test Argument Handling - job_name ----

job_id <- launch_workbench_job(job_name = 1,
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = c("a", "b"),
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

#### 01 Test Argument Handling - project_path ----

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = 1,
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path =  c("a", "b"),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = "/path/that/does_not/exist",
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

#### 02 Test Argument Handling - script ----

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = 1,
                               n_cpu = 0.25,
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = c("a", "b"),
                               n_cpu = 0.25,
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "path/that/does_not/exist/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

#### 03 Test Argument Handling - n_cpu ----

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = c(0.25, 0.5),
                               n_ram = 128)

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = "0.25",
                               n_ram = 128)

#### 04 Test Argument Handling - n_ram ----

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = c(128, 256))

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = "128")

#### 05 Actually launch a workbench job ----

job_id <- launch_workbench_job(job_name = "Test Workbench Job",
                               project_path = here::here(),
                               script = "code/test_launch_workbench_job_script.R",
                               n_cpu = 0.25,
                               n_ram = 128)

Sys.sleep(3)

rstudioapi::launcherGetJob(job_id)
