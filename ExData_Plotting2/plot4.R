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
##Extract the data set with 'Emissions' from coal combustion-related sources 
is.coalcomb<-grep("Fuel Comb.*Coal",SCC$EI.Sector)
CoalCombSources<-SCC[is.coalcomb,]
Emissions_Coal<-merge(x=NEI,y=CoalCombSources,by='SCC')
library(plyr)
##aggregate the 'Emissions' (from coal combustion-related sources in the United States) by year
library(plyr)
Emissions_CoalbyYear<-ddply(Emissions_Coal,.(year), summarize, total.emissions = sum(Emissions))
##change the units of the variable 'total.emissions' to kilotons
Emissions_CoalbyYear$total.emissions<-round(Emissions_CoalbyYear[,2]/1000,2)
##open the PNG file device in the working directory
png(filename="plot4.png",width=480,height=480,units="px")
##plot the 'Total PM2.5 Emissions from the coal combustion-related sources in the United States'
##across the years 1999-2008 using the ggplot2 plotting system
library(ggplot2)
g<-ggplot(Emissions_CoalbyYear,aes(x=factor(year),total.emissions))
g+geom_bar(stat="identity", color="black", fill = "darkcyan")+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in kilotons)"))+
  labs(title=expression("PM"[2.5]* " Emissions from Coal Combustion-Related Sources"))+geom_text(aes(label=round(total.emissions,0),vjust=2))+theme_bw()
##close the PNG file device
dev.off()
