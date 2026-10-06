# List-valued arguments that replace prefix families (design rules 3.3 I.3):
# the bare value and the list form must lead to the same plot, and a
# mistyped element must not go unnoticed.

localDevice <- function(env = parent.frame()) {
  grDevices::pdf(NULL)
  withr::defer(grDevices::dev.off(), envir = env)
}


test_that(".valueSpec resolves value, list and unnamed element", {

  spec <- pharos:::.valueSpec

  expect_identical(spec("p", "type", list(cex = 0.8)),
                   list(type = "p", cex = 0.8))
  expect_identical(spec(list(type = "n", cex = 1), "type", list(cex = 0.8)),
                   list(type = "n", cex = 1))
  # the one unnamed element is the value
  expect_identical(spec(list("n", cex = 1), "type", list(cex = 0.8)),
                   list(type = "n", cex = 1))
  # details only: the value stays NULL, the defaults are kept
  expect_identical(spec(list(cex = 1), "type", list(cex = 0.8, digits = 1)),
                   list(type = NULL, cex = 1, digits = 1))
  expect_identical(spec(NULL, "text", list(adj = 0.5)),
                   list(text = NULL, adj = 0.5))

  expect_error(spec(list("p", size = 2), "type", list(cex = 0.8), arg = "labels"),
               "unknown element\\(s\\) in 'labels': 'size'")
})


test_that("plotMosaic takes the label details as a list", {

  localDevice()
  tab <- apply(HairEyeColor, c(1, 2), sum)

  expect_identical(plotMosaic(tab, labels = "n", stamp = FALSE),
                   plotMosaic(tab, labels = list("n", cex = 0.6), stamp = FALSE))
  expect_silent(plotMosaic(tab, labels = list(digits = 0), stamp = FALSE))
  expect_silent(plotMosaic(tab, labels = "none", stamp = FALSE))

  expect_error(plotMosaic(tab, labels = "x"), "should be one of")
  expect_error(plotMosaic(tab, labels = list("p", labCex = 1)),
               "unknown element")
})


test_that("plotTreemap takes the group appearance in the groups list", {

  localDevice()
  x   <- c(A = 6, B = 5, C = 4, D = 3, E = 2, F = 1)
  grp <- c("G1", "G1", "G1", "G2", "G2", "G2")

  bare <- plotTreemap(x, groups = grp, stamp = FALSE)
  expect_identical(plotTreemap(x, groups = list(grp), stamp = FALSE), bare)
  expect_identical(plotTreemap(x, groups = list(by = grp, labels = FALSE,
                                                area = list(border = "black")),
                               stamp = FALSE), bare)

  expect_error(plotTreemap(x, groups = list(grp, border = "black")),
               "unknown element\\(s\\) in 'groups'")
})


test_that("colLegend takes label and title details as lists", {

  localDevice()
  plot(1:10, type = "n")

  bare <- colLegend("right", labels = 1:5)
  expect_identical(colLegend("right", labels = list(1:5)), bare)
  expect_identical(colLegend("right", labels = list(text = 1:5, adj = "edge"),
                             title = list("Scale", adj = 0)), bare)

  # centred labels sit inside the outermost colour blocks
  ctr <- colLegend("right", col = heat.colors(5), labels = list(1:5, adj = "center"))
  edg <- colLegend("right", col = heat.colors(5), labels = 1:5)
  expect_lt(diff(range(ctr$text$y)), diff(range(edg$text$y)))

  expect_error(colLegend("right", labels = list(1:5, adj = "middle")),
               "should be one of")
  expect_error(colLegend("right", title = list("Scale", titleAdj = 0)),
               "unknown element\\(s\\) in 'title'")
})


test_that("plotFacet takes strip labels in the strip list and par through the dots", {

  localDevice()
  samples <- lapply(1:4, function(i) list(x = 1:10, y = (1:10) * i))
  panel   <- function(x, y, col, pch, ...) points(x, y, col = col, pch = pch)

  geom <- plotFacet(samples, dim = c(2, 2), FUN = panel, stamp = FALSE)
  expect_identical(geom$cex, 0.66)
  expect_identical(geom$strip_line, 1.2)

  # labels only: strips with default settings
  expect_identical(plotFacet(samples, dim = c(2, 2), FUN = panel, stamp = FALSE,
                             strip = list(labels = letters[1:4])), geom)

  expect_identical(plotFacet(samples, dim = c(2, 2), FUN = panel, stamp = FALSE,
                             strip = list(labels = letters[1:4], line = 2))$strip_line, 2)
  expect_identical(plotFacet(samples, dim = c(2, 2), FUN = panel, stamp = FALSE,
                             strip = FALSE)$strip_line, 0)

  # mar, oma and cex define the layout and do not reach the panel function;
  # pch does, with its default of 16
  seen <- list()
  spy  <- function(x, y, col, ...) seen[[length(seen) + 1L]] <<- names(list(...))
  wide <- plotFacet(samples, dim = c(2, 2), FUN = spy, stamp = FALSE,
                    cex = 0.8, mar = c(4, 4, 1, 1), oma = c(2, 2, 2, 1), lwd = 2)
  expect_identical(wide$cex, 0.8)
  expect_lt(wide$plot_width_in, geom$plot_width_in)
  expect_true(all(vapply(seen, setequal, logical(1L), c("pch", "lwd"))))

  expect_error(plotFacet(samples, dim = c(2, 2), FUN = panel, mar = 1))

  # the graphics state of the caller is restored
  op <- par(c("mfrow", "omi", "cex"))
  plotFacet(samples, dim = c(2, 2), FUN = panel, stamp = FALSE)
  expect_identical(par(c("mfrow", "omi", "cex")), op)
})


test_that("plotWeb takes the label texts as vector or in a list", {

  localDevice()
  m <- cor(mtcars[, 1:5])

  expect_silent(plotWeb(m, stamp = FALSE))
  expect_silent(plotWeb(m, labels = FALSE, stamp = FALSE))
  expect_silent(plotWeb(m, labels = LETTERS[1:5], stamp = FALSE))
  expect_silent(plotWeb(m, labels = list(LETTERS[1:5], cex = 0.8), stamp = FALSE))
  expect_silent(plotWeb(m, labels = list(text = LETTERS[1:5], las = 2), stamp = FALSE))
  expect_silent(plotWeb(m, labels = list(las = 2), stamp = FALSE))

  # the former element name must not be ignored silently
  expect_error(plotWeb(m, labels = list(labels = LETTERS[1:5])),
               "unknown element\\(s\\) in 'labels': 'labels'")
})


test_that("polarGrid takes the label size as cex", {

  localDevice()
  plot(0, 0, type = "n", xlim = c(-1, 1), ylim = c(-1, 1), asp = 1)

  expect_silent(polarGrid(cex = 0.7))
  expect_error(polarGrid(cex.lab = 0.7), "unused argument")
})
