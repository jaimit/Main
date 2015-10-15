cachemean <- function(x1, ...) {
    m1 <- x1$getmean()
    if(!is.null(m1)) {
        message("getting cached data")
        return(m1)
    }
    data <- x1$get()
    m1 <- mean(data, ...)
    x1$setmean(m1)
    m1
}