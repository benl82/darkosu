library(tidyverse)

# Version 1.
# Not in .osu format.

# Main principles of "RED POCKET"-type speed (the most basic type):
# 1. No two notes on the same column within 2.
# 2. Don't repeat sequences of length 4+.
# 2a. Since truly satisfying principle 2 is too memory-intensive,
  # we say don't repeat from 4 to 2*jump.
# This formula breaks when the jump frequency is 3 or lower since we are forced to violate principle 1.

# In version 1 here we're not considering subsets of jumps to violate principle 2. This is because I hate coding.

# This type of speed is seen in maps like "Mario Paint [D-ANOTHER]" or some Crz[Rachel] speed maps.

rd <- function(x, n) {
  # A new random function, since sample() has unintended side effects.
  # x the vector, n the number.
  
  if (length(x) < 2) {
    return(x)
  } else {
    return(sample(x, n))
  }
}

p1 <- function(x) {
  # x: A list of length 1 or 2.
  # This function checks principle 1.
  # It will return a subset of 1:4 representing which notes are available for the next note (not used in the past 2).
  r <- c()
  s <- 1:4
  for (i in x) {
    for (j in i) {
      r <- c(r, j)
    }
  }
  return(s[which(!s %in% r)])
}

p2seqf <- function(x) {
  # Accessory function to p2().
  # Takes in a list x of length 2n - 1, where n >= 4.
  # If x can be expressed as ApA, where A is a sequence of length n and p a single element, return p.
  # Else return 0.
  
  n <- (length(x)-1)/2
  k <- TRUE
  for (i in 1:n) {
    if (!identical(x[i],x[i+n+1])) {
      k <- FALSE
      break
    }
  }
  if (k) {
    return(x[[n+1]])
  } else {
    return(0)
  }
}

p2 <- function(x, isj, j) {
  # x: A list (the whole map up to this point)
  # isj: A boolean representing whether or not the next note to be placed is a jump.
  # j: See gen1().
  # This function checks principle 2.
  # Returns a subset of 1:4 representing which notes are available.
  
  s <- 1:4
  r <- c()
  
  for (i in 4:(2 * j)) {
    if (i * 2 >= length(x)) {
      break
    }
    # Creating the sub x sequence
    xs <- x[(length(x)-(2*i)+1):length(x)]
    p <- p2seqf(xs)
    if (identical(p,0)) {
      next
    }
    if ((length(p) > 1 && !isj) || (length(p) < 2 && isj)) {
      next
    }
    # Everything that's in p, we throw in the r vector (the not-allowed vector)
    for (i in p) {
      r <- c(r, i)
    }
  }
  return(s[which(!s %in% r)])
}

gen1 <- function(n = 100, j = 12) {
  # n: The length (number of sub-beats)
  # j: Jump every j beats. Considered jumpstream if j <= 4, so don't put any values less than 5 for j.
  # Enter j = 0 (or any negative number) if you don't want any jumps.
  # Starts with a jump by default.
  w <- vector(mode = "list", length = n)
  if (j <= 0) {
    w[[1]] <- rd(1:4, 1)
  } else {
    w[[1]] <- rd(1:4, 2)
  }
  # cat("start:", w[[1]], "\n\n")
  for (i in 2:n) {
    if (i > 2) {
      s1 <- p1(w[(i-2):(i-1)])
    } else {
      s1 <- p1(w[i-1])
    }
    isj <- FALSE
    if ((i - 1) %% j == 0) {
      isj <- TRUE
    }
    s2 <- p2(w, isj, j)
    s <- s1[which(s1 %in% s2)]
    if (isj) {
      w[[i]] <- rd(s, 2)
    } else {
      w[[i]] <- rd(s, 1)
    }
    # cat("i:", i, "\n")
    # cat("s1:", s1, "\n")
    # cat("s2:", s2, "\n")
    # cat("s", s, "\n")
    # cat(w[[i]], "\n")
    # cat("\n")
  }
  for (i in w) {
    for (k in i) {
      cat(k, "")
    }
    cat("\n")
  }
}

gen1(n = 100, j = 6)