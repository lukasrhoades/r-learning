# Ch 11 Loops

# 11.1 Expected values

# To calculate expected value, list all possible outcomes,
# determine value of each outcome, calculate probability of outcome
# Then sum values times their probability

# 11.2 expand.grid
# Writes out every combo of elements in n vectors
rolls <- expand.grid(die, die)
rolls
# Returns data frame containing every way to pair element from first die
# vector with element from second die vector (36 combinations)

rolls$value <- rolls$Var1 + rolls$Var2
head(rolls, 3)

# Lookup table for probabilities of rolling values in Var1
prob <- c("1" = 1/8, "2" = 1/8, "3" = 1/8, "4" = 1/8, "5" = 1/8, "6" = 3/8)
prob

rolls$Var1
prob[rolls$Var1]  # Vector of probabilities keyed to first roll

rolls$prob1 <- prob[rolls$Var1]
head(rolls, 3)

rolls$prob2 <- prob[rolls$Var2]  # Probabilities of rolling values in Var2
head(rolls, 3)

# Calculate probability of rolling each combination
rolls$prob <- rolls$prob1 * rolls$prob2
head(rolls, 3)

# Now can calculate expected value
sum(rolls$value * rolls$prob)

# Exercise 11.1 (List the combinations)
wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
combos <- expand.grid(wheel, wheel, wheel, stringsAsFactors = FALSE)
combos

# Exercise 11.2 (Make a lookup table)
get_symbols  # Use probabilities from get_symbols function
prob <- c("DD" = 0.03, "7" = 0.03, "BBB" = 0.06, "BB" = 0.1,
         "B" = 0.25, "C" = 0.01, "0" = 0.52)

# Exercise 11.3 (Lookup the probabilities)
combos$prob1 <- prob[combos$Var1]
combos$prob2 <- prob[combos$Var2]
combos$prob3 <- prob[combos$Var3]

head(combos, 3)

# Exercise 11.4 (Calculate probabilities for each combination)
combos$prob <- combos$prob1 * combos$prob2 * combos$prob3
head(combos, 3)
sum(combos$prob)  # Should be 1

# Now need to determine prize for each combination in combos
symbols <- c(combos[1, 1], combos[1, 2], combos[1, 3])
score(symbols)  # Calculate or first row

# 11.3 for loops
for (value in that) {
  this
}

for (value in c("My", "first", "for", "loop")) {
  print("one run")
}  # prints "one run" 4x

for (value in c("My", "second", "for", "loop")) {
  print(value)
} 
value  # Contains value of last element in set, "loop"

# Can choose whatever symbol
for (word in c("My", "second", "for", "loop")) {
  print(word)
}
# Be careful naming symbol, will overwrite existing objects

# for loops in R run on sets, not integers, 
# can recreate by running on a set of integers

# for loops themselves don't return anything
for (value in c("My", "third", "for", "loop")) {
  value
}  # Outputs nothing

chars <- vector(length = 4)  # Creates empty vector of length 4
words <- c("My", "fourth", "for", "loop")

for (i in 1:4) {
  chars[i] <- words[i]
}  # Saves own output as it runs by adding to chars vector

chars  # Contains the output from the entire loop

combos$prize <- NA  # Create empty column for prizes
head(combos, 3)

# Exercise 11.5 (Build a loop)
for (i in 1:nrow(combos)) {
  symbols <- c(combos$Var1[i], combos$Var2[i], combos$Var3[i])
  combos$prize[i] <- score(symbols)
}
# Alternatively
# symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
head(combos, 3)

# Now can calculate expected value, which is
# sum of prizes weighted by their probability
sum(combos$prize * combos$prob)  # ~0.54

# Only pays 54 cents on dollar in the long run!!
# But ignored that diamonds are wild card...
# When factor that in, 93 cents, 1 cent higher than manufacturer claim

# Exercise 11.6 (Challenge)

