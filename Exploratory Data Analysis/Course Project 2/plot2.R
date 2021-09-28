library(dplyr)
source("LoadData.R")
outFile <- "plot2.png"

data <- NEIData %>% filter(fips == "24510") %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

png(outFile, width=480, height=480)
barplot(data$Emissions
        , names = data$year
        , xlab = "Years", ylab = "Emissions"
        , main = "Emissions in Baltimore, MD by Year")
dev.off()