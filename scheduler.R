
# quick function to print out useful job info
show_job_info <- function(job_id){
  job_info <- rstudioapi::launcherGetJob(job_id)
  
  c(user = job_info$user, 
    job_name = job_info$name,
    submitted = format(as.POSIXct(job_info$submissionTime, format = "%Y-%m-%dT%H:%M:%S"), "%Y%m%d_%H:%M:%S"),
    last_updated = format(as.POSIXct(job_info$lastUpdateTime, format = "%Y-%m-%dT%H:%M:%S"), "%Y%m%d_%H:%M:%S"),
    status = job_info$status,
    exit_code = job_info$exitCode)
  
}

# function to easily specify next time to run
next_weekdaytime <- function(day, time){
  # e.g. next_weekdaytime("Tuesday", "05:00:00") will return the first upcoming POSIXct datetime
  dates <- seq.Date(from = Sys.Date(), to = Sys.Date() + 7, by = "day") 
  possible_dates <- dates[weekdays(dates) == day]
  possible_datetimes <- paste(possible_dates, time) |> as.POSIXct()
  next_available_datetime <- possible_datetimes[possible_datetimes > Sys.time()][[1]]
  return(next_available_datetime)
}

# job_id <- launch_workbench_job(job_name = "test",
#                                  project_path = here::here(),
#                                  script = "job_1hr.R",
#                                  n_cpu = 0.5,
#                                  n_ram = 1024)
# show_job_info(job_id)


# 1 hour test ####
# scheduling test
job_sched_1hr <- schedule_workbench_job(schedule_name = "sched_test_1hr",
                                      # due = now() + seconds(10),
                                      due = next_weekdaytime("Wednesday", "13:00:00"),
                                      rpt = (60*60*1),
                                      job_name = "sched_job_1hr",
                                      project_path = here::here(),
                                      script = "job_1hr.R",
                                      n_cpu = 0.5,
                                      n_ram = 1024)

# cancel_workbench_job_schedule(schedule_name = "sched_test_1hr")


# 3 hour test ####
# scheduling test
job_sched_3hr <- schedule_workbench_job(schedule_name = "sched_test_3hr",
                                        # due = now() + seconds(10),
                                        due = next_weekdaytime("Wednesday", "13:00:00"),
                                        rpt = (60*60*1),
                                        job_name = "sched_job_3hr",
                                        project_path = here::here(),
                                        script = "job_3hr.R",
                                        n_cpu = 0.5,
                                        n_ram = 1024)

# cancel_workbench_job_schedule(schedule_name = "sched_test_3hr")
