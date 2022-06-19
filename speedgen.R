source("RPToOsu.R")
source("utility.R")
cat("hi from R\n") # test

# Version 1.
# Not in .osu format.
# In version 1 here we're not considering subsets of jumps to violate principle 2. This is because I hate coding.
# We also don't really have a switcher or balancer so the map might suck, FYI.
# Time complexity is also massive, don't try to make size 10^8 maps or whatever.

set.seed(12345)

rd <- function(x, n) {
  # A new random function, since sample() has unintended side effects.
  # x the vector, n the number.
  if (length(x) < 2) {
    return(rep(x, n))
  } else {
    return(sample(x, n))
  }
}

p1 <- function(x) {
  # x: A list of length 1 or 2.
  # This function checks principle 1.
  # Returns a subset of 1:4 representing which notes are available for the next note (not used in the past 2).
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
  # Takes in a list x of length 2n - 1, where n >= 6.
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
  # isj: # notes in next point
  # j: See gen1().
  # This function checks principle 2.
  # Returns a subset of 1:4 representing which notes are available.
  s <- 1:4
  r <- c()
  for (i in 6:max((2 * j),24)) {
    if (i * 2 >= length(x)) {
      break
    }
    xs <- x[(length(x)-(2*i)+1):length(x)]
    p <- p2seqf(xs)
    if (identical(p,0)) {
      next
    }
    if ((length(p) != isj)) {
      next
    }
    for (i in p) {
      r <- c(r, i)
    }
  }
  return(s[which(!s %in% r)])
}
gen1 <- function(n = 100, j = 12) {
  # n: The length (number of sub-beats) + 1
  # j: Jump every j beats. Considered jumpstream if j <= 4, so don't put any values less than 5 for j.
  # Enter j = 0 (or any negative number) if you don't want any jumps.
  # Starts with a jump by default.
  w <- vector(mode = "list", length = n)
  if (j <= 0) {
    w[[1]] <- rd(1:4, 1)
  } else {
    w[[1]] <- rd(1:4, 2)
  }
  w <- vector(mode = "list", length = n)
  if (j <= 0) {
    w[[1]] <- rd(1:4, 1)
  } else {
    w[[1]] <- rd(1:4, 2)
  }
  for (i in 2:(n+1)) {
    if (i > 2) {
      s1 <- p1(w[(i-2):(i-1)])
    } else {
      s1 <- p1(w[i-1])
    }
    isj <- 1
    if ((i - 1) %% j == 0) {
      isj <- 2
    }
    s2 <- p2(w, isj, j)
    s <- s1[which(s1 %in% s2)]
    w[[i]] <- rd(s, isj)
  }
  return(listtorp(w))
}

# Just a test, this is for my file "Map of Scars"
getosu(rp = gen1(n = 1000, j = 12), start = 316783, bpm = 115, snap = 12, keys = 4)

df <- gen1()
head(df)
a <- point(df, 0)
b <- point(df, 1)

v1 <- c(1,2,3,4,1,2,3,2,3,4,1,2,3)
v2 <- c(0,0,0,0,1,1,1,2,2,2,3,3,3)
rpt <- data.frame(cbind('c' = v1, 't' = v2))
jackdensity(rpt)