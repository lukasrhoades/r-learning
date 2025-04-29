# Ch 12 Speed

# 12.1 Vectorized code

# Vectorized code takes advantage of logical tests, subsetting, and
# element-wise execution to manipulate values in vectors at same time

abs_loop <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] < 0) {
      vec[i] <- -vec[i]
    }
  }
  vec
}  # Not vectorized, uses a for loop

abs_set <- function(vec) {
  negs <- vec < 0
  vec[negs] <- vec[negs] * -1
  vec
}  # Vectorized, uses logical subsetting to manipulate every negative number
# at the same time

long <- rep(c(-1, 1), 5000000)  # 10 million values

system.time(abs_loop(long))
system.time(abs_set(long))  # Much faster

# Exercise 12.1 (How fast is abs?)
system.time(abs(long))  # Even faster
# Many built-in functions are already vectorized and can save time

# 12.2 How to write vectorized code

# 1) use vectorized functions to complete sequential steps
# 2) use logical subsetting to handle parallel cases, attempting to
# manipulate every element in a case at once

vec <- c(1, -2, 3, -4, 5, -6, 7, -8, 9, -10)
vec < 0  # Retrieves mask
vec[vec < 0]  # Only contains negative values

vec[vec < 0] * -1  # Multiplies each by -1 at same time
# Assignment and arithmetic operators are vectorized

# Exercise 12.2 (Vectorize a function)
# Original function
change_symbols <- function(vec) {
  for (i in 1:length(vec)) {
    if (vec[i] == "DD") {
      vec[i] <- "joker"
    } else if (vec[i] == "C") {
      vec[i] <- "ace"
    } else if (vec[i] == "7") {
      vec[i] <- "king"
    } else if (vec[i] == "B") {
      vec[i] <- "queen"
    } else if (vec[i] == "BB") {
      vec[i] <- "jack"
    } else if (vec[i] == "BBB") {
      vec[i] <- "ten"
    } else {
      vec[i] <- "nine"
    } 
  }
  vec
}

vec <- c("DD", "C", "7", "B", "BB", "BBB", "0")
change_symbols(vec)

many <- rep(vec, 1000000)
system.time(change_symbols(many))

# New function
change_symbols <- function(vec) {
  vec[vec == "DD"] <- "joker"
  vec[vec == "C"] <- "ace"
  vec[vec == "7"] <- "king"
  vec[vec == "B"] <- "queen"
  vec[vec == "BB"] <- "jack"
  vec[vec == "BBB"] <- "ten"
  vec[vec == "0"] <- "nine"
  
  vec
}  # Much faster!

# Even better, use a lookup table (relies on vectorized selection)
change_vec <- function(vec) {
  tb <- c("DD" = "joker", "C" = "ace", "7" = "king", "B" = "queen",
          "BB" = "jack", "BBB" = "ten", "0" = "nine")
  unname(tb[vec])
}
change_vec(vec)
system.time(change_vec(many))  # Rapid

# R is not compiled like in C, so for loops don't get optimized

# Can replace for and if combo with a logical subset

# 12.3 How to write fast for loops in R

# 1) Do as much as you can outside of the loop
# 2) Ensure storage items inside loop can contain all results of loop

system.time({
  output <- rep(NA, 1000000)
  for (i in 1:1000000) {
    output[i] <- i + 1
  }
})  # Stores values in vector that begins with length of one million

system.time({
  output <- NA
  for (i in 1:1000000) {
    output[i] <- i + 1
  } 
})  # Stores values in vector that begins with length of one
# R will expand vector as it runs the loop, thus much slower
# because it has to rewrite output one million times

# .Primitive, .Internal, .Call in a function definition
# means that it is calling from another language, means you get
# speed advantages of that language (e.g. C)

# 12.4 Vectorized code in practice

# Before we calculated expected value for slot machine payout
# But you can also use law of large numbers to estimate with simulation
winnings <- vector(length = 10000000)
for (i in 1:10000000) {
  winnings[i] <- play()
}
mean(winnings)  # 0.933 very close to true payout of 0.934

system.time(for (i in 1:1000000) {
  winnings[i] <- play()
})  # Takes a long time to run...

# Can do better (speed) using vectorized code
# Current score function is not vectorized, uses an if tree,
# which above is being used in a for loop...
# Means we can write vectorized code that takes many slot combos
# and uses logical subsetting to operate on all of them at once!

# First rewrite get_symbols
get_many_symbols <- function(n) {
  wheel <- c("DD", "7", "BBB", "BB", "B", "C", "0")
  vec <- sample(wheel, size = 3 * n, replace = TRUE, 
                prob = c(0.03, 0.03, 0.06, 0.1, 0.25, 0.01, 0.52))
  matrix(vec, ncol = 3)
}  # Generates n slot combos and returns as n x 3 matrix, where each row
# contains one slot combination to be scored
get_many_symbols(5)

# Then rewrite play
play_many <- function(n) {
  symb_mat <- get_many_symbols(n = n)
  data.frame(w1 = symb_mat[,1], w2 = symb_mat[,2],
             w3 = symb_mat[,3], prize = score_many(symb_mat))
}  # Takes a parameter n and returns n prizes in a data frame

