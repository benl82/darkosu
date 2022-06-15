# Converts "RED POCKET"-type input lists to .osu file format.
# Doesn't account for LNs (will come later)

library(tidyverse)

getosu <- function(rp, start, bpm, snap, keys = 4, path = "getosu.txt") {
  # rp - the list of inputs. See the other .R files in darkosu for information on their output format.
  # start - the timestamp of the start of the pattern (in ms).
  # bpm - the bpm of the map.
  # snap - the snap used. For 1/6 input 6, 1/4 input 4, 1/8 input 8, etc.
  # keys - the number of keys.
  # path - the file path to write to.
  
  # Output - writes to a file. Default
  xbar <- c()
  tbar <- c()
  
  x <- numeric(keys)
  for (i in 1:keys) {
    # 512 / 2k, odd
    x[i] <- floor(256.0 * (2 * i - 1) / keys)
  }
  offs <- 60000 / (bpm * snap)
  it <- 0
  curr <- start
  for (i in rp) {
    curr <- floor(start + it * offs)
    for (j in i) {
      xbar <- c(xbar, x[j])
      tbar <- c(tbar, curr)
    }
    it <- it + 1
  }
  
  ybar <- rep(192, length(xbar))
  acc <- rep("1,0,0:0:0:0:", length(xbar))
  output <- data.frame(cbind(xbar, ybar, tbar, acc))
  write.table(output, file = path, sep = ",", col.names = FALSE, row.names = FALSE, quote = FALSE)
}