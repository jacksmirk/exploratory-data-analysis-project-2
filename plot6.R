# Compare emissions from motor vehicle sources in Baltimore City with emissions from motor vehicle sources in Los Angeles County, California (fips=="06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
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

  # Subset Baltimore and LA data
  BaltLASubset <- subset(NEI, fips == "24510" | fips == "06037")

  # Name the cities
  citiesNEI <- mutate(BaltLASubset, city = ifelse(fips == "24510", "Baltimore City", "Los Angeles County"))

  # Get the motor vehicles SCC
  motorVehiclesSCC <- subset(SCC, endsWith(as.character(EI.Sector), "Vehicles"), select = "SCC")

  # Subset data from motor vehicles
  citiesMVEmissions <- subset(citiesNEI, SCC %in% motorVehiclesSCC$SCC, select = c("year", "Emissions", "city"))

  # Get total emissions per year
  totalCitiesMVEmissions <- aggregate(citiesMVEmissions$Emissions, by=list(year=citiesMVEmissions$year, city=citiesMVEmissions$city), FUN=sum)
  names(totalCitiesMVEmissions)[3] <- "Emissions"

  # Initialize device png 640x480
  png("plot6.png", width = 1024, height = 768)

  # Print the plot
  g <- ggplot(totalCitiesMVEmissions, aes(x=year, y=log(Emissions), colour = factor(city)))
  g <- g + geom_path(data = subset(totalCitiesMVEmissions, city == "Baltimore City")) 
  g <- g + geom_path(data = subset(totalCitiesMVEmissions, city == "Los Angeles County")) 
  g <- g + labs(title = "Motor vehicle emissions in Los Angeles County and Baltimore City from 1999 to 2008", color = "Cities")
  print(g)
  
  # Close device
  dev.off()
}