# My attempt
score <- function (symbols) {
  # Identify case
  # Account for diamond wild card
  wild_card_1 <- symbols[1] == symbols[2] && symbols[3] == "DD"
  wild_card_2 <- symbols[2] == symbols[3] && symbols[1] == "DD"
  wild_card_3 <- symbols[1] == symbols[3] && symbols[2] == "DD"
  wild_card_4 <- symbols[1] == "DD" && symbols[2] == "DD"
  wild_card_5 <- symbols[1] == "DD" && symbols[3] == "DD"
  wild_card_6 <- symbols[2] == "DD" && symbols[3] == "DD"
  wild_card <- c(wild_card_1, wild_card_2, wild_card_3,
                 wild_card_4, wild_card_5, wild_card_6)
  
  # Check if all are same
  if (symbols[1] == symbols[2] && symbols[2] == symbols[3]) {
    same <- TRUE
  } else if (any(wild_card)) {
    same <- TRUE
    if (wild_card_2) {
      symbols[1] = symbols[2]  # So correct prize is assigned
      symbols[2] = "DD"  # So prize is still doubled
    }
    if (wild_card_4) {
      symbols[1] = symbols[3]
      symbols[3] = "DD"
    }
    if (wild_card_5) {
      symbols[1] = symbols[2]
      symbols[2] = "DD"
    }
  }
  else {
    same <- FALSE
  }
  
  # Check if all are bars (or diamonds)
  bars <- symbols %in% c("B", "BB", "BBB", "DD")
  
  # Get prize
  if (same) {  # All symbols are same
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])  # Look up prize
  } else if (all(bars)) {  # All bars
    prize <- 5  # Assign $5
  } else {
    cherries <- sum(symbols == "C")  # Count cherries
    if (cherries > 0) {  # Add diamond wild card
      cherries <- cherries + sum(symbols == "DD")
    }
    prize <- c(0, 2, 5)[cherries + 1] # Calculate a prize
  }
  
  # Adjust for diamonds
  diamonds <- sum(symbols == "DD")  # Count diamonds
  prize * 2 ^ diamonds  # Double the prize if necessary
}

# Solution (simpler)
score <- function (symbols) {
  diamonds <- sum(symbols == "DD")
  cherries <- sum(symbols == "C")
  
  # Identify case
  # Only non-diamond matter for same & bars
  slots <- symbols[symbols != "DD"]
  same <- length(unique(slots)) == 1
  bars <- slots %in% c("B", "BB", "BBB")
  
  # Get prize
  if (diamonds == 3) {
    prize <- 100
  } else if (same) {  # All symbols are same
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[slots[1]])  # Look up prize
  } else if (all(bars)) {  # All bars
    prize <- 5  # Assign $5
  } else if (cherries > 0) {
    # Diamonds count as cherries
    prize <- c(0, 2, 5)[cherries + diamonds + 1] # Calculate a prize
  } else {
    prize <- 0
  }
  
  # Adjust for diamonds
  prize * 2 ^ diamonds  # Double the prize if necessary
}

# Exercise 11.7 (Calculate the expected value)
# Update the prizes
for (i in 1:nrow(combos)) {
  symbols <- c(combos[i, 1], combos[i, 2], combos[i, 3])
  combos$prize[i] <- score(symbols)
}

# Recompute expected value
sum(combos$prize * combos$prob)  # 0.934356
# Both solutions work :)

# 11.4 while loops
while (condition) {
  code
}  # Runs chunk while condition remains TRUE

plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  while (cash > 0) {
    cash <- cash - 1 + play()
    n <- n + 1
  }
  n
}

plays_till_broke(100)  # Starting with $100, how many plays until broke?

# 11.5 repeat loops
# Repeats chunk until hit stop or encounters break command
plays_till_broke <- function(start_with) {
  cash <- start_with
  n <- 0
  repeat {
    cash <- cash - 1 + play()
    n <- n + 1
    if (cash <= 0) {
      break
    }
  }
  n
}  # Recreates same function

plays_till_broke(100)


