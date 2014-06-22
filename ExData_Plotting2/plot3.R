if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
NEI_MD<-subset(NEI,NEI$fips=="24510")
library(plyr)
Emissions_MD<-ddply(NEI_MD,.(year,type), summarize, total.emissions = sum(Emissions))
png(filename="plot3.png",width=640,height=640,units="px")
library(ggplot2)
g<-ggplot(Emissions_MD,aes(x=factor(year),total.emissions, fill = type))
g+geom_bar(stat="identity")+facet_grid(.~type)+xlab("Year")+ylab(expression("Total PM"[2.5]* " Emissions (in tons)"))+
  labs(title=expression("PM"[2.5]* " Emissions in Baltimore City, MD by Various Source Type"))
dev.off()