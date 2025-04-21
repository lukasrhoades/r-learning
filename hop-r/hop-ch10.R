# Ch 10 S3

# Currently play() displays less pretty format and you can't save the symbols

# 10.1 The S3 system
num <- 1000000000
print(num)

class(num) <- c("POSIXct", "POSIXt")
print(num)  # Now displays a time

# 10.2 Attributes
attributes(deck)

row.names(deck)  # Retrieves attribute value

row.names(deck) <- 101:152  # Changes attribute value

levels(deck) <- c("level 1", "level 2", "level 3")  # Gives object new attribute
attributes(deck)

one_play <- play()
one_play
attributes(one_play)  # NULL

# Give one_play an attribute
attr(one_play, "symbols") <- c("B", "B", "BB")
attributes(one_play)

# Lookup value of attribute
attr(one_play, "symbols")

one_play

one_play + 1  # Attribute is ignored

# Exercise 10.1 (Add an attribute)
# Instead of printing symbols, add as an attribute
play <- function() {
  symbols <- get_symbols()
  prize <- score(symbols)
  attr(prize, "symbols") <- symbols
  prize
}

# Now symbols follow prize if copy it to a new object, not pretty output though
play()

two_play <- play()
two_play

# Can generate prize and set attributes in one step with structure function
play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols = symbols)
}

three_play <- play()
three_play

# Now extract symbols attribute to display slot results
slot_display <- function(prize) {
  # Extract symbols
  symbols <- attr(prize, "symbols")
  
  # Collapse symbols into single string
  symbols <- paste(symbols, collapse = " ")
  
  # Combine symbol with prize as character string
  # \n escape sequence for new line
  string <- paste(symbols, prize, sep = "\n$")
  
  # Display string in console without quotes
  cat(string)
}

slot_display(one_play)

# Break down the function
symbols <- attr(one_play, "symbols")
symbols

# Paste collapses three strings in symbols into single string when
# you give it the collapse argument, uses collapse value to separate
symbols <- paste(symbols, collapse = " ")
symbols

# Now use paste to combine symbols with prize
prize <- one_play
string <- paste(symbols, prize, sep = "\n$")
string  # "B B BB\n$5"

# Cat is like print, but doesn't surround output with quotation marks
# and also replaces \n with a new line
cat(string)

slot_display(play())  # Cleans output of play
# Must manually call slot_display, but print function can automatically
# clean the output each time it is displayed

# 10.3 Generic functions
print(pi)
pi  # Same thing, because print is being called in the background

print(head(deck))
head(deck)

print(play())
play()

# Print is generic function, written in a way to do different things
# in different cases
# Already saw this with giving num POSIX classes and then printing

# 10.4 Methods
print

# UseMethod examines class of input of first argument in print
# then pass all arguments to a new function to handle that class
print.POSIXct

print.factor

# These are methods of print, print uses specialized method depending on class

methods(print)

# Can use S3 to format slot output by giving output a class
# then writing a print method for that class

# 10.4.1 Method dispatch
# Every S3 method has two-part name, function.class

class(one_play) <- "slots"  # Give one_play its own class

# Print S3 method should take same arguments as print
args(print)

print.slots <- function(x, ...) {
  cat("I'm using the print.slots method")
}

print(one_play)
one_play  # Same results

rm(print.slots)

now <- Sys.time()
attributes(now)  # Has two classes
# UseMethod will first look for first class, if can't find, then second, etc.

# If give print an object whose classes have no print method,
# UseMethod will call print.default, which handles generic cases

# Exercise 10.2 (Make a print method)
print.slots <- function(x, ...) {
  slot_display(x)
}

print(one_play)  # Now print cleans it automatically

# Exercise 10.3 (Add a class)
play <- function() {
  symbols <- get_symbols()
  structure(score(symbols), symbols = symbols, class = "slots")
}

# Now each slot machine play will have class slots
class(play())

play()  # And they will be displayed in the correct slot format

# 10.5 Classes
methods(class = "factor")  # Shows methods for factor class

play1 <- play()
play1

play2 <- play()
play2
# Both work fine

c(play1, play2)  # R drops attributes when combines objects into vector
# Stops using print.slots since vector doesn't have "slots" class attribute

play1[1]  # Also drops attributes when subset

# Can avoid this by writing c.slots and [.slots method, but difficulties
# would quickly accrue
# How would you combine symbols attributes of multiple plays into
# a vector of symbols attributes
# Or change print.slots to handle a vector of output

# For our case, handy to let slots objects revert to prize values when
# combine groups of them into a single vector

