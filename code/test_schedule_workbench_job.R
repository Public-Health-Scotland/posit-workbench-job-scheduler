################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Test of function to programmatically schedule workbench jobs on the Kubernetes
# cluster.
################################################################################

### 00 Schedule Workbench Job ----

#### 00 Test Argument Handling - job_name ----

schedule_workbench_job(
  job_name = 1,
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = c("a", "b"),
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 01 Test Argument Handling - schedule_name ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = 1,
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = c("a", "b"),
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 02 Test Argument Handling - due ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = c(lubridate::now(), lubridate::now() + lubridate::minutes(1)),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = "20th November 2023 at 14:03",
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() - lubridate::days(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 03 Test Argument Handling - rpt ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = c(as.numeric(lubridate::as.duration("5 minutes")),
          as.numeric(lubridate::as.duration("10 minutes"))),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = "5 minutes",
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 04 Test Argument Handling - project_path ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = 1,
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = c(here::here(), here::here()),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = "/path/that/does_not/exist",
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 05 Test Argument Handling - script ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = 1,
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = c("code/test_launch_workbench_job_script.R",
             "code/test_launch_workbench_job_script_2.R"),
  n_cpu = 0.25,
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "path/that/does_not/exist/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

#### 06 Test Argument Handling - n_cpu ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = "0.25",
  n_ram = 128
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = c(0.25, 0.5),
  n_ram = 128
)

#### 07 Test Argument Handling - n_ram ----

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = "128"
)

schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = c(128, 256)
)

#### 05 Actually schedule a workbench job ----

# Schedule a workbench job
schedule_workbench_job(
  job_name = "Test Workbench Job",
  schedule_name = "test_workbench_job_schedule",
  due = lubridate::now() + lubridate::minutes(1),
  rpt = as.numeric(lubridate::as.duration("5 minutes")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)
