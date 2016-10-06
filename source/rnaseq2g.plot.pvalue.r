rnaseq2g.plot.pvalue <- function(res, nm1, nm2, typ, top, mth) {
  if (!is.null(res)) {
    if (nm1=='' | nm2=='') plot(0, type='n', axes=FALSE, xlab='', ylab='') else {
      p1 <- res[[2]][[nm1]][, 5]; 
      p2 <- res[[2]][[nm2]][, 5]; 
      p1[is.na(p1)] <- 1;
      p2[is.na(p2)] <- 1;
      
      par(mar=c(5,5,2,2)); 
      if (typ == '1') {
        x  <- sort(-log10(p1));
        y  <- sort(-log10(p2)); 
        lb <- paste('-Log10(p value)', c(mth[nm1, 1], mth[nm2, 1]), sep=', ');
        plot(x, y, pch=18, cex=1, col='#88888888', cex.lab=2, xlab=lb[1], ylab=lb[2]);
        if (!identical(top, 'All')) {
          n <- as.integer(top); 
          x <- rev(x)[1:min(n, length(x))];
          y <- rev(y)[1:min(n, length(y))];
          points(x, y, pch=18, cex=1, col='purple');
        };
        abline(0, 1, col=4, lty=2, lwd=2);
        box();
      } else if (typ == '2') {
        rk1 <- rank(p1);
        rk2 <- rank(p2);
        lb  <- paste('P value ranking', c(mth[nm1, 1], mth[nm2, 1]), sep=', ');
        len <- length(rk1); 
        plot(rk1, rk2, log='xy', pch=18, cex=1, col='#88888888', cex.lab=2, xlab=lb[1], ylab=lb[2], xlim=c(1, len), ylim=c(1, len));
        if (!identical(top, 'All')) {
          n  <- as.integer(top); 
          s1 <- names(rk1)[rk1<=n];
          s2 <- names(rk2)[rk2<=n];
          z  <- union(s1, s2);
          x <- rk1[z];
          y <- rk2[z];
          col <- rep('', length(z));
          names(col) <- z;
          col[s1] <- 'red';
          col[s2] <- 'blue';
          col[intersect(s1, s2)] <- 'purple'; 
          points(x, y, col=col, pch=18, lty=2, lwd=2, cex=1.25); 
        }; 
        abline(0, 1, col=4);
        box();
      } else {
        rk1 <- rank(p1);
        rk2 <- rank(p2);
        if (identical(top, 'All')) {
          s1 <- s2 <- names(p1);
        } else {
          n  <- as.integer(top);
          s1 <- names(p1)[rk1<=n];
          s2 <- names(p2)[rk2<=n];
        };
        uni <- names(p1); 
        PlotVenn(s1, s2, mth[c(nm1, nm2), 1], uni, FALSE, title = 'Top gene overlapping', cex = 2);
      }
    }
  } else plot(0, type='n', axes=FALSE, xlab='', ylab=''); 
}