# posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that contains functions to assist with programmatically launching Workbench Jobs on the Kubernetes cluster, and scheduling these to run at a specific time and/or at regular intervals:

* `launch_workbench_job()` launches a Workbench Job on the Kubernetes cluster
* `schedule_workbench_job()` schedules a Workbench Job to launch on the Kubernetes cluster at a specific time and/or at regular intervals
* `cancel_workbench_job_schedule()` cancels a schedule created by the function `schedule_workbench_job()`

## Installation

`posit-workbench-job-scheduler` is not an R package, and does not require installation.  Instead, clone this repository to a directory accessible from Posit Workbench. :memo: _Write instructions on how to clone repo_

## Using posit-workbench-job-scheduler

`posit-workbench-job-scheduler` is a standalone R project that should be opened in a Posit Workbench session on the Kubernetes cluster.  This session needs to run continuously in the background for Workbench Jobs to be launched on the Kubernetes cluster at the right time, therefore the smaller this session, the better in terms of reducing load on the Kubernetes cluster.  I would highly recommend selecting x CPUs and y memory for this session.

:memo: _Write a run.R script and documentation for starting the scheduler._

