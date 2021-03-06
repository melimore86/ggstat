notify_guess <- function(x, explanation = NULL) {
  msg <- paste0(
    "Guessing `", deparse(substitute(x)), " = ", format(x, digits = 3), "`",
    if (!is.null(explanation)) paste0(" # ", explanation)
  )
  message(msg)
}

is_numeric <- function(x) {
  typeof(x) %in% c("double", "integer") && !is.factor(x)
}

is_atomic <- function(x) {
  typeof(x) %in% c("logical", "integer", "double", "complex", "character", "raw")
}

is_vector <- function(x) {
  is_atomic(x) || is.list(x)
}

`%||%` <- function(x, y) if (is.null(x)) y else x

plot_init <- function(x, y,
                      xlim = range(x, na.rm = TRUE),
                      ylim = range(y, na.rm = TRUE), ...) {
  old <- par(mar = c(1.5, 1.5, 0, 0), cex = 0.8)
  on.exit(par(old))

  plot.default(xlim, ylim, type = "n", xlab = "", ylab = "", axes = FALSE)
  axis(1, lwd = 0, lwd.ticks = 1, col = "grey80", col.axis = "grey60", padj = -1)
  axis(2, lwd = 0, lwd.ticks = 1, col = "grey80", col.axis = "grey60", padj = 1)
  grid(lty = "solid", col = "grey80")
}

row_apply <- function(df, f, ...) {

  row_slice <- function(df, i) {
    out <- pluck(df, i)
    `as.data.frame!`(out, 1)
    out
  }

  lapply(1:nrow(df), function(i) f(row_slice(df, i), ...))
}

pluck <- function(x, name, type) {
  if (missing(type)) {
    lapply(x, "[[", name)
  } else {
    vapply(x, "[[", name, FUN.VALUE = type)
  }
}

pretty_width <- function(x, n = 30) {
  bounds <- pretty(x, n)
  width <- bounds[2] - bounds[1]
  notify_guess(width, paste0("range / ", length(bounds) - 1))
  width
}

rescale01 <- function(x) {
  rng <- frange(x)
  (x - rng[1]) / (rng[2] - rng[1])
}
