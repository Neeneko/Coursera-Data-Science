library(dplyr)
library(ggplot2)
source("LoadData.R")
outFile <- "plot5.png"

data <- NEIData %>% 
  filter(type == "ON-ROAD") %>% 
  filter(fips == "24510") %>%
  group_by(year,type) %>% 
  summarise(Emissions = sum(Emissions))

png(outFile, width=480, height=480)
plot <- ggplot(data,aes(factor(year),Emissions)) + geom_bar(stat="identity")
plot <- plot + labs(title = "Emissions in Baltimore for On Road")
plot <- plot + labs(x = 'Year')
print(plot)
dev.off()