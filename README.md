# posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that contains functions to assist with programmatically launching Workbench Jobs on a Kubernetes cluster, and scheduling these to run at a specific time and/or at regular intervals:

* `launch_workbench_job()` launches a Workbench Job on the default Kubernetes cluster
* `schedule_workbench_job()` schedules a Workbench Job to launch on the default Kubernetes cluster at a specific time and/or at regular intervals
* `cancel_workbench_job_schedule()` cancels a schedule created by the function `schedule_workbench_job()`

## Installation

`posit-workbench-job-scheduler` is not an R package, and does not require installation.  Instead, this repository should be cloned to a directory accessible from Posit Workbench.

## Using posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that should be opened in a Posit Workbench session.  This session needs to run continuously in the background for Workbench Jobs to be launched on a Kubernetes cluster at the right time.

It is recommended that `posit-workbench-job-scheduler` should be run in a session with 0.25 CPUs and 256 MiB of memory; this should comfortably handle 10+ individual schedules.

### Starting the scheduler

`posit-workbench-job-scheduler` will automatically start running when the project is opened in a new Posit Workbench session.  Confirmation will be provided by the following message on the Console:

```
✔ Posit Workbench Job Scheduler is running
ℹ Please ensure that you do not quit this Posit Workbench session!
```

### Launch a Workbench Job immediately

The function `launch_workbench_job()` immediately launches a Workbench Job on the default Kubernetes cluster.

#### Usage

```R
launch_workbench_job(
  job_name,
  project_path,
  script,
  n_cpu,
  n_ram
)
```

#### Arguments

##### job_name

A descriptive name to assign to the Workbench Job.  Default is the filename of `script`.

##### project_path

The full file path to the root directory of the project that `script` should be run in e.g. `/path/to/project/`.

##### script

A file path to the R script to be run by the Workbench Job, relative to `project path` e.g. `code/script.R`.

##### n_cpu

The number of CPUs to request for the Workbench Job e.g. `1.0`.  Default is the default number of CPUs for a session as defined in the Kubernetes cluster.

##### n_ram

The amount of memory (RAM) in MiB to request for the Workbench Job e.g. `4096`. Default is the default amount of memory for a session as defined in the Kubernetes cluster.

#### Examples

```R
job_id <- launch_workbench_job(
  job_name = "A name for this job",
  project_path = here::here(),
  script = "code/script.R",
  n_cpu = 0.25,
  n_ram = 128
)

✔ A Workbench Job with id 'S3ViZXJuZXRlczp0ZXN0LXdvcmtiZW5jaC1qb2ItZnhzOWg=' and name 'A name for this job' has been
  launched on the cluster 'Kubernetes'.
```

### Scheduling a Workbench Job

The function `schedule_workbench_job()` schedules a Workbench Job to launch on the default Kubernetes cluster at a specific time and/or at regular intervals.

#### Usage

```R
schedule_workbench_job(
  job_name,
  schedule_name,
  due,
  rpt,
  project_path,
  script,
  n_cpu,
  n_ram
)
```

#### Arguments

##### job_name

A descriptive name to assign to the Workbench Job.  Default is the filename of `script`.

##### schedule_name

A name, conforming to R variable naming conventions, of the event loop to schedule the Workbench Job on.  If the event loop does not already exist, it will be created.

##### due

The date and time (as a POSIXct object) to run the Workbench Job.

##### rpt

Run the Workbench Job every `rpt` seconds after the first scheduled run.  For example, to run once every day, this value should be 86,400 seconds.  Defaults to NULL and the Workbench Job will only be run once at the date and time specified in `due`.

##### project_path

The full file path to the root directory of the project that `script` should be run in e.g. `/path/to/project/`.

##### script

A file path to the R script to be run by the Workbench Job, relative to `project path` e.g. `code/script.R`.

##### n_cpu

The number of CPUs to request for the Workbench Job e.g. `1.0`.  Default is the default number of CPUs for a session as defined in the Kubernetes cluster.

##### n_ram

The amount of memory (RAM) in MiB to request for the Workbench Job e.g. `4096`. Default is the default amount of memory for a session as defined in the Kubernetes cluster.

#### Examples

```R
schedule_workbench_job(
  job_name = "job_name_1",
  schedule_name = "schedule_1",
  due = lubridate::now() + lubridate::seconds(10),
  rpt = as.numeric(lubridate::as.duration("3 days")),
  project_path = here::here(),
  script = "code/test_launch_workbench_job_script.R",
  n_cpu = 0.25,
  n_ram = 128
)

ℹ The schedule 'schedule_1' will submit a Workbench Job with the name 'job_name_1' to be launched on Friday 13 January
  2023 at 12:37:33.
✔ A Workbench Job with id 'S3ViZXJuZXRlczpqb2ItbmFtZS0xLXg4bW1j' and name 'job_name_1' has been launched on the cluster
  'Kubernetes'.
ℹ The schedule 'schedule_1' will submit a Workbench Job with the name 'job_name_1' to be launched on Monday 16 January
  2023 at 12:37:33.
```

### Cancelling a scheduled Workbench Job

A specific scheduled Workbench Job cannot be cancelled.  Instead, please refer to [cancelling a schedule](#cancelling-a-schedule)

### Cancelling a schedule

The function `cancel_workbench_job_schedule()` cancels a schedule created by the function `schedule_workbench_job()`.
