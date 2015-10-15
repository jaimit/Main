add2<-function(x,y){
    x+y
}

above10<-function(x){
    use<-x>10
    x[use]
}

h <- function(x, y = NULL, d = 3L) {
    z <- cbind(x, d)
    if(!is.null(y))
        z <- z + y
    else
        z <- z + f
    g <- x + y / z
    if(d == 3L)
        return(g)
    g <- g + 10
    g
}
