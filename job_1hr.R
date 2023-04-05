
output_path <- "//conf/RSIP/johnta02/posit-workbench-job-scheduler/job_1hour.csv"

write.table(data.frame(who = Sys.getenv("USER"), 
                       when = as.character(Sys.time())), row.names = F, 
            file = output_path, sep = ",", append = T, col.names = F)
