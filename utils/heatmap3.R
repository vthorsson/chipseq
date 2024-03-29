heatmap3 <- function (x, Rowv, Colv, distfun = dist, hclustfun = hclust, 
    add.expr, scale = c("row", "column", "none"), na.rm = TRUE, 
    do.dendro = c(TRUE, TRUE), legend = 0, legfrac = 8, col = heat.colors(12), 
    trim, ...) 
{
    scale <- match.arg(scale)
    if (length(di <- dim(x)) != 2 || !is.numeric(x)) 
        stop("`x' must be a numeric matrix")
    nr <- di[1]
    nc <- di[2]
    if (nr <= 1 || nc <= 1) 
        stop("`x' must have at least 2 rows and 2 columns")
    r.cex <- 0.2 + 1/log10(nr)
    c.cex <- 0.2 + 1/log10(nc)

    r.cex <- 0.9
    c.cex <- 0.9

    if (missing(Rowv)) 
        Rowv <- rowMeans(x, na.rm = na.rm)
    if (missing(Colv)) 
        Colv <- colMeans(x, na.rm = na.rm)
    if (!identical(Rowv, NA)) {
        if (!inherits(Rowv, "dendrogram")) {
            hcr <- hclustfun(distfun(x))
            ddr <- as.dendrogram(hcr)
            ddr <- reorder(ddr, Rowv)
        }
        else ddr <- Rowv
        rowInd <- order.dendrogram(ddr)
    }
    else {
        rowInd = 1:nr
        do.dendro[1] = FALSE
    }
    if (!identical(Colv, NA)) {
        if (!inherits(Colv, "dendrogram")) {
            hcc <- hclustfun(distfun(t(x)))
            ddc <- as.dendrogram(hcc)
            ddc <- reorder(ddc, Colv)
        }
        else ddc <- Colv
        colInd <- order.dendrogram(ddc)
    }
    else {
        colInd = 1:nc
        do.dendro[2] = FALSE
    }
    x <- x[rowInd, colInd]
    if (scale == "row") {
        x <- sweep(x, 1, rowMeans(x, na.rm = na.rm))
        sd <- apply(x, 1, sd, na.rm = na.rm)
        x <- sweep(x, 1, sd, "/")
    }
    else if (scale == "column") {
        x <- sweep(x, 2, colMeans(x, na.rm = na.rm))
        sd <- apply(x, 2, sd, na.rm = na.rm)
        x <- sweep(x, 2, sd, "/")
    }
    op <- par(no.readonly = TRUE)
    on.exit(par(op))
    if (!missing(trim)) {
        trim = min(trim[1], 1 - trim[1])
        lo = quantile(x, trim, na.rm = na.rm)
        hi = quantile(x, 1 - trim, na.rm = na.rm)
        x[x < lo] = lo
        x[x > hi] = hi
    }
    do.xaxis = !is.null(colnames(x))
    do.yaxis = !is.null(rownames(x))
    margin = rep(0, 4)
    margin[1] = if (do.xaxis) 
        5
    else 2
    margin[2] = if (do.dendro[1]) 
        0
    else 2
    margin[3] = if (do.dendro[2]) 
        0
    else 2
    margin[4] = if (do.yaxis) 
        5
    else 2
    if (do.dendro[1] & do.dendro[2]) {
        ll = matrix(c(0, 3, 2, 1), 2, 2, byrow = TRUE)
        ll.width = c(1, 4)
        ll.height = c(1, 4)
    }
    else if (do.dendro[1]) {
        ll = matrix(c(2, 1), 1, 2, byrow = TRUE)
        ll.width = c(1, 4)
        ll.height = 4
    }
    else if (do.dendro[2]) {
        ll = matrix(c(2, 1), 2, 1, byrow = FALSE)
        ll.width = 4
        ll.height = c(1, 4)
    }
    else {
        ll = matrix(1, 1, 1)
        ll.width = 1
        ll.height = 1
    }
    if (legend %in% 1:4) {
        plotnum = max(ll) + 1
        nc = ncol(ll)
        nr = nrow(ll)
        if (legend == 1) {
            ll = rbind(ll, if (nc == 1) 
                plotnum
            else c(0, plotnum))
            ll.height = c(ll.height, sum(ll.height)/(legfrac - 
                1))
            leg.hor = TRUE
        }
        else if (legend == 2) {
            ll = cbind(if (nr == 1) 
                plotnum
            else c(0, plotnum), ll)
            ll.width = c(sum(ll.width)/(legfrac - 1), ll.width)
            leg.hor = FALSE
        }
        else if (legend == 3) {
            ll = rbind(if (nc == 1) 
                plotnum
            else c(0, plotnum), ll)
            ll.height = c(sum(ll.height)/(legfrac - 1), ll.height)
            leg.hor = TRUE
        }
        else if (legend == 4) {
            ll = cbind(ll, if (nr == 1) 
                plotnum
            else c(0, plotnum))
            ll.width = c(ll.width, sum(ll.width)/(legfrac - 1))
            leg.hor = FALSE
        }
    }
    layout(ll, width = ll.width, height = ll.height, respect = TRUE)
    par(mar = margin)
    ##cat(par()$mar,"\n")
    par(mar=c(11,4.1,4.1,11))
    image(1:ncol(x), 1:nrow(x), t(x), axes = FALSE, xlim = c(0.5, 
        ncol(x) + 0.5), ylim = c(0.5, nrow(x) + 0.5), xlab = "", 
        ylab = "", col = col, ...)
    if (do.xaxis) {
        axis(1, 1:ncol(x), las = 2, line = -0.5, tick = 0, labels = colnames(x), 
            cex.axis = c.cex)
    }
    if (do.yaxis) {
      axis(4, 1:nrow(x), las = 2, line = -0.5, tick = 0, labels = rownames(x), 
            cex.axis = r.cex)
    }
    if (!missing(add.expr)) 
        eval(substitute(add.expr))
    if (do.dendro[1]) {
        mm = margin
        mm[2] = 3
        mm[4] = 0
        par(mar = mm)
        plot(ddr, horiz = TRUE, axes = FALSE, yaxs = "i", leaflab = "none")
    }
    if (do.dendro[2]) {
        mm = margin
        mm[1] = 0
        mm[3] = 3
        par(mar = mm)
        plot(ddc, axes = FALSE, xaxs = "i", leaflab = "none")
    }
    if (legend %in% 1:4) {
        dummy.x <- seq(min(x, na.rm = TRUE), max(x, na.rm = TRUE), 
            length = length(col))
        dummy.z <- matrix(dummy.x, ncol = 1)
        if (leg.hor) {
            par(mar = c(2, margin[2], 2, margin[4]))
            image(x = dummy.x, y = 1, z = dummy.z, yaxt = "n", 
                col = col)
        }
        else {
            par(mar = c(margin[1], 2, margin[3], 2))
            image(x = 1, y = dummy.x, z = t(dummy.z), xaxt = "n", 
                col = col)
        }
    }
    invisible(list(rowInd = rowInd, colInd = colInd))
}
