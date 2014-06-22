if(!file.exists("./Source_Classification_Code.rds") & !file.exists("./summarySCC_PM25.rds"))
{
  fileUrl<-"https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
  download.file(fileUrl,destfile="NEI_data.zip")
  unzip("NEI_data.zip")
}
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")
Emissions<-aggregate(NEI[,"Emissions"],by=list(NEI$year), FUN = sum)
colnames(Emissions)<-c("Year","Total.Emissions")
Emissions$Total.Emissions<-round(Emissions[,2]/1000,2)
Emissions<-transform(Emissions,Year=factor(Year))
png(filename="plot1.png",width=480,height=480,units="px")
par(mar=c(5,5,4,2))
barplot(height=Emissions$Total.Emissions,names.arg=Emissions$Year,
     xlab="Year",ylab=expression('Emissions of PM'[2.5]*' (in kilotons)'), 
     main=expression('Total Emissions of PM'[2.5]*' in the United States'), col = "red")
dev.off()