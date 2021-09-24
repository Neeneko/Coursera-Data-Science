library(dplyr)

best <- function(state, outcome) {
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

  if (!any(data$State == state))
  {
    stop("invalid state")
  }
  data <- data %>% filter((!!sym(colName)) != "Not Available") %>% mutate(!!sym(colName) := as.numeric(!!sym(colName)))
  #data[,colName] <- as.numeric(data[,colName])
  
  
  #print(colName)
  ## Return hospital name in that state with lowest 30-day death rate
  #print(data[colName])
  #subset <- data %>% filter(State == state) %>% summarize(name=Hospital.Name[which(colName == min(colName))],value=min(colName))
  #print(subset)
  subset <- data %>% 
      filter(State == state) %>% 
      filter(!is.na(!!as.symbol(colName))) %>% 
      slice_min(!!as.symbol(colName),with_ties=TRUE) %>% 
      slice_min(Hospital.Name)
  print(subset$Hospital.Name)
  #print(subset[colName])
  
}

best("TX","heart attack")
best("TX", "heart failure")
best("MD", "heart attack")
best("MD", "pneumonia")

#best("BB","heart attack")
#best("NY","hert attack")