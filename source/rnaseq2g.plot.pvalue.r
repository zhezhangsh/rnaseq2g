rnaseq2g.plot.pvalue <- function(res, nm1, nm2, typ, top, mth) {
  require(plotly);
  if (!is.null(res)) {
    if (nm1=='' | nm2=='') plotly_empty(type='scatter', mode='markers') else {
      p1 <- res[[2]][[nm1]][, 5]; 
      p2 <- res[[2]][[nm2]][, 5]; 
      p1[is.na(p1)] <- 1;
      p2[is.na(p2)] <- 1;
      
      # par(mar=c(5,5,2,2)); 

      # Plot Q-Q
      if (typ == '1') {
        if (!identical(top, 'All')) {
          n <- min(length(p1), as.integer(top));
          i <- rev(length(p1):(length(p1)-n+1)); 
        } else i <- rev(length(p1):max(1, (length(p1)-1000+1)));
        
        x  <- sort(-log10(p1));
        y  <- sort(-log10(p2)); 
        lb <- paste('-Log10(p value)', c(mth[nm1, 1], mth[nm2, 1]), sep=', ');
        tt <- paste("#", length(x):1, '. X: ', names(x), ', Y: ', names(y), sep=''); 
        cl <- rep('rgba(16,16,255,.1)', length(x)); 
        mx <- max(c(x, y)); 

        ln <- list(width=10, color='rgba(16,16,255,.3)');
        dd <- data.frame(X=x, Y=y, Txt=tt); 

        plot_ly(data=dd, x=~X, y=~Y, type='scatter', mode='lines', text=~Txt, hoverinfo="text", line=ln) %>%
          add_lines(x=c(0, 1.1*mx), y=c(0, 1.1*mx), text=c('', ''), line=list(width=3, color='#88888888', dash = 'dash')) %>%
          add_markers(x[i], y[i], mode='markers', text=tt[i], marker=list(size=7, color='rgba(255,160,0,.9)')) %>%
          layout(
            showlegend=FALSE, 
            xaxis = list(title=lb[1], range=c(0, 1.05*max(x)), zeroline=FALSE, showgrid=TRUE, showline=TRUE, showticklabels=TRUE),
            yaxis = list(title=lb[2], range=c(0, 1.05*max(y)), zeroline=FALSE, showgrid=TRUE, showline=TRUE, showticklabels=TRUE))
      # Plot ranks
      } else if (typ == '2') {
        rk1 <- rank(p1);
        rk2 <- rank(p2);
        lb  <- paste('Log10(P value ranking)', c(mth[nm1, 1], mth[nm2, 1]), sep=', ');
        len <- length(rk1); 
        lim <- log10(len);
        txt <- paste(names(rk1), ' X: #', rk1, '; ', 'Y: #', rk2, sep=''); 
        sz  <- lim - log10(sqrt(rk1)*sqrt(rk2));
        sz  <- 10*sz/max(sz); 

        if (!identical(top, 'All')) {
          n  <- as.integer(top); 
          s1 <- names(rk1)[rk1<=n];
          s2 <- names(rk2)[rk2<=n];
          z  <- union(s1, s2);
          x <- rk1[z];
          y <- rk2[z];
          col <- rep('', length(z));
          names(col) <- z;
          col[s1] <- 'purple';
          col[s2] <- 'orange';
          col[intersect(s1, s2)] <- 'red'; 
          ind <- which(!(names(rk1) %in% z)); 
        } else ind <- 1:length(rk1); 
        
        p <- PlotlySmoothScatter(log10(rk1), log10(rk2), xlab=lb[1], ylab=lb[2], xlim=c(-.2, lim), ylim=c(-.2, lim), zero.line = c(FALSE, FALSE), 
                                 size=sz, symbol=2, txt=txt, line=list(c(-1, lim+1), c(-1, lim+1))); 
        if (length(ind) < length(rk1)) {
          names(txt) <- names(rk1); 
          p <- add_markers(p, x=log10(rk1[z]), y=log10(rk2[z]), mode='markers', text=txt[z], marker=list(color=col, size=sz[z]));
        }

        p;
      } else {
        rk1 <- rank(p1);
        rk2 <- rank(p2);
        if (identical(top, 'All')) {
          s1 <- s2 <- names(p1);
        } else {
          n  <- pmin(length(p1), as.integer(top));
          s1 <- names(p1)[rk1<=n];
          s2 <- names(p2)[rk2<=n];
        };
        ovl <- intersect(s1, s2); 
        uni <- names(p1);
        
        s0 <- intersect(s1, s2);
        l0 <- length(s0);
        l1 <- length(s1)-l0;
        l2 <- length(s2)-l0;
        l  <- length(uni)-l0-l1-l2;
        nm <- mth[c(nm1, nm2), 1];
        
        x  <- c(1, 2, 3, 2, 1, 3); 
        y  <- c(2, 2, 2, 0.75, 3.25, 3.25);
        tt <- c(l1, l0, l2, l, nm); 
        
        xaxis <- list(title='', range=c(0.5, 3.75), zeroline=FALSE, showgrid=FALSE, showline=FALSE, autotick=FALSE, showticklabels=FALSE);
        yaxis <- list(title='', range=c(0.5, 3.75), zeroline=FALSE, showgrid=FALSE, showline=FALSE, autotick=FALSE, showticklabels=FALSE);
        tfont <- list(family = "sans serif", size = 16, color = toRGB("grey50")); 
        
        shap1 <- list(type='circle', xref='x', yref='y', x0=0.5, x1=2.5, y0=1, y1=3, fillcolor='blue', opacity=0.3, line=list(color='black', width=1)); 
        shap2 <- list(type='circle', xref='x', yref='y', x0=1.5, x1=3.5, y0=1, y1=3, fillcolor='red',  opacity=0.3, line=list(color='black', width=1)); 
        # shap3 <- list(type='rect', xref='x', yref='y', x0=0, x1=4, y0=0, y1=4, fillcolor='none',  opacity=1);
        
        plot_ly(x=x, y=y, type='scatter', mode='text', text=tt, textfont = tfont) %>% 
          layout(shapes=list(shap1, shap2), title=title, showlegend=FALSE, xaxis=xaxis, yaxis=yaxis);
      }
    }
  } else plotly_empty(type='scatter', mode='markers');
}