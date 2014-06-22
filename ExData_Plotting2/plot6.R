if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
is.motorvehicle<-grep("Mobile.*Road",SCC$EI.Sector,ignore.case=TRUE)
MotorVehicle<-SCC[is.motorvehicle,]
Emissions_Mv<-NEI[(NEI$SCC %in% MotorVehicle$SCC),]
Emissions_MvMDC<-subset(Emissions_Mv,Emissions_Mv$fips=="24510" | Emissions_Mv$fips== "06037")
library(plyr)
Emissions_MvbyLoc<-ddply(Emissions_MvMDC,.(year,fips), summarize, total.emissions = sum(Emissions))
Emissions_MvbyLoc$city[Emissions_MvbyLoc$fips=="06037"]<-"Los Angeles County, CA"
Emissions_MvbyLoc$city[Emissions_MvbyLoc$fips=="24510"]<-"Baltimore City, MD"
png(filename="plot6.png",width=480,height=480,units="px")
library(ggplot2)
g<-ggplot(Emissions_MvbyLoc,aes(x=factor(year),total.emissions))
g+geom_point(aes(color = city))+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("Total Emissions from Motor Vehicles Sources\nBaltimore City, MD v/s Los Angeles County, CA"))+
  geom_text(aes(label=round(total.emissions,0),vjust=1.2))
dev.off()