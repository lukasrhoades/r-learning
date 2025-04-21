score <- function (symbols) {
  # Identify case
  same <- symbols[1] == symbols[2] && symbols[2] == symbols[3]
  bars <- symbols %in% c("B", "BB", "BBB")
  
  # Get prize
  if (same) {  # All symbols are same
    payouts <- c("DD" = 100, "7" = 80, "BBB" = 40, "BB" = 25,
                 "B" = 10, "C" = 10, "0" = 0)
    prize <- unname(payouts[symbols[1]])  # Look up prize
  } else if (all(bars)) {  # All bars
    prize <- 5  # Assign $5
  } else {
    cherries <- sum(symbols == "C")  # Count cherries
    prize <- c(0, 2, 5)[cherries + 1] # Calculate a prize
  }
  
  # Adjust for diamonds
  diamonds <- sum(symbols == "DD")  # Count diamonds
  prize * 2 ^ diamonds  # Double the prize if necessary
}