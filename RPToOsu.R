# Converts "RED POCKET"-type input lists to .osu file format.
# Doesn't account for LNs (will come later)

library(tidyverse)
setwd(dirname(parent.frame(2)$ofile))

getosu <- function(rp, start, bpm, snap, keys = 4, path = "getosu.txt") {
  # rp - the df of inputs. See the other .R files in darkosu for information on their output format.
  # start - the timestamp of the start of the pattern (in ms).
  # bpm - the bpm of the map.
  # snap - the snap used. For 1/6 input 6, 1/4 input 4, 1/8 input 8, etc.
  # keys - the number of keys.
  # path - the file path to write to.
  # Output - writes to a file.
  xbar <- c()
  tbar <- c()
  x <- numeric(keys)
  for (i in 1:keys) {
    x[i] <- floor(256.0 * (2 * i - 1) / keys)
  }
  offs <- 60000 / (bpm * snap)
  it <- 0
  curr <- start
  for (i in 1:nrow(rp)) {
    xbar <- c(xbar, x[rp$c[i]])
    tbar <- c(tbar, floor(start + rp$t[i] * offs))
  }
  ybar <- rep(192, length(xbar))
  acc <- rep("1,0,0:0:0:0:", length(xbar))
  output <- data.frame(cbind(xbar, ybar, tbar, acc))
  write.table(output, file = path, sep = ",", col.names = FALSE, row.names = FALSE, quote = FALSE)
  return("hi console =D")
}

listtorp <- function(w) {
  # Converts deprecated list format to RP
  cbar <- c()
  tbar <- c()
  for (i in 1:length(w)) {
    for (j in w[[i]]) {
      cbar <- c(cbar, j)
      tbar <- c(tbar, i - 1)
    }
  }
  return(data.frame(cbind('c' = cbar, 't' = tbar)))
}