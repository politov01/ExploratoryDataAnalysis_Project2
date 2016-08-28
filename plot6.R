

# Check if the data is downloaded and download when applicable
if(!file.exists("data"))
  {dir.create("data")
  }
if(!file.exists(file.path("data","summarySCC_PM25.rds")) |
   !file.exists(file.path("data","Source_Classification_Code.rds")))
  {fileUrl <- "http://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
   download.file(fileUrl, destfile = file.path("data", "exdata_data_NEI_data.zip"), mode = "wb")
   unzip(zipfile=file.path("data","exdata_data_NEI_data.zip"), exdir=file.path("data") )
  }

#load required libraries
library(plyr)
library(ggplot2)
library(data.table)

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS(file.path("data","summarySCC_PM25.rds"))
SCC <- readRDS(file.path("data","Source_Classification_Code.rds"))


# Get Baltimore emissions from motor vehicle sources
baltimoreONROAD <- NEI[(NEI$fips=="24510") & (NEI$type=="ON-ROAD"),]

# Get Los Angeles emissions from motor vehicle sources
LosAngelesONROAD <- NEI[(NEI$fips=="06037") & (NEI$type=="ON-ROAD"),]

# aggregate total emissions from motor vehicle sources in Baltimore by year 
totalEmissionsBaltimore <- ddply(baltimoreONROAD, .(year), summarize, Emissions=sum(Emissions)) 
totalEmissionsBaltimore$County <- "Baltimore City, MD"
totalEmissionsBaltimore

# aggregate total emissions from motor vehicle sources in Los Angeles by year 
totalEmissionsLosAngeles <- ddply(LosAngelesONROAD, .(year), summarize, Emissions=sum(Emissions)) 
totalEmissionsLosAngeles$County <- "Los Angeles County, CA"
totalEmissionsLosAngeles

# aggregate total emissions from motor vehicle sources by year and county 
bothEmissions <- rbind(totalEmissionsBaltimore, totalEmissionsLosAngeles)
bothEmissions

#create plot with linear regression
g <- ggplot(data=bothEmissions, aes(x=year, y=Emissions, group=County, color=County))
g + geom_line() + 
    geom_point( size=4, shape=21, fill="white") + 
    geom_smooth(method="lm") +
    xlab("Year") + 
    ylab("Emissions ") + 
    ggtitle("Baltimore vs Los Angeles")

#save to PNG
dev.copy(png, file="plot6.png", width=720, height=480) 
# Close the PNG device
dev.off() 
