## function makeCacheMatrix - This function creates a special "matrix". 
## Returns list with - 
##     set - to set the values of matrix
##     get - to get the values of matrix
##     setinverse - to set the inverse of matrix
##     getinverse - to get the inverse of matrix
makeCacheMatrix <- function(x = matrix()) {
  mi <- NULL
  set <- function(y) {
    x <<- y
    mi <<- NULL
  }
  get <- function() x
  setinverse <- function(inverse) mi <<- inverse
  getinverse <- function() mi
  list(set = set, get = get,
       setinverse = setinverse,
       getinverse = getinverse
       )
}


## function cacheSolve - create an inverse of special "matrix" created using
## makeCacheMatrix. If inverse alreadys exists then it is returned from cache
cacheSolve <- function(x, ...) {
        ## Return a matrix that is the inverse of 'x'
  mi <- x$getinverse()
  if(!is.null(mi)) {
    message("getting cached matrix inverse data")
    return(mi)
  }
  data <- x$get()
  mi <- solve(data, ...)
  x$setinverse(mi)
  mi
}
