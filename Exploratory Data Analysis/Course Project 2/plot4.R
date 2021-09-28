library(dplyr)
library(ggplot2)
source("LoadData.R")
outFile <- "plot4.png"

sccCoal <- SCCData %>% filter(grepl("Coal",EI.Sector)) 


data <- NEIData %>% filter(SCC %in% sccCoal$SCC) %>% group_by(year) %>% summarise(Emissions = sum(Emissions))

png(outFile, width=480, height=480)
plot <- ggplot(data,aes(factor(year),Emissions)) + geom_bar(stat="identity")
plot <- plot + labs(title = "Emissions fom Coal by Year")
plot <- plot + labs(x = 'Year')
print(plot)
dev.off()

#barplot(data$Emissions
#        , names = data$year
#        , xlab = "Years", ylab = "Emissions"
#        , main = "Emissions fom Coal by Year")
#dev.off()