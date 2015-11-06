# This script uses the dplyr package to filter out the target dates.
# It first download, unzips, and reads the data, then filters out target dates and 
# formats the dates and times.

library(dplyr)
if(!file.exists("./data")){dir.create("./data")}
fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
pathzip <- "./data/household_power_consumption.zip"
download.file(fileURL, destfile = pathzip)
dateDownloaded <- date()
unzip (pathzip, exdir="./data")

power <- read.table("./data/household_power_consumption.txt", header = TRUE, 
      sep = ";", na.strings = "?", stringsAsFactors = F)
powersub <- filter(power, Date == "1/2/2007" | Date == "2/2/2007")
powersub$Date <- strptime(powersub$Date, format = "%d/%m/%Y")
powersub$Time <- strptime(powersub$Time, format = "%H:%M:%S")
rm(power)

#Plot 1
png(file = "plot1.png", bg = "transparent", width = 480, height = 480)
hist(powersub$Global_active_power, xlab = "Global Active Power (kilowatts)", 
     main = "Global Active Power", col = "red")
dev.off()