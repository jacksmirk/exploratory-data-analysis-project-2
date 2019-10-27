# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable,
# which of these four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008?
# Use the ggplot2 plotting system to make a plot answer this question.
# Download and unzip the data
library(ggplot2)
library(dplyr)
if (!"summarySCC_PM25.rds" %in% dir() || !"Source_Classification_Code.rds" %in% dir()) {
  link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(link, "data_for_peer_assessment.zip")
  unzip("data_for_peer_assessment.zip")
}

if ("summarySCC_PM25.rds" %in% dir()) {
  # Import the data
  if (!exists("NEI")) {
    NEI <- readRDS("summarySCC_PM25.rds")
  }

  # Subset Baltimore data
  baltimorePM25 <- subset(NEI, fips == "24510")
  
  # Sum the emissions per year and type
  baltimoreTotalEmissionsPerYearAndType <- aggregate(baltimorePM25$Emissions, by=list(year=baltimorePM25$year, type=baltimorePM25$type), FUN=sum)
  names(baltimoreTotalEmissionsPerYearAndType)[3] <- 'emissions'

  # Initialize device png 640x480
  png("plot3.png", width = 640, height = 480)
  
  # Generate plot
  print(qplot(year, log(emissions), data = baltimoreTotalEmissionsPerYearAndType, facets = . ~ type, main = "Baltimore emissions by type from 1999 to 2008") + geom_smooth(method = "lm"))

  # Close device
  dev.off()
}