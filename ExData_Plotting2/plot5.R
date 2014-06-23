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
##use subset function to extract the contents of only Baltimore City and name the data set as 'Emissions_MvMD'
Emissions_MvMD<-subset(Emissions_Mv,Emissions_Mv$fips=="24510")
##aggregate the 'Emissions' (from the motor vehicle sources in the Baltimore City, MD) by year
library(plyr)
Emissions_MvMDbyYear<-ddply(Emissions_MvMD,.(year), summarize, total.emissions = sum(Emissions))
##open the PNG file device in the working directory
png(filename="plot5.png",width=480,height=480,units="px")
##plot the 'Total PM2.5 Emissions from the motor vehicle sources in the Baltimore City, MD'
##across the years 1999-2008 using the ggplot2 plotting system
library(ggplot2)
g<-ggplot(Emissions_MvMDbyYear,aes(x=factor(year),total.emissions))
g+geom_bar(stat="identity", color="black", fill = "orangered")+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("PM"[2.5]* " Emissions from Motor Vehicles Sources in Baltimore City, MD"))+geom_text(aes(label=round(total.emissions,0), vjust=2))+theme_bw()
##close the PNG file device
dev.off()
