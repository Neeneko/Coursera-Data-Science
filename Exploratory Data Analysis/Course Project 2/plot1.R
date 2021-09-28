library(dplyr)
source("LoadData.R")
outFile <- "plot1.png"

data <- NEIData %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

png(outFile, width=480, height=480)
barplot(data$Emissions
        , names = data$year
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions By Year")
dev.off()