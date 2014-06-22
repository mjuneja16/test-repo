if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
is.coalcomb<-grep("Fuel Comb.*Coal",SCC$EI.Sector)
CoalCombSources<-SCC[is.coalcomb,]
Emissions_Coal<-merge(x=NEI,y=CoalCombSources,by='SCC')
library(plyr)
Emissions_CoalbyYear<-ddply(Emissions_Coal,.(year), summarize, total.emissions = sum(Emissions))
Emissions_CoalbyYear$total.emissions<-round(Emissions_CoalbyYear[,2]/1000,2)
png(filename="plot4.png",width=480,height=480,units="px")
library(ggplot2)
g<-ggplot(Emissions_CoalbyYear,aes(x=factor(year),total.emissions))
g+geom_bar(stat="identity", color="black", fill = "darkcyan")+xlab("Year")+ylab(expression("PM"[2.5]* " Emissions (in kilotons)"))+
  labs(title=expression("PM"[2.5]* " Emissions from Coal Combustion-Related Sources"))+geom_text(aes(label=round(total.emissions,0),vjust=2))+theme_bw()
dev.off()