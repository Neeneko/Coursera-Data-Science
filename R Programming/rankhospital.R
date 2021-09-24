library(dplyr)

kludge_int <- function(value)
{
  if (is.numeric(value))
  {
    return(as.integer(value))
  }
  else
  {
    return(0L)
  }
}

rankhospital <- function(state, outcome, num = "best") {
  
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
    data <- data %>% filter(State == state) %>% 
      arrange(!!sym(colName),Hospital.Name) %>% 
      slice(if_else(num == 'best',1L,if_else(num == 'worst',as.integer(n()),kludge_int(num))))

    if(nrow(data) == 0)
      print(NA)
    else                                                                                  
      print(data$Hospital.Name)
    
}
rankhospital("NC", "heart attack", "worst")
rankhospital("TX", "heart failure", 4)
#rankhospital("MD", "heart attack", "best")

rankhospital("MD", "heart attack", "worst")
rankhospital("MN", "heart attack", 5000)
