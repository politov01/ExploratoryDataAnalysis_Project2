
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

# aggregate total emissions from motor vehicle sources in Baltimore by year 
totalEmissions <- ddply(baltimoreONROAD, .(year), summarize, Emissions=sum(Emissions)) 
totalEmissions

#create plot
g <- ggplot(data=totalEmissions, aes(x=factor(year), y=Emissions))  
g + geom_bar(stat="identity",fill="grey",width=0.75) + 
    geom_text(aes(label=round(Emissions,1), size=1, vjust=2)) +
    ggtitle("Emissions from motor vehicle sources in Baltimore City") +
    ylab(expression("Total Emissions PM2.5 (tons)"))  + 
    xlab('Year') +
    theme(legend.position='none') 


#save to PNG
dev.copy(png, file="plot5.png", width=720, height=480) 
# Close the PNG device
dev.off() 
