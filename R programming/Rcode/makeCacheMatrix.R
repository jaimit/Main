makeCacheMatrix <- function(x = matrix()) {
    invmatrix <- NULL
    set <- function(y) {
        x <<- y
        invmatrix <<- NULL
    }
    get <- function() x
    setinverse <- function(invm) invmatrix <<- invm
    getinverse <- function() invmatrix
    list(set = set, get = get,
         setinverse = setinverse,
         getinverse = getinverse)
}