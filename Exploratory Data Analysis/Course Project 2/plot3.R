library(dplyr)
library(ggplot2)
source("LoadData.R")
outFile <- "plot3.png"

data <- NEIData %>% filter(fips == "24510") %>% group_by(year,type) %>% summarise(Emissions = sum(Emissions))

png(outFile, width=480, height=480)
plot <- ggplot(data,aes(factor(year),Emissions)) + geom_bar(stat="identity")
plot <- plot + facet_wrap(~ type)
plot <- plot + labs(title = "Emissions in Baltimore by Type")
plot <- plot + labs(x = 'Year')
print(plot)
dev.off()