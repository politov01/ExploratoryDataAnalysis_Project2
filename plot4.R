
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

# Coal combustion related sources
coalCombustion <- grep("coal", SCC$Short.Name, ignore.case = TRUE)
combustionSCC <- SCC[coalCombustion,]$SCC
combustionNEI <- NEI[NEI$SCC %in% combustionSCC,]


# group by year
totalEmissions <- aggregate(Emissions ~ year, data=combustionNEI, FUN=sum)
totalEmissions
#  year Emissions
# 1999  602.6241
# 2002  564.9400
# 2005  569.6547
# 2008  358.0839

#create plot
g <- ggplot(data=totalEmissions, aes(x=factor(year), y=Emissions))  
g + geom_bar(stat="identity",fill="grey",width=0.75) + 
    geom_text(aes(label=round(Emissions,1), size=1, vjust=2)) +
    ggtitle("Total United States PM2.5 Coal Emissions") +
    ylab(expression("Emissions (thousands of tons)"))  + 
    xlab('Year') +
    theme(legend.position='none') 

#save to PNG
dev.copy(png, file="plot4.png", width=720, height=480) 
# Close the PNG device
dev.off() 
