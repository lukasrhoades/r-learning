# Ch 9 Programs

# Play function will do two things

# First, randomly generate three slot machine symbols
get_symbols <- function() {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  sample(wheel, size = 3, replace = TRUE,
         prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
}
get_symbols()

# Win if get 3 of same symbol (except zeroes), three bars (of mixed variety),
# or one or more cherries
# Diamonds are like wild cards, can be anything to improve prize except
# can't be a cherry if not already one
# Every diamond doubles prize, 3 diamonds is jackpot

# 9.1 Strategy

# 9.1.1 Sequential steps
play <- function() {
  # Step 1: generate symbols
  symbols <- get_symbols()
  
  # Step 2: display symbols
  print(symbols)
  
  # Step 3: score symbols
  score(symbols)
}

# 9.1.2 Parallel cases

# Calculate prize differently if 3 of kind (look up prize),
# all bars (assign $5), or count cherries, then adjust for diamonds

# 9.2 if statements
num <- -2

if (num < 0 ) {
  num <- num * -1
}  # Ensures number is positive

num  # 2

# Logical test cannot be multiple T/F, can condense w/ any and all

num <- -1

if (num < 0 ) {
  print("num is negative.")
  print("Don't worry, I'll fix it.")
  num <- num * -1
  print("Now num is positive.")
}

num  # 1

# Exercise 9.1 (Quiz A)
x <- 1
if (3 == 3) {
  x <- 2
}
x  # Will be 2, since 3 == 3 returns True

# Exercise 9.2 (Quiz B)
x <- 1
if (TRUE) {
  x <- 2
}
x  # Also 2

# Exercise 9.3 (Quiz C)
x <- 1
if (x == 1) {
  x <- 2
  if (x == 1) {
    x <- 3
  }
}
x  # Will be 2, since second if statement will be False

# 9.3 else statements
a <- 3.14

dec <- a - trunc(a)  # Trunc returns only what is left of decimal
dec

if (dec >= 0.5) {
  a <- trunc(a) + 1
} else {
  a <- trunc(a)
}

a  # 3

a <- 1
b <- 1

if (a > b) {
  print("A wins!")
} else if (a < b) {
  print("B wins!")
} else {
  print("Tie.")
}  # Tie

# Exercise 9.4 (Write a test)
symbols <- c("7", "7", "7")
all(symbols == symbols[1]) # Test for three of a kind
# Other solutions
symbols[1] == symbols[2] & symbols[2] == symbols[3]
symbols[1] == symbols[2] & symbols[1] == symbols[3]
length(unique(symbols) == 1)

same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
# && won't evaluate second test if first makes result clear (False)
# but it isn't vectorized, only handle one test on either side

symbols <- c("B", "BBB", "BB")
# Exercise 9.5 (Test for all bars)
# One solution
is_bar <- function(i) {
  symbols[i] == "B" || symbols[i] == "BBB" || symbols[i] == "BB"
}
test <- all(is_bar(1), is_bar(2), is_bar(3))
test
# Another
bars <- all(symbols %in% c("B", "BB", "BBB"))

# 9.4 Lookup tables
payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
             "B" = 10, "C" = 10, "0" = 0)
# Stores symbols as names and prizes as elements
payouts

payouts["DD"]  # 100
payouts["B"]  # 10

unname(payouts["DD"])  # Returns copy with name attribute removed

symbols <- c("7", "7", "7")
symbols[1]  # "7"
payouts[symbols[1]]  # 80

symbols <- c("C", "C", "C")
payouts[symbols[1]]  # 10

# Exercise 9.6 (Find C's)
symbols <- c("C", "DD", "C")
sum(symbols == "C")  # Sum of mask
sum(symbols == "DD")  # 1

cherries <- sum(symbols == "C")
c(0, 2, 5)[cherries + 1]  # When cherries is 0, prize is 0
# When cherries is 1, prize is 2, when 2 cherries prize is 5
# Case with 3 cherries is already covered by case 1

# Use if tree if each branch runs different code,
# use lookup table if each branch only assigns a different value

# Last task is to double prize for each diamond
# This means if 3 diamonds are present, multiply prize 8x (2 ^ 3)

# Exercise 9.7 (Adjust for diamonds)
prize * 2 ^ diamonds  # If no diamonds, prize is same

# Now we can play slot machine!
play()