if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
NEI_MD<-subset(NEI,NEI$fips=="24510")
Emissions_MD<-aggregate(NEI_MD[,"Emissions"],by=list(NEI_MD$year), FUN = sum)
colnames(Emissions_MD)<-c("Year","Total.Emissions")
Emissions_MD<-transform(Emissions_MD,Year=factor(Year))
png(filename="plot2.png",width=480,height=480,units="px")
par(mar=c(5,5,4,2))
plot(Emissions_MD$Year,Emissions_MD$Total.Emissions, type = "p",
     xlab="Year", ylab=expression('Emissions of PM'[2.5]*' (in tons)'), 
     main=expression('Total Emissions of PM'[2.5]*' in Baltimore City, MD'), 
     col = "steelblue", boxwex = 0.02)
lines(Emissions_MD$Year,Emissions_MD$Total.Emissions, lwd = 2)
dev.off()