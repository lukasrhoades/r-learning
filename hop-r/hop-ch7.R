# Ch 7 Modifying values
deck2 <- deck

# 7.0.1 Changing values in place
vec <- c(0, 0, 0, 0, 0, 0)
vec

vec[1]

vec[1] <- 1000
vec

vec[c(1, 3, 5)] <- c(1, 1, 1)
vec

vec[4:6] <- vec[4:6] + 1
vec

vec[7] <- 0
vec

deck2$new <- 1:52  # Adds a new variable
head(deck2)

deck2$new <- NULL  # Deletes column
head(deck2)

deck2[c(13, 26, 39, 52), ]  # All the aces

# The values of the aces
deck2[c(13, 26, 39, 52), 3]
deck2$value[c(13, 26, 39, 52)]

# Set to 14 for game of war
deck2$value[c(13, 26, 39, 52)] <- c(14, 14, 14, 14)
deck2$value[c(13, 26, 39, 52)] <- 14  # (R recycling)

head(deck2, 13)

deck3 <- shuffle(deck)
head(deck3)

# 7.0.2 Logical subsetting
vec
vec[c(FALSE, FALSE, FALSE, FALSE, TRUE, FALSE, FALSE)]

# 7.0.2.1 Logical tests
1 > 2  # F

1 > c(0, 1, 2)  # T F F

c(1, 2, 3) == c(3, 2, 1)  # F T F

1 %in% c(3, 4, 5)  # F

c(1, 2) %in% c(3, 4, 5)  # F F

c(1, 2, 3) %in% c(3, 4, 5)  # F F T

c(1, 2, 3, 4) %in% c(3, 4, 5)  # F F T T

# Exercise 7.1 (How many aces?)
deck2$face == "ace"  # Mask
sum(deck2$face == "ace")  # Counts number of aces

deck3$face == "ace"
deck3$value[deck3$face == "ace"]  # Ace values
deck3$value[deck3$face == "ace"] <- 14
head(deck3, 12)

deck4 <- deck
deck4$value <- 0  # In hearts, every card has a value of 0...

head(deck4, 13)
# Except cards in the suit of hearts and the queen of spades
deck4$value[deck4$suit == "hearts"] <- 1

# 7.0.2.2 Boolean operators
a <- c(1, 2, 3)
b <- c(1, 2, 3)
c <- c(1, 2, 4)

a == b  # T T T

b == c  # T T F

a == b & b == c  # T T F

queenOfSpades <- deck4$face == "queen" & deck4$suit == "spades"
deck4[queenOfSpades, ]  # Selects row of queen of spades
deck4$value[queenOfSpades] <- 13

# Exercise 7.3 (Practice with tests)

# Is w positive?
w <- c(-1, 0, 1)
w > 0  # F F T

# Is x greater than 10 and less than 20?
x <- c(5, 15)
10 < x & x < 20  # F T

# Is object y the word February?
y <- "February"
y == "February"  # T

# Is every value in z a day of the week?
z <- c("Monday", "Tuesday", "Friday")
all(z %in% c("Monday", "Tuesday", "Wednesday", "Thursday", "Friday",
             "Saturday", "Sunday"))  # T

deck5 <- deck  # Blackjack time
head(deck5, 13)

facecard <- deck$face %in% c("king", "queen", "jack")
deck5[facecard, ]
deck5$value[facecard] <- 10
head(deck5, 13)

# 7.0.3 Missing information
1 + NA  # NA

NA == 1  # NA

# 7.0.3.1 na.rm
c(NA, 1:50)
mean(c(NA, 1:50))  # NA
mean(c(NA, 1:50), na.rm = TRUE)  # Ignore NA's

# 7.0.3.2 is.na
NA == NA  # NA

c(1, 2, 3, NA) == NA  # NA NA NA NA

is.na(NA)  # T

vec <- c(1, 2, 3, NA)
is.na(vec)  # F F F T

deck5$value[deck5$face == "ace"] <- NA
head(deck5, 13)