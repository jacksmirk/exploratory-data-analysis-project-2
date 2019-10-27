# Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
library(ggplot2)
library(dplyr)
if (!"summarySCC_PM25.rds" %in% dir() || !"Source_Classification_Code.rds" %in% dir()) {
  link <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(link, "data_for_peer_assessment.zip")
  unzip("data_for_peer_assessment.zip")
}

if ("summarySCC_PM25.rds" %in% dir() && "Source_Classification_Code.rds" %in% dir()) {
  # Import the data
  if (!exists("NEI")) {
    NEI <- readRDS("summarySCC_PM25.rds")
  }
  if (!exists("SCC")) {
    SCC <- readRDS("Source_Classification_Code.rds")
  }

  # Get all the data relative to "Coal Combustion"
  # which means all the data from EI.Sector that starts with "Fuel Comb" and ends with "Coal"
  startsWithFC <- subset(SCC, startsWith(as.character(EI.Sector), c("Fuel Comb")), select = c("SCC","EI.Sector"))
  startsWithFCandEndsWithCoal <- subset(startsWithFC, endsWith(as.character(EI.Sector), c("Coal")))
  coalCombNEI <- NEI[NEI$SCC %in% startsWithFCandEndsWithCoal$SCC,]
  
  # Get the total emissions per year
  totalCoalCombNEI <- aggregate(coalCombNEI$Emissions, by=list(year=coalCombNEI$year), FUN=sum)
  names(totalCoalCombNEI)[2] <- "Emissions"

  # Initialize device png 640x480
  png("plot4.png", width = 640, height = 480)

  # Print the plot
  print(qplot(year, Emissions, data = totalCoalCombNEI, geom = c("point","path"), main = "Coal Combustion across USA"))

  # Close device
  dev.off()
}