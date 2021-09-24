library(dplyr)

rankall <- function(outcome, num = "best") {
  
  data <- read.csv(file.path("Week 4 Data","outcome-of-care-measures.csv"))
  
  ## Read outcome data
  
  colName <- switch(outcome,
                    "heart attack" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack",
                    "heart failure" = "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure",
                    "pneumonia" = "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  )
  
  ## Check that state and outcome are valid
  if (is.null(colName))
  {
    stop("invalid outcome")
  }
  

  data <- data %>% filter((!!sym(colName)) != "Not Available") %>% mutate(!!sym(colName) := as.numeric(!!sym(colName)))
  data <- data %>% group_by(State) %>% 
    arrange(!!sym(colName),Hospital.Name) %>% 
    slice(if_else(num == 'best',1L,if_else(num == 'worst',as.integer(n()),kludge_int(num))))
  
  #print(data)
  rv = data.frame(data$State,data$Hospital.Name)
  names(rv) <- c('state','hospital')
  return(rv)
  
  
  #return(data[,c("State","Hospital.Name")colnames(z) == c('a' , 'b')])
  #print(data[,c("State","Hospital.Name")])
  #data <- data %>% filter(State == state) %>% arrange(!!sym(colName),Hospital.Name)
}

print(head(rankall("heart attack", 20), 10))