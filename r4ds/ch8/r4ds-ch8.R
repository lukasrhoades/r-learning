# Ch 8 Workflow: getting help

# 8.1 Google is your friend

# Include [R] in your StackOverflow search

# 8.2 Making a reprex

# If googling doesn't yield anything useful, good idea to prepare a reprex, short for a minimal reproducible example, makes it easier for other people to help you and you can often solve the problem in the course of making it
# First, make code reproducible, capture anything including library() calls, and create all necessary objects, easiest way to do this is use reprex package
# Second, make it minimal, strip away anything not related to problem, usually involves creating smaller and simpler R object than one working with

# 80% of time creating excellent reprex is source of problem
# Other 20% of time, capture essence of problem in way that's easy for others to play with, improves chances of getting help

# reprex package is part of tidyverse, otherwise doing by hand it's easy to accidentally miss something

# Copy this code
y <- 1:4
mean(y)

# Then call reprex where default output is formatted for GitHub
reprex::reprex()

# Nicely rendered html will appear in RStudio's Viewer tab, also automatically copied to clipboard

# Text is formatted in Markdown, so can be pasted to StackOverflow or GitHub and automatically renders it like code

# 3 things need to do to make sure example is reproducible: required packages, data, and code
# 1) Packages need to be loaded at top of script, also a good time to check if you are using latest version of each package
# In tidyverse, easiest way is to run tidyverse_update()
# 2) Easiest way to include data is dput() to generate the R code needed to recreate it
# For example to recreate the mtcars dataset in R, perform the following steps:
# a) Run dput(mtcars) in R
# b) Copy the output
# c) In reprex, type mtcars <-, then paste
# Try using the smallest subset of data that still reveals the problem
# 3) Spend some time to make sure code is easy for others to read
# Use spaces, variable names are concise yet informative
# Use comments to indicate where problem lies
# Do best to remove everything not related to problem
# Shorter the code, easier it is to understand, easier it is to fix
# Check it is reproducible by starting fresh R session and copy paste the script

# 8.3 Investing in yourself

# https://www.tidyverse.org/blog/
# https://rweekly.org





  
