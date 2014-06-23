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
##use subset function to extract the contents of only Baltimore City and name the data set as 'NEI_MD'
NEI_MD<-subset(NEI,NEI$fips=="24510")
##aggregate the 'Emissions' (in the Baltimore City, MD) by year
Emissions_MD<-aggregate(NEI_MD[,"Emissions"],by=list(NEI_MD$year), FUN = sum)
##rename the columns names of the data set 'Emissions' as 'Year' and 'Total.Emissions'
colnames(Emissions_MD)<-c("Year","Total.Emissions")
Emissions_MD<-transform(Emissions_MD,Year=factor(Year))
##open the PNG file device in the working directory
png(filename="plot2.png",width=480,height=480,units="px")
par(mar=c(5,5,4,2))
##plot the 'Total PM2.5 Emissions in Baltimore City, MD' across the years 1999-2008 using the base plotting system
plot(Emissions_MD$Year,Emissions_MD$Total.Emissions, type = "p",
     xlab="Year", ylab=expression('Emissions of PM'[2.5]*' (in tons)'), 
     main=expression('Total Emissions of PM'[2.5]*' in Baltimore City, MD'), 
     col = "steelblue", boxwex = 0.02)
lines(Emissions_MD$Year,Emissions_MD$Total.Emissions, lwd = 2)
##close the PNG file device
dev.off()
