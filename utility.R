# Various utility outlined in section 3 of darkosu_notes.pdf
# Assuming RP data frame format.
defaultW <- getOption("warn") 
options(warn = -1) 
suppressMessages(library(tidyverse))
options(warn = defaultW)

point <- function(rp, i) {
  # Gets point A_i
  return(filter(rp, t == i))
}
subseq <- function(rp, i, j) {
  # Gets subsequence i through j, inclusive
  return(filter(rp, (t >= i && t <= j)))
}
len <- function(rp) {
  return(max(rp$t) + 1)
}
cont <- function(rp, i, n) {
  # The "in" operator
  # i the point, and n the column in question.
  return(nrow(filter(point(rp, i), c == n)) > 0)
}
density <- function(rp) {
  return(nrow(rp) / len(rp))
}
mag <- function(rp, i, n) {
  # Magnitude
  # i the point, and n the column in question.
  return(nrow(point(rp, i)))
}
vecx <- function(x) {
  # x a point, extracts vector (sorted)
  return(sort(x$c))
}
nn <- function(x) {
  # x a point, the n() function
  return(as.numeric(paste(vecx(x), collapse = "")))
}
bit4 <- function(x) {
  # x a point, 4bit (0-15)
  vec <- c(0,0,0,0)
  for (i in vecx(x)) {
    vec[i] <- 1
  }
  return((vec %*% c(8,4,2,1))[1,1])
}
`%a%` <- function(x, y) {
  # infix add
  return(sort(union(vecx(x), vecx(y))))
}
`%m%` <- function(x, y) {
  # infix multiply
  return(sort(intersect(vecx(x), vecx(y))))
}
`%s%` <- function(x, y) {
  # infix subtract
  return(sort(setdiff(vecx(x), vecx(y))))
}

# Advanced

jackdensity <- function(rp) {
  jacks <- 0
  for (i in 0:(len(rp) - 1)) {
    jacks <- jacks + length(point(rp, i) %m% point(rp, i + 1))
  }
  return(jacks / (len(rp) - 1))
}
meananchorlength <- function(rp) {
  if (jackdensity(rp) > 0) {
    anc <- 1
  } else {
    anc <- 0
  }
}