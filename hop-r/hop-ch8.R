# Ch 8 Environments
deal(deck)

# Shuffle function returns copy of deck shuffled
# It doesn't shuffle deck itself

# 8.1 Environments
install.packages("pryr")
library(pryr)
parenvs(all = TRUE)

# 8.2 Working with environments
as.environment("package:stats")

globalenv()

baseenv()

emptyenv()

parent.env(globalenv())

parent.env(emptyenv())  # Only environment without parent

ls(emptyenv())

ls(globalenv())  # Where R saves all objects created so far
ls.str(globalenv())  # Previews each object's structure

head(globalenv()$deck, 3)

assign("new", "Hello Global", envir = globalenv())

globalenv()$new

# 8.2.1 The active environment
environment()  # See current active environment

# 8.3 Scoping rules
# 1) look in current active environment
# 2) in CLI, active environment is global environment
# 3) if not found, look in parent environment, if not, then parent of parent
#    until find object or reach empty environment
# if not found in any environment, return error that object is not found

# 8.4 Assignment
new

new <- "Hello Active"
new

roll()  # Saves object named die and object named dice (temporary objects)
# How does R avoid rewriting objects with same name in active environment?

# 8.5 Evaluation
# R creates new environment (runtime) each time it evaluates a function
# Will return to environment function called from with function's result

show_env <- function(){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()  # Shows name of runtime enviro, its parent, and runtime objects
# R creates new environment each time run a function

environment(show_env)  # Displays function's origin environment
# Runtime environment becomes child of origin environment, the environment
# that the function was first created in

environment(parenvs)

show_env <- function(){
  a <- 1
  b <- 2
  c <- 3
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()  # a, b, c stored in runtime environment

# Also stores arguments
foo <- "take me to your runtime"

show_env <- function(x = foo){
  list(ran.in = environment(),
       parent = parent.env(environment()),
       objects = ls.str(environment()))
}

show_env()

# Scoping: Function called from active/calling environment
# runtime -> origin -> parent of origin -> etc. (calling might not be on path)
# Switches back to calling environment

# At any point in time R is working with a single active environment

# Exercise 8.1 (Will deal work?)
deal <- function (){
  deck[1, ]
}
# Yes, because the function's origin is global environment
# and deck is stored as an object in global environment

environment(deal)

deal()

# When deal, we need to remove the card from deck

# Save pristine copy of deck then remove top card
DECK <- deck
deck <- deck[-1, ]

deal <- function(){
  card <- deck[1, ]
  deck <- deck[-1, ]  # Won't actually overwrite global copy of deck...
  card
}

# Exercise 8.2 (Overwrite deck)
deal <- function(){
  card <- deck[1, ]
  assign("deck", deck[-1, ], envir = globalenv())
  card
}

deal()

shuffle(deck)  # Doesn't shuffle deck, returns shuffled copy of deck object
head(deck, 3)  # Copy it returns may be missing cards dealt away

a <- shuffle(deck)
head(deck, 3)
head(a, 3)

# Shuffle should return dealt cards to deck, then shuffle the deck

# Exercise 8.3 (Rewrite shuffle)
shuffle <- function(){
  random = sample(1:52, size = 52)
  assign("deck", DECK[random, ], envir = globalenv())
}
shuffle()

# 8.6 Closures
shuffle()
deal()
deal()

setup <- function(deck) {
  DECK <- deck
  
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = globalenv())
    card
  }
  
  SHUFFLE <- function() {
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = globalenv())
  }
  
  list(deal = DEAL, shuffle = SHUFFLE)
}
# Creates runtime environment to store these objects in

cards <- setup(deck)

deal <- cards$deal
shuffle <- cards$shuffle

deal
shuffle
# Origin environment is now setup runtime environment

environment(deal)
environment(shuffle)
# DECK and deck will be in function's search path but still out of the way

# Setup's runtime environment encloses the deal and shuffle functions
# Both deal and shuffle can work closely with objects in enclosing environment,
# but almost nothing else can

# Have each function reference parent environment rather than global
setup <- function(deck) {
  DECK <- deck
  
  DEAL <- function() {
    card <- deck[1, ]
    assign("deck", deck[-1, ], envir = parent.env(environment()))
    card
  }
  
  SHUFFLE <- function() {
    random <- sample(1:52, size = 52)
    assign("deck", DECK[random, ], envir = parent.env(environment()))
  }
  
  list(deal = DEAL, shuffle = SHUFFLE)
}

cards <- setup(deck)
deal <- cards$deal
shuffle <- cards$shuffle

rm(deck)
shuffle()
deal()  # Still works
