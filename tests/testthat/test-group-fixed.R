context("group_fixed")

test_that("throws error if width is <= 0", {
  expect_error(group_fixed(1:10, -1, 0, 10), "`width` must be positive")
  expect_error(group_fixed(1:10, 0, 0, 10), "`width` must be positive")
})

test_that("non-finite values go bin 0", {
  out <- group_fixed(c(NA, Inf, -Inf), 1, 0, 10)
  expect_equal(out$x, c(0L, 0L, 0L))
})

test_that("values less than origin go in bin 0", {
  out <- group_fixed(c(-1, -100), 1, 0, 10)
  expect_equal(out$x, c(0L, 0L))
})

test_that("bin number as expected for middle of bin", {
  # (0, 1], (1, 2], (2, 3]
  out1 <- group_fixed(c(0.5, 1.5, 2.5), 1, min = 0, max = 2.5)
  expect_equal(out1$x, c(1, 2, 3))
  expect_equal(out1$nbins, 4)
})

test_that("respects right_closed", {
  # (0, 1], (1, 2]
  out1 <- group_fixed(c(2, 1), 1, min = 0, max = 2, right_closed = TRUE)
  expect_equal(out1$x, c(2, 1))
  expect_equal(out1$nbins, 3)

  # [0, 1), [1, 2), [2, 3)
  out2 <- group_fixed(c(2, 1), 1, min = 0, max = 2, right_closed = FALSE)
  expect_equal(out2$nbins, 4)
  expect_equal(out2$x, c(3, 2))
})

test_that("preserves class variables", {
  x <- as.Date("2000-01-01") + 0:1
  out <- group_fixed(x, 2, min = min(x), max = max(x))

  expect_equal(out$bins$xmin_, as.Date(c(NA, "2000-01-01")))
  expect_equal(out$bins$xmax_, as.Date(c(NA, "2000-01-03")))
})

# Floating point ----------------------------------------------------------

test_that("Binning robust to minor FP differences", {
  # Three vectors with a classical FP issue
  x1 <- 0:3
  x2 <- x1 + (1 - 0.9) - 0.1
  x3 <- x1 - (1 - 0.9) + 0.1

  b1 <- group_fixed(x1, width = 1, min = 0, max = 4, right_closed = FALSE)
  expect_equal(b1$x, 1:4)

  b2 <- group_fixed(x2, width = 1, min = 0, max = 4, right_closed = FALSE)
  expect_equal(b2$x, 1:4)

  b3 <- group_fixed(x3, width = 1, min = 0, max = 4, right_closed = FALSE)
  expect_equal(b3$x, 1:4)

  b4 <- group_fixed(x1, width = 1, min = -1, max = 4)
  expect_equal(b4$x, 2:5)

  b5 <- group_fixed(x2, width = 1, min = -1, max = 4)
  expect_equal(b5$x, 2:5)

  b6 <- group_fixed(x3, width = 1, min = -1, max = 4)
  expect_equal(b6$x, 2:5)
})
