# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
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

  # Subset Baltimore data
  baltimorePM25 <- subset(NEI, fips == "24510")

  # Get the motor vehicles SCC
  motorVehiclesSCC <- subset(SCC, endsWith(as.character(EI.Sector), "Vehicles"), select = "SCC")

  # Subset data from motor vehicles
  baltMVEmissions <- subset(baltimorePM25, SCC %in% motorVehiclesSCC$SCC, select = c("year", "Emissions"))

  # Get total emissions per year
  totalBaltMVEmissions <- aggregate(baltMVEmissions$Emissions, by=list(year=baltMVEmissions$year), FUN=sum)
  names(totalBaltMVEmissions)[2] <- "Emissions"

  # Initialize device png 640x480
  png("plot5.png", width = 640, height = 480)

  # Print the plot
  print(qplot(year, Emissions, data = totalBaltMVEmissions, geom = c("point","path"), main = "Motor Vehicles emissions in Baltimore City from 1999 to 2008"))
  
  # Close device
  dev.off()
}