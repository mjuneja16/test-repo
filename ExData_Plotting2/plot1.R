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
##aggregate the 'Emissions' (in the United States) by year
Emissions<-aggregate(NEI[,"Emissions"],by=list(NEI$year), FUN = sum)
##rename the columns names of the data set 'Emissions' as 'Year' and 'Total.Emissions'
colnames(Emissions)<-c("Year","Total.Emissions")
##change the units of the variable 'Total.Emissions' to kilotons
Emissions$Total.Emissions<-round(Emissions[,2]/1000,2)
Emissions<-transform(Emissions,Year=factor(Year))
##open the PNG file device in the working directory
png(filename="plot1.png",width=480,height=480,units="px")
par(mar=c(5,5,4,2))
##plot the 'Total PM2.5 Emissions in the United States' across the years 1999-2008 using the base plotting system
barplot(height=Emissions$Total.Emissions,names.arg=Emissions$Year,
     xlab="Year",ylab=expression('Emissions of PM'[2.5]*' (in kilotons)'), 
     main=expression('Total Emissions of PM'[2.5]*' in the United States'), col = "red")
##close the PNG file device
dev.off()
