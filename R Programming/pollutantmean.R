 pollutantmean <- function(directory, pollutant, id = 1:332) {
  acc <- NA
  for(i in id)
  {
    path <- file.path(directory,sprintf("%03d.csv",i))
    data = read.csv(path)
    acc <- rbind(acc,data)
  }
  mean(acc[[pollutant]],na.rm=TRUE)
}

print(pollutantmean("specdata", "sulfate", 1:10))