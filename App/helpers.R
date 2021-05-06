library(tidyverse)
library(ggplot2)


#' lags a matrix/vector adds padding and keeps names
lag_ <- function(x, n = 1L){
  stopifnot(is.numeric(x))
  if(!is.matrix(x)) {
    m <- c(rep(NA, n), x[1:(length(x)-n)])
  }
  if(is.matrix(x)) {
    m <- rbind(matrix(nrow = n, ncol = ncol(x)), x[1:(nrow(x) - n), ])
    colnames(m) <- paste0(colnames(x), ".L", n)
  }
  m
}

#' Creates a lag matrix and keeps column names of matrix
lag_matrix <- function(mat, lags = 1){
  lag_mat <- lapply(lags, function(x) lag_(mat, n = x))
  l_mat <- do.call(cbind, lag_mat)
  l_mat
}

#' Granger Causality test 
granger_test <- function(from, to, data, p){
  stopifnot(is.character(from))
  stopifnot(is.character(to))
  stopifnot(p >= 1)
  y <- data[, to]
  from_all_lags <- paste0(from, ".L",  1:p)
  lagged_data <- lag_matrix(data, lags = 1:p)
  datamat_full <- cbind(y, lagged_data)
  datamat_restricted <- datamat_full[, !colnames(datamat_full) %in% from_all_lags]
  mod_full <- lm(y ~ -1 + ., data = as.data.frame(datamat_full))
  mod_rest <- lm(y ~ -1 + ., data = as.data.frame(datamat_restricted))
  ssr_full <- sum(mod_full$residuals^2)
  ssr_rest <- sum(mod_rest$residuals^2)
  df1 <- p
  df2 <- (nrow(datamat_full)- p - ncol(lagged_data))
  F_test <- ((ssr_rest - ssr_full)/df1) / (ssr_full / df2)
  p_val <- 1-pf(F_test, df1, df2)
  
  list(from = from,
       to = to,
       ssr_full = ssr_full,
       ssr_rest = ssr_rest,
       F_test = F_test,
       p_val = p_val,
       datamat_full = datamat_full,
       datamat_rest = datamat_restricted)
}


#' Simulates a VAR(p) model
#' 
#' Takes a coefficient matrix in the companion form and 
#' simulates a VAR(p) using this coefficient matrix
#' 
#' @param periods number of time periods
#' @param N number of time series
#' @param coef_mat coefficient matrix in companion form: defaults to drawing a 
#' random one
#' @param e_dist distribution of errors: defaults to iid normal
#' @param init_y initial y values
#' @param max_eigval if < 1 then var will be stable
#' @param ... further parameters passed on to e_dist 
sim_VAR <- function(periods = 100, N = 3, 
                    coef_mat = NULL, e_dist = rnorm,
                    init_y = NULL,
                    max_eigval = 0.99,
                    burnin = 100,
                    ...){
  
  if (is.null(coef_mat)) {
    coef_mat <- create_rand_coef_mat(N = N, p = 3, 
                                     max_eigval = max_eigval,
                                     ...)
  }
  p <- ncol(coef_mat)/N
  if (is.null(init_y)){
    init_y <-  rep(0, N*p)
  }
  Y_tmp <- matrix(nrow = periods+1+burnin, ncol = N*p)
  Y_tmp[1, ] <- init_y
  for (t in 2:(periods+1+burnin)){
    nu <- c(e_dist(N, ...), rep(0, N*(p-1)))
    Y_tmp[t, ] <- (coef_mat%*%Y_tmp[t-1,] + nu)
  }
  
  Y <- Y_tmp[(nrow(Y_tmp)-periods):nrow(Y_tmp), 1:N]
  colnames(Y) <- paste0("Y", 1:N)
  Y
}


