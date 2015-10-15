cacheSolve <- function(x1, ...) {
    invmatrix1 <- x1$getinverse()
    if(!is.null(invmatrix1)) {
        message("getting cached data")
        return(invmatrix1)
    }
    data <- x1$get()
    invmatrix1 <- solve(data, ...)
    x1$setinverse(invmatrix1)
    invmatrix1
}