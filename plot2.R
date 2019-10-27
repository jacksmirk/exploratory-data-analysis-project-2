# Download and unzip the data if not present
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
  
  # Sum the emissions per year
  baltimoreTotalEmissionsPerYear <- aggregate(baltimorePM25$Emissions, by=list(year=baltimorePM25$year), FUN=sum)
  names(baltimoreTotalEmissionsPerYear)[2] <- 'emissions' 
  
  # Initialize device png 480x480
  png("plot2.png", width = 480, height = 480)
  
  # Generate plot
  with(baltimoreTotalEmissionsPerYear, plot(year, emissions, type = 'l'))
  
  # Close device
  dev.off()
}