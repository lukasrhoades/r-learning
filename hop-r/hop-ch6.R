# Ch 6 R Notation

# 6.1 Selecting values

deck[ , ]

# 6.1.1 Positive integers
head(deck)

deck[1, 1]

deck[1, c(1, 2, 3)]  # First row of deck

new <- deck[1, c(1, 2, 3)]
new

deck[c(1, 1), c(1, 2, 3)]  # Returns it twice

vec <- c(6, 1, 3, 6, 10, 5)
vec[1:3]

deck[1:2, 1:2]
deck[1:2, 1]  # Returns vector
deck[1:2, 1, drop = FALSE]  # Returns data frame

# 6.1.2 Negative integers
deck[-(2:52), 1:3]  # Returns only first row

deck[c(-1, 1), 1]  # Error

# 6.1.3 Zero
deck[0, 0]  # Zero returns nothing from a dimension

# 6.1.4 Blank spaces
deck[1, ]  # Returns entire first row

# 6.1.5 Logical values
deck[1, c(TRUE, TRUE, FALSE)]  # Returns first two columns of first row

rows <- c(TRUE, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, 
          F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, F, 
          F, F, F, F, F, F, F, F, F, F, F, F, F, F)
deck[rows, ]  # Returns first row

# 6.1.6 Names
deck[1, c("face", "suit", "value")]

deck[ , "value"]  # Returns entire value column

# 6.2 Deal a card
# Exercise 6.1 (Deal a card)
deal <- function(cards) {
  cards[1, ]  # Returns first row of cards
}

deal(deck)

# 6.3 Shuffle the deck
deck2 <- deck[1:52, ]
head(deck2)

deck3 <- deck[c(2, 1, 3:52), ]
head(deck3)

random <- sample(1:52, size = 52)
random

deck4 <- deck[random, ]
head(deck4)

# Exercise 6.2 (Shuffle a deck)
shuffle <- function(cards) {
  cards[sample(1:52, size = 52), ]
}

deal(deck)

deck2 <- shuffle(deck)

deal(deck2)

# 6.4 Dollar signs and double brackets
deck$value  # Vector of value column

mean(deck$value)

median(deck$value)

lst <- list(numbers = c(1, 2), logical = TRUE, strings = c("a", "b", "c"))
lst

lst[1]  # Returns a new list
sum(lst[1])  # Error, can't sum a list

lst$numbers  # No list
sum(lst$numbers)

lst[[1]]  # Same as lst$numbers

lst["numbers"]

lst[["numbers"]]
