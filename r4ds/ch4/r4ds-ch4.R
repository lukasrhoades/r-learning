# Ch 4 Workflow: code style

install.packages("styler")

# To use, Cmd + Shift + P to see all shortcuts for styler

library(tidyverse)
library(nycflights13)

# 4.1 Names

# Strive for:
short_flights <- flights |> filter(air_time < 60)

# Avoid:
SHORTFLIGHTS <- flights |> filter(air_time < 60)

# Long, descriptive names > concise, since you can use autocomplete
# Use common prefix for similar variables so you can see the autocomplete options

# 4.2 Spaces

# Put on either side of math operators besides ^ and around the assignment operator (<-)
# Strive for:
z <- (a + b)^2 / d
# Avoid:
z<-( a + b ) ^ 2/d

# Don't put spaces inside or outside parenthesis for regular function calls, always put space after comma
# Strive for:
mean(x, na.rm = TRUE)
# Avoid:
mean (x ,na.rm=TRUE)

# Okay to use extra space for alignment, for example to make = line up
flights |> 
  mutate(
    speed      = distance / air_time,
    dep_hour   = dep_time %/% 100,  # Get hour with integer division
    dep_minute = dep_time %% 100  # Get minutes with remainder
  ) |> 
  
# 4.3 Pipes

# |> should always have a space before it and should typically be last thing on the line, makes it easier to add/rearrange steps, modify within, skim big picture from looking at verbs on the left
# Strive for:
flights |> 
  filter(!is.na(arr_delay), !is.na(tailnum)) |> 
  count(dest)
# Avoid:
flights|>filter(!is.na(arr_delay), !is.na(tailnum))|>count(dest)

# If function pipe into has named arguments (like mutate() or summarize()), put each argument on a new line
# If function doesn't (like select() or filter()), keep everything on one line unless it doesn't fit, then put each argument on a new line
# Strive for:
flights |> 
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
# Avoid:
flights |> 
  group_by(
    tailnum
  ) |> 
  summarize(delay = mean(arr_delay, na.rm = TRUE), n = n())

# After first step of pipeline indent each line by two spaces, make sure each argument is indented if on own line, and closing ) should be on its own line, and un-indented to match horizontal position of function name
# Strive for:
flights |> 
  group_by(tailnum) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    n = n()
  )
# Avoid:
flights |> 
  group_by(tailnum) |> 
  summarize(
  delay = mean(arr_delay, na.rm = TRUE),
  n = n()
  )

# Fine to shirk rules if pipeline easily fits on one line, but easier to expand if start right from the get-go
# This fits completely on one line
df |> mutate(y = x + 1)
# While this takes up 4x as many lines, easier to extend to more variables and more steps in the future
df |> 
  mutate(
    y = x + 1
  )

# Be wary of pipes > 10-15 lines, try breaking up into smaller, informatively-named tasks, helps cue reader and easier to check intermediate results are as expected
# When you can, give an informative name, such as after changing structure of data (e.g., pivoting or summarizing)

# 4.4 ggplot2

# Same rules for |>  apply to +
flights |> 
  group_by(month) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = month, y = delay)) +
  geom_point() + 
  geom_line()

# If can't fit all arguments on one line, put each on its own
flights |> 
  group_by(dest) |> 
  summarize(
    distance = mean(distance),
    speed = mean(distance / air_time, na.rm = TRUE)
  ) |> 
  ggplot(aes(x = distance, y = speed)) +
  geom_smooth(
    method = "loess",
    span = 0.5,
    se = FALSE,
    color = "white",
    linewidth = 4
  ) +
  geom_point()
# Watch for transition from |> to +

# 4.5 Sectioning comments

# Can use sectioning comments to break up file into manageable pieces

# Use Cmd + Shift + R to make these

# Load data ---------------------------------------------------------------


# Plot data ---------------------------------------------------------------

# Can navigate these in bottom-left of editor

# 4.6 Exercises

# 1. Restyle following pipelines following the guidelines above
flights|>filter(dest=="IAH")|>group_by(year,month,day)|>summarize(n=n(),
delay=mean(arr_delay,na.rm=TRUE))|>filter(n>10)

flights|>filter(carrier=="UA",dest%in%c("IAH","HOU"),sched_dep_time>
0900,sched_arr_time<2000)|>group_by(flight)|>summarize(delay=mean(
arr_delay,na.rm=TRUE),cancelled=sum(is.na(arr_delay)),n=n())|>filter(n>10)

# First pipeline
flights |> 
  filter(dest == "IAH") |> 
  group_by(year, month, day) |> 
  summarize(
    n = n(),
    delay = mean(arr_delay, na.rm = TRUE)
  ) |> 
  filter(n > 10)

# Second pipeline
flights |> 
  filter(
    carrier == "UA",
    dest %in% c("IAH", "HOU"),
    sched_dep_time > 0900,
    sched_arr_time < 2000
  ) |> 
  group_by(flight) |> 
  summarize(
    delay = mean(arr_delay, na.rm = TRUE),
    cancelled = sum(is.na(arr_delay)),
    n = n()
  ) |> 
  filter(n > 10)

