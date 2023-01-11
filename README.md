# posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that contains functions to assist with programmatically launching Workbench Jobs on the Kubernetes cluster, and scheduling these to run at a specific time and/or at regular intervals:

* `launch_workbench_job()` launches a Workbench Job on the Kubernetes cluster
* `schedule_workbench_job()` schedules a Workbench Job to launch on the Kubernetes cluster at a specific time and/or at regular intervals
* `cancel_workbench_job_schedule()` cancels a schedule created by the function `schedule_workbench_job()`

## Installation

`posit-workbench-job-scheduler` is not an R package, and does not require installation.  Instead, clone this repository to a directory accessible from Posit Workbench. :memo: _Write instructions on how to clone repo_

## Using posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that should be opened in a Posit Workbench session on the Kubernetes cluster.  This session needs to run continuously in the background for Workbench Jobs to be launched on the Kubernetes cluster at the right time, therefore the smaller this session, the better in terms of reducing load on the Kubernetes cluster.  I would highly recommend selecting x CPUs and y memory for this session.

### Starting the scheduler

:memo: _Write a run.R script and documentation for starting the scheduler._

### Launch a Workbench Job immediately

The function `launch_workbench_job()` immediately launches a Workbench Job on the Kubernetes cluster.

:memo: _Need to write more / better checking of arguments supplied to this function_

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

**job_name**
  Some text

**project_path**
  Some text

**script**
  Some text

**n_cpu**
  Some text

**n_ram**
  Some text

#### Examples

### Scheduling a Workbench Job

The function `schedule_workbench_job()` schedules a Workbench Job to launch on the Kubernetes cluster at a specific time and/or at regular intervals.



#### One-time only at a specific time



#### At a specific time and at regular intervals thereafter


### Cancelling a scheduled Workbench Job

A specific scheduled Workbench Job cannot be cancelled.  Instead, please refer to [cancelling a schedule](#cancelling-a-schedule)

### Cancelling a schedule

The function `cancel_workbench_job_schedule()` cancels a schedule created by the function `schedule_workbench_job()`.
