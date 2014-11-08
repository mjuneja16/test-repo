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
##Extract the data set with 'Emissions' from motor vehicle sources which include both On-Road and Off-Road vehicles 
is.motorvehicle<-grep("Mobile.*Road",SCC$EI.Sector,ignore.case=TRUE)
MotorVehicle<-SCC[is.motorvehicle,]
Emissions_Mv<-NEI[(NEI$SCC %in% MotorVehicle$SCC),]
##use subset function to extract the contents of Baltimore City & Log Angeles County and name the data set as 'Emissions_MvMDC'
Emissions_MvMDC<-subset(Emissions_Mv,Emissions_Mv$fips=="24510" | Emissions_Mv$fips== "06037")
##aggregate the 'Emissions' (from the motor vehicle sources in the Baltimore City & Log Angeles County) by year and fips(city)
library(plyr)
Emissions_MvbyLoc<-ddply(Emissions_MvMDC,.(year,fips), summarize, total.emissions = sum(Emissions))
##add column variable 'city' to the data set 'Emissions_MvbyLoc' and provide city names in accordance with the fips'
Emissions_MvbyLoc$city[Emissions_MvbyLoc$fips=="06037"]<-"Los Angeles County, CA"
Emissions_MvbyLoc$city[Emissions_MvbyLoc$fips=="24510"]<-"Baltimore City, MD"
##open the PNG file device in the working directory
png(filename="plot6.png",width=480,height=480,units="px")
##plot the 'Total PM2.5 Emissions from the motor vehicle sources in the Baltimore City, MD and Los Angeles County, CA'
##across the years 1999-2008 using the ggplot2 plotting system
library(ggplot2)
g<-ggplot(Emissions_MvbyLoc,aes(x=factor(year),total.emissions))
g+geom_point(aes(color = city))+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("Total Emissions from Motor Vehicles Sources\nBaltimore City, MD v/s Los Angeles County, CA"))+
  geom_text(aes(label=round(total.emissions,0),vjust=1.2))
##close the PNG file device
dev.off()
