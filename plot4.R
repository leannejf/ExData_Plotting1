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

#Plot 4 is a 2x2 array of plots 
png(file = "plot4.png", bg = "transparent", width = 480, height = 480)
par(mfrow = c(2,2))
#Top left is the same as Plot 2 (slightly different y-axis label).
with(powersub, plot(Global_active_power, type = "l", xaxt="n", xlab = "", 
                    ylab = "Global Active Power"))
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
#Top right
with(powersub, plot(Voltage, type = "l", xaxt="n", xlab = "datetime"))
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
#Bottom left is the same as Plot 3 without border on legend
with(powersub, plot(Sub_metering_1, type = "n", xaxt="n", xlab = "", 
                    ylab = "Energy sub metering"))
with(powersub, lines(Sub_metering_1))
with(powersub, lines(Sub_metering_2, col = "red"))
with(powersub, lines(Sub_metering_3, col = "blue"))
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
par(bg = NA)
legend("topright", lty = 1, col = c("black", "red", "blue"), legend = 
             c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n")
#Bottom right
with(powersub, plot(Global_reactive_power, type = "l", xaxt="n", xlab = "datetime"))
axis(1, at = c(0, 1440, 2880), labels = c("Thu", "Fri", "Sat"))
dev.off()