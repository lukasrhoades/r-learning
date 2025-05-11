# Ch 6 Workflow: scripts and projects

# Two essential tools for organizing code

# 6.1 Scripts

# New file shortcut: Cmd + Shift + N
# Script file lets you save code for later

# 6.1.1 Running code

# Script editor great for complex ggplot2 plots or long dplyr pipelines
# Cmd + Enter lets you execute current R expression in console

# Example
library(dplyr)
library(nycflights13)

not_cancelled <- flights |> 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled |> 
  group_by(year, month, day) |> 
  summarize(mean = mean(dep_delay))
# If cursor is on line with filter(), pressing Cmd + Enter will run complete command that creates not_cancelled, also moves cursor to following statement, which makes it easier to step through entire script

# Instead of going expression by expression, can also execute entire script with Cmd + Shift + S

# Always start script with packages you might need, so if you share your script people will immediately see what packages they might need to install
# Never include install.packages() in a script you share, don't pass on a script that will change something on their computer if they aren't careful

# 6.1.2 RStudio diagnostics

# RStudio will highlight syntax errors with a red squigly line and a cross in the sidebar, hover over cross to see problem
# RStudio will also let you know about potential problems with caution sign


# 6.1.3 Saving and naming

# Three important principles
# 1) File names should be machine readable: avoid spaces, symbols, and special chars, don't rely on case sensitivity to distinguish files
# 2) File names should be human readable: describe what's in the file
# 3) File names should play well with default ordering: start file names with numbers so alphabetic sorting puts them in order they get used

# Suppose have following files in project folder
# alternative model.R
# code for exploratory analysis.r
# finalreport.qmd
# FinalReport.qmd
# fig 1.png
# Figure_02.png
# model_first_try.R
# run-first.r
# temp.txt

# Multiple problems: hard to find which file to run first, file names contain spaces, two files with same name but different capitalization, some names don't describe their content

# Better way of organizing same set of files:
# 01-load-data.R
# 02-exploratory-analysis.R
# 03-model-approach-1.R
# 04-model-approach-2.R
# fig-01.png
# fig-02.png
# report-2022-03-20.qmd
# report-2022-04-02.qmd
# report-draft-notes.txt

# Numbering key scripts makes it obvious in which order to run them and consistent naming scheme makes it easier to see what varies
# Figures are labeled similarly, reports are distinguished by dates, and temp is renamed to report-draft-notes to better describe its contents
# If many files, placing different types of files (scripts, figures, etc.) in different directories is recommended

# 6.2 Projects

# 6.2.1 What is the source of truth?

# To make it easier to work on larger arguments/collaborate, source of truth should be R scripts, as with R scripts/data files you can recreate the environment
# With only your environment, its much harder to recreate R scripts, either have to retype code from memory or carefully mine R history

# To keep R scripts as source of truth for analysis, recommend instructing RStudio not to preserve workspace in between sessions, can do this by unchecking restore .RData into workspace as startup and putting save workspace on exit to never in R General Workspace settings
# This forces you to save calculations in your code, not just say the results in your environment

# 2 keyboard shortcuts to help make sure you captured the important parts of your code in the editor:
# 1) Cmd + Shift + 0 to restart R
# 2) Cmd + Shift + S to re-run current script

# 6.2.2 Where does your analysis live?

# The working directory is where R looks for files you ask it to load and where it will put any files you ask it to save, it is shown at the top of the console
# You can also print it out in code with getwd()
getwd()

# Organize your projects into directories and when working with R, set R's working directory to the associated directory
# You can set working directory from within R, but NOT recommended
# setwd()

# A better way is RStudio project

# 6.2.3 RStudio projects

# Keeping all files associated with given project (input data, R scripts, analytical results, figures) together in one directory is so common practice it is built in to RStudio
# Can make a project by clicking File > New Project

# Check that the "home" of project is the current working directory
getwd()

# See diamonds.R

# Double click the .Rproj file in your project directory to re-open the project
# You get the same working directory and command history, all the files you were working on are still open
# But, you will have a completely fresh environment, guaranteeing you start with a clean state

# Now in ch6 folder is diamonds.png but also the file that created it, diamonds.R
# By saving figures to files with R code and not mouse/clipboard, you are able to reproduce old work easily

# 6.2.4 Relative and absolute paths

# Once inside a project, only ever use relative paths 
# Relative paths are relative to working directory, the project's home
# ch6/data/diamonds.csv is short for /Users/lukas/r-learning/r4ds/ch6/data/diamonds.csv
# But if someone else runs ch6/data/diamonds.csv it can be short for Users/someone-else/Documents/r4ds/ch6/data/diamonds.csv
# Relative paths work regardless of where the R project folder ends up

# Absolute paths point to same place regardless of working directory, on mac they start with "/", like /Users/lukas
# Never use absolute paths in scripts, they hinder sharing since nobody has the same directory configuration as you

# Recommend always using Mac/Linux style of filepaths with "/" since "\" means something special to R and you need to type "\\" to get a single one in the filepath

# 6.3 Exercises

# 1. Use a tip from https://twitter.com/rstudiotips

# Can turn the environment into a grid by clicking "List" dropdown at top right of environment pane, allows you to select multiple objects and see the size of each object, helps free up space

# 2. What other common mistakes will RStudio diagnostics report? Find out by reading https://support.posit.co/hc/en-us/articles/205753617-Code-Diagnostics

# Diagnoses missing arguments in function calls, if a symbol is used with no definition, when a variable is defined but not used, style warnings (inapproprait euse/or lack thereof of whitespace)