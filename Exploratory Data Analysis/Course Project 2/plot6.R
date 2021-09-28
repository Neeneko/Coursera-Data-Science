library(dplyr)
library(ggplot2)
source("LoadData.R")
outFile <- "plot6.png"


data <- NEIData %>% 
  filter(fips %in% c("24510","06037")) %>% 
  filter(type == "ON-ROAD") %>%
  mutate(county=case_when(
            fips == "24510" ~ "Baltimore City",
            fips == "06037" ~ " Los Angeles County")) %>%
  group_by(year,county) %>% 
  summarise(Emissions = sum(Emissions)) %>% 
  ungroup() %>% 
  group_by(county) %>%
  mutate(lag = lag(Emissions,by='year')) %>%
  mutate(percent.change = 100*(Emissions - lag)/lag) %>% replace(is.na(.), 0)


png(outFile, width=480, height=480)
plot <- ggplot(data,aes(factor(year),percent.change)) + geom_bar(stat="identity")
plot <- plot + facet_wrap(~ county)
plot <- plot + labs(title = "On Road Emissions by County")
plot <- plot + labs(x = 'Year')
plot <- plot + labs(y = 'Percentage Change')
print(plot)
dev.off()