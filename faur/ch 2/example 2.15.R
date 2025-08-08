# Assuming all days except Feb 29 have same probability of being someone's birthday
# Feb 29 has 1/4 the probability of others (leap year)
# Model this by having 1/4 of the time 366 possibilities for someone's birthday

eventB <- replicate(n = 10000, {
  leap <- sample(1:4, 1)
  if (leap == 1) {
    birthdays <- sample(x = 1:366, size = 25, replace = TRUE)
  } else {
    birthdays <- sample(x = 1:365, size = 25, replace = TRUE)
  }
  anyDuplicated(birthdays) > 0
})
mean(eventB)

