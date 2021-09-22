complete <- function(directory, id = 1:332) {
 
  ids <- vector()
  nobs <- vector()
  
  for(i in id)
  {
    path <- file.path(directory,sprintf("%03d.csv",i))
    data = read.csv(path)
    
    ids = c(ids,i)
    nobs = c(nobs,sum(complete.cases(data)))   
    
  }
  data.frame(id=ids,nobs=nobs)
}

print(complete("specdata", 1))
print(complete("specdata", c(2, 4, 8, 10, 12)))