# R objects

# 5.1 Atomic vectors
die <- c(1, 2, 3, 4, 5, 6)
die

is.vector(die)

five <- 5
five

is.vector(five)

length(five)
length(die)

int <- 1L
text <- "ace"

int <- c(1L, 5L)
text <- c("ace", "hearts")

sum(int)
sum(text)

# 5.1.1 Doubles
typeof(die)

# 5.1.2 Integers
int <- c(-1L, 2L, 4L)
int

typeof(int)

sqrt(2)^2 - 2

# 5.1.3 Characters
text <- c("Hello", "World")
text

typeof(text)

typeof("Hello")

# 5.1.4 Logicals
3 > 4

logic <- c(TRUE, FALSE, TRUE)
logic

typeof(logic)

typeof(F)

# 5.1.5 Complex and Raw
comp <- c(1 + 1i, 1 + 2i, 1 + 3i)
comp

typeof(comp)

raw(3)

typeof(raw(3))

?raw

# Exercise 5.2 (Vector of Cards)
hand <- c("ace", "king", "queen", "jack", "ten")
hand

typeof(hand)

# 5.2 Attributes
attributes(die)

# 5.2.1 Names
names(die)

names(die) <- c("one", "two", "three", "four", "five", "six")

names(die)

attributes(die)

die

die + 1

names(die) <- c("uno" ,"dos", "tres", "quatro",  "cinco", "seis")
die

names(die) <- NULL
die

# 5.2.2 Dim
dim(die) <- c(2, 3)
die

dim(die) <- c(3, 2)
die

dim(die) <- c(1, 2, 3)
die

# 5.3 Matrices
m <- matrix(die, nrow = 2)
m

m <- matrix(die, nrow = 2, byrow = TRUE)
m

?matrix

# 5.4 Arrays
ar <- array(c(11:14, 21:24, 31:34), dim = c(2, 2, 3))
ar

hand1 <- c(hand, replicate(5, "spades"))
matrix(hand1, nrow = 5)

# 5.5 Class
dim(die) <- c(2, 3)
typeof(die)

class(die)

attributes(die)

class("Hello")

class(5)

# 5.5.1 Dates and Times
now <- Sys.time()
now

typeof(now)

class(now)

unclass(now)

mil <- 1000000
mil

class(mil) <- c("POSIXct", "POSIXt")
mil

# 5.5.2 Factors
gender <- factor(c("male", "female", "female", "male"))

typeof(gender)

attributes(gender)

unclass(gender)

gender

as.character(gender)

# Exercise 5.4 (Write a card)
card <- c("ace", "heart", 1)
card
typeof(card)

# 5.6 Coercion
sum(c(TRUE, TRUE, FALSE, FALSE))

as.character(1)

as.logical(1)

as.numeric(FALSE)

# 5.7 Lists
list1 <- list(100:130, "R", list(TRUE, FALSE))
list1

# Exercise 5.5 (Use a list to make a card)
card <- list("ace", "hearts", 1)
card

# 5.8 Data Frames
df <- data.frame(face = c("ace", "two", "six"),
                 suit = c("clubs", "clubs", "clubs"),
                 value = c(1, 2, 3),
                 stringsAsFactors = TRUE)
df

typeof(df)

class(df)

str(df)

df <- data.frame(face = c("ace", "two", "six"),
                 suit = c("clubs", "clubs", "clubs"),
                 value = c(1, 2, 3))
df

str(df)

# 5.9 Loading Data
head(deck)

# 5.10 Saving Data
write.csv(deck, file = "cards.csv", row.names = FALSE)

?write.csv
