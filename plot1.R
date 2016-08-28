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

#converted to "thousands of tons" for easier plotting
NEI$Emissions <- NEI$Emissions/1000

# aggregate total emissions from all sources by year
totalEmissions  <- with(NEI, aggregate(Emissions, by = list(year), sum))


#Create the plot
plot(totalEmissions, type = "b", pch = 18, col = "green", ylab = "Emissions (thousands of tons)", 
     xaxt="n", xlab = "Year", main = "Annual Emissions")
axis(side=1, at=c("1999", "2002", "2005", "2008"))

#save to PNG
dev.copy(png, file="plot1.png", width=720, height=480) 
# Close the PNG device
dev.off() 