#' Creates a random coefficient matrix
#' @param N number of time series
#' @param p number of lags
#' @param dist distribution to draw coefficients from
#' @param max_eigval if < 1, then var will be stable
#' @param ... additional arguments forwarded to dist
create_rand_coef_mat <- function(N = 3, p = 2,
                                 dist = runif,
                                 max_eigval = 0.99,
                                 ...){
  phis <- matrix(nrow = N, ncol = p*N)
  for (i in 1:p){
    start <- ((i-1)*N + 1)
    end <- i*N
    phis[, start:end] <- matrix(dist(N*N, ...), 
                                nrow = N, ncol = N)
  }
  I <- diag(1, nrow = N*(p-1), N*(p-1))
  O <- matrix(0, nrow = N*(p-1), ncol = N)
  coef_mat <- rbind(phis, cbind(I, O))
  while (max(abs(eigen(coef_mat)$values))>max_eigval) {
   phis <- phis*0.9 
   coef_mat <- rbind(phis, cbind(I, O))
  }
  coef_mat
}


##### Theming
colours <- c(
  "dark-blue"= rgb(0, 28, 61, maxColorValue = 255),
  "light-blue"= rgb(0,162,219, maxColorValue = 255),
  "red"= rgb(174,11,18, maxColorValue = 255),
  "orange-red"= rgb(232,78,16, maxColorValue = 255),
  "orange"= rgb(243,148,37, maxColorValue = 255)
)
um_cols <- function(...) {
  cols <- c(...)
  if (is.null(cols)){
    return(colours)
  }
  colours[cols]
}
colour_palettes <- list(
  `main` = um_cols(),
  `cold` = um_cols("dark-blue", "ligth-blue"),
  `warm` = um_cols("orange", "orange-red", "red")
)
um_pal <- function(palette = "main", reverse = FALSE, ...) {
  pal <- colour_palettes[[palette]]
  if (reverse) pal <- rev(pal)
  colorRampPalette(pal, ...)
}
scale_color_um <- function(palette = "main", discrete = TRUE,
                           reverse = FALSE, ...) {
  pal <- um_pal(palette = palette, reverse = reverse, ...)
  if (discrete) {
    discrete_scale("colour", paste0("um_", palette), palette = pal, ...)
  }
  else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}
scale_fill_um <- function(palette = "main", discrete = TRUE, 
                          reverse = FALSE, ...) {
  pal <- um_pal(palette = palette, reverse = reverse, ...)
  if (discrete){
    discrete_scale("fill", paste0("um_", palette), palette = pal, ...)
  }
  else {
    scale_fill_gradientn(colours = pal(256), ...)
  }
}


theme_SnT <- function(){
  font <- "sans"
  font.size <- 15
  update_geom_defaults("line", list(size = 1.2))
  
  theme_bw() %+replace%
    theme(
      panel.grid.major = element_blank(),    #strip major gridlines
      panel.grid.minor = element_blank(),    #strip minor gridlines
      
      plot.title = element_text(             #title
        family = font,            #set font family
        size = 1.5*font.size,                #set font size
        face = 'bold',            #bold typeface
        hjust = 0.5,                #left align
        vjust = 2),               #raise slightly
      plot.subtitle = element_text(          #subtitle
        family = font,            #font family
        size = 1.4*font.size),               #font size
      plot.caption = element_text(           #caption
        family = font,            #font family
        size = 0.7*font.size,                 #font size
        hjust = 1),               #right align
      
      
      axis.title = element_text(             #axis titles
        family = font,            #font family
        size = font.size),               #font size
      axis.text = element_text(              #axis text
        family = font,            #axis famuly
        size = font.size),                #font size
      axis.text.x = element_text(            #margin for axis text
        margin=margin(5, b = 10)),
      
      axis.line = element_line(colour = um_cols("dark-blue"),    # Adding axis lines
                               size = 1, 
                               linetype = "solid",
                               lineend = "round"),
      axis.ticks = element_line(colour = um_cols("dark-blue"),
                                size = 1),
      axis.ticks.length = unit(5, "points"),
      
      legend.position = "top",
      legend.text = element_text(size = font.size),
      legend.box = "vertical",
      text = element_text(size = font.size),
      panel.border = element_blank()
    )
}
