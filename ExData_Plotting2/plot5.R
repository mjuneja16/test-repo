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
Emissions_MvMD<-subset(Emissions_Mv,Emissions_Mv$fips=="24510")
library(plyr)
Emissions_MvMDbyYear<-ddply(Emissions_MvMD,.(year), summarize, total.emissions = sum(Emissions))
png(filename="plot5.png",width=480,height=480,units="px")
library(ggplot2)
g<-ggplot(Emissions_MvMDbyYear,aes(x=factor(year),total.emissions))
g+geom_bar(stat="identity", color="black", fill = "orangered")+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("PM"[2.5]* " Emissions from Motor Vehicles Sources in Baltimore City, MD"))+geom_text(aes(label=round(total.emissions,0), vjust=2))+theme_bw()
dev.off()