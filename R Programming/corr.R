corr <- function(directory, threshhold=0) {
  path <- file.path(directory)

  rv <- vector()
  for (i in 1:322)
  {
    path <- file.path(directory,sprintf("%03d.csv",i))
    data = read.csv(path)
    if (sum(complete.cases(data)) <= threshhold)
    {
      next
    }
    rv <- c(rv,cor(data$nitrate,data$sulfate,"complete.obs"))
  }
  return(rv)
}
print(head(corr("specdata",150)))