################################################################################
# Written/run on: R version 4.1.2 (2021-11-01) -- "Bird Hippie"
# Platform: x86_64-pc-linux-gnu (64-bit)
#
# Functions to write to stdout and stderr
################################################################################

### 00 write_stdout()  ----

# A function to write to stdout
write_stdout <- function(...) cat(sprintf(...), sep='', file=stdout())

### 00 write_stderr()  ----

# A function to write to stderr
write_stderr <- function(...) cat(sprintf(...), sep='', file=stderr())



