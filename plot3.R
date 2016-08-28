
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

# narrow the emissions data to Baltimore City, Maryland 
baltimore <- NEI[NEI$fips == "24510", ] 


baltimore.type <- ddply(baltimore, .(type, year), summarize, Emissions = sum(Emissions))
baltimore.type
#       type year  Emissions
#1  NON-ROAD 1999 0.52294000
#2  NON-ROAD 2002 0.24084692
#3  NON-ROAD 2005 0.24893369
#4  NON-ROAD 2008 0.05582356
#5  NONPOINT 1999 2.10762500
#6  NONPOINT 2002 1.50950000
#7  NONPOINT 2005 1.50950000
#8  NONPOINT 2008 1.37320731
#9   ON-ROAD 1999 0.34682000
#10  ON-ROAD 2002 0.13430882
#11  ON-ROAD 2005 0.13043038
#12  ON-ROAD 2008 0.08827546
#13    POINT 1999 0.29679500
#14    POINT 2002 0.56926000
#15    POINT 2005 1.20249000
#16    POINT 2008 0.34497518


#create plot
#Create the plot
g <- ggplot(data=baltimore.type, aes(x=year, y=Emissions, group=type, color=type))
g + geom_line() + 
    geom_point( size=4, shape=21, fill="white") + 
    xlab("Year") + 
    ylab("Emissions (thousands of tons)") + 
    ggtitle("Baltimore Emissions PM2.5 by Type and Year")

#save to PNG
dev.copy(png, file="plot3.png", width=720, height=480) 
# Close the PNG device
dev.off() 
