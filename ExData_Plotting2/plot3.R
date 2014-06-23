##check in the working directory if the source files exist and then download it, if otherwise
if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
##read the contents of the first source file in the data set NEI
NEI <- readRDS("summarySCC_PM25.rds")
##read the contents of the other source file in the data set SCC
SCC <- readRDS("Source_Classification_Code.rds")
##use subset function to extract the contents of only Baltimore City and name the data set as 'NEI_MD'
NEI_MD<-subset(NEI,NEI$fips=="24510")
##aggregate the 'Emissions' (in the Baltimore City, MD) by year and source type
library(plyr)
Emissions_MD<-ddply(NEI_MD,.(year,type), summarize, total.emissions = sum(Emissions))
##open the PNG file device in the working directory
png(filename="plot3.png",width=640,height=640,units="px")
#plot the 'Total PM2.5 Emissions in the Baltimore City,MD' by the various source type
##across the years 1999-2008 using the ggplot2 plotting system
library(ggplot2)
g<-ggplot(Emissions_MD,aes(x=factor(year),total.emissions, fill = type))
g+geom_bar(stat="identity")+facet_grid(.~type)+xlab("Year")+ylab(expression("Total PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("PM"[2.5]* " Emissions in Baltimore City, MD by Various Source Type"))
##close the PNG file device
dev.off()
