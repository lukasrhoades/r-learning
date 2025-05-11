library(tidyverse)

ggplot(diamonds, aes(x = carat, y = price)) +
  geom_hex()
ggsave("ch6/diamonds.png")

write_csv(diamonds, "ch6/data/diamonds.csv")