# Now need to write score_many, a vectorized version of score

# Exercise 12.4 (Advanced challenge)

# My attempt! Works after some debugging :)
score_many <- function(symb_mat) {
  # Count number of diamonds and cherries
  diamonds <- matrix(rowSums(symb_mat == "DD"), ncol = 1)
  cherries <- matrix(rowSums(symb_mat == "C"), ncol = 1)
  
  # Identify case
  # Only non-diamond matter for same & bars
  slots <- symb_mat  # Make a copy for non-diamonds
  slots[slots == "DD"] <- NA
  
  # Check if non-diamonds are all the same
  is_same <- function(row) {
    row <- na.omit(row)
    length(unique(row)) == 1
  }
  same <- apply(slots, MARGIN = 1, FUN = is_same)
  
  # Check if non-diamonds are all bars
  is_bars <- function(row) {
    row <- na.omit(row)
    all(row %in% c("B", "BB", "BBB"))
  }
  bars <- apply(slots, MARGIN = 1, FUN = is_bars)
  
  # Prepare prizes vector
  prizes <- vector(length = nrow(symb_mat))
  
  # All symbols are same, lookup prize
  payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
               "B" = 10, "C" = 10, "0" = 0)
  check_symbol <- function(row) {
    row <- na.omit(row)  # In case diamond was in position 1
    row[1]
  }
  to_lookup <- apply(slots[same, ], MARGIN = 1, FUN = check_symbol)
  prizes[same] <- unname(payouts[to_lookup]) 
  
  # All symbols are bars, assign $5
  prizes[!same & bars] <- 5
  
  # Calculate prizes for cherries (diamonds count)
  prizes[!same & cherries > 0] <- c(0, 2, 5)[cherries[!same & cherries > 0] + diamonds[!same & cherries > 0] + 1]
  
  # Calculate prizes for all diamonds
  prizes[diamonds == 3] <- 100
  
  # Adjust for diamonds
  prizes <- prizes * 2 ^ diamonds  # Double the prize if necessary
}

plays <- play_many(1000000)
mean(plays$prize) # Works (treats diamonds as wild)
system.time(play_many(1000000))  # 7.752

# Now let's see the textbook solution

# Exercise 12.3 (Test your understanding)

# Symbols should be a matrix with a column for each slot machine window
score_many <- function(symbols) {
  
  # Step 1: Assign base prize based on cherries and diamonds ---------
  ## Count the number of cherries and diamonds in each combination
  cherries <- rowSums(symbols == "C")
  diamonds <- rowSums(symbols == "DD") 
  
  ## Wild diamonds count as cherries
  prize <- c(0, 2, 5)[cherries + diamonds + 1]
  
  ## ...but not if there are zero real cherries 
  ### (cherries is coerced to FALSE where cherries == 0)
  prize[!cherries] <- 0
  
  # Step 2: Change prize for combinations that contain three of a kind 
  same <- symbols[, 1] == symbols[, 2] & 
    symbols[, 2] == symbols[, 3]
  payoffs <- c("DD" = 100, "7" = 80, "BBB" = 40, 
               "BB" = 25, "B" = 10, "C" = 10, "0" = 0)
  prize[same] <- payoffs[symbols[same, 1]]
  
  # Step 3: Change prize for combinations that contain all bars ------
  bars <- symbols == "B" | symbols ==  "BB" | symbols == "BBB"
  all_bars <- bars[, 1] & bars[, 2] & bars[, 3] & !same
  prize[all_bars] <- 5
  
  # Step 4: Handle wilds ---------------------------------------------
  
  ## combos with two diamonds
  two_wilds <- diamonds == 2
  
  ### Identify the nonwild symbol
  one <- two_wilds & symbols[, 1] != symbols[, 2] & 
    symbols[, 2] == symbols[, 3]
  two <- two_wilds & symbols[, 1] != symbols[, 2] & 
    symbols[, 1] == symbols[, 3]
  three <- two_wilds & symbols[, 1] == symbols[, 2] & 
    symbols[, 2] != symbols[, 3]
  
  ### Treat as three of a kind
  prize[one] <- payoffs[symbols[one, 1]]
  prize[two] <- payoffs[symbols[two, 2]]
  prize[three] <- payoffs[symbols[three, 3]]
  
  ## combos with one wild
  one_wild <- diamonds == 1
  
  ### Treat as all bars (if appropriate)
  wild_bars <- one_wild & (rowSums(bars) == 2)
  prize[wild_bars] <- 5
  
  ### Treat as three of a kind (if appropriate)
  one <- one_wild & symbols[, 1] == symbols[, 2]
  two <- one_wild & symbols[, 2] == symbols[, 3]
  three <- one_wild & symbols[, 3] == symbols[, 1]
  prize[one] <- payoffs[symbols[one, 1]]
  prize[two] <- payoffs[symbols[two, 2]]
  prize[three] <- payoffs[symbols[three, 3]]
  
  # Step 5: Double prize for every diamond in combo ------------------
  unname(prize * 2^diamonds)
  
}

system.time(play_many(10000000))  # 6.671
