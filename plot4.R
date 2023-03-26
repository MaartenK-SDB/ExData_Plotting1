library(dplyr)
#First we download the file and unzip it
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
file <- 'Powerconsumption.zip'
if(!file.exists(file)){
  download.file(url, 'Powerconsumption.zip')
}

if(!file.exists("household_power_consumption.txt"))
{
  unzip(file)
}
#Loading the file
worktable <- read.table("household_power_consumption.txt", header = TRUE, sep = ";")


#Convert to DateTime using as.POSIXct pasting the date and time together.
worktable$DateTime <- as.POSIXct(paste(worktable$Date, worktable$Time), format = "%d/%m/%Y %H:%M:%S")
#Removing the now useless Date and Time column, rearranging DateTime to be in front and filtering based on date
worktable <- worktable %>% select(-c(Date, Time))%>%
  relocate(DateTime, .before = Global_active_power) %>%
  filter(DateTime >= "2007-02-1" & DateTime < "2007-02-03")
#Converting everything to Numeric
worktable$Global_active_power <- as.numeric(worktable$Global_active_power)
worktable$Global_reactive_power <- as.numeric(worktable$Global_reactive_power)
worktable$Global_intensity <- as.numeric(worktable$Global_intensity)
worktable$Voltage <- as.numeric(worktable$Voltage)
worktable$Sub_metering_1 <- as.numeric(worktable$Sub_metering_1)
worktable$Sub_metering_2 <- as.numeric(worktable$Sub_metering_2)

#Starting Graphics Device
png("plot4.png", width = 480, height = 480, units = "px")

#Setting Parameters
par(mfcol = c(2,2), cex.lab = 1.2, cex.axis = 1.2, pin = c(1.8, 1.6), oma = c(0.5, 1, 0,0),  mgp = c(3,1,0))
#Graph1
with(worktable, plot(y = Global_active_power, x = DateTime, type = "l", ylab = "Global Active Power", xlab = ""))

#Graph2
with(worktable, plot(DateTime, Sub_metering_1, type = "l", ylab = "Energy sub metering", xlab = ""))
with(worktable, lines(DateTime,Sub_metering_2, type = "l", col = "red"))
with(worktable, lines(DateTime,Sub_metering_3, type = "l", col = "blue"))
legend("topright",legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), col = c("black", "red", "blue"), bty = "n", lty = 1, cex = 0.6, )

#Graph3
with(worktable, plot(DateTime, Voltage, type = "l", xlab = "datetime"))

#Graph4
with(worktable, plot(DateTime, Global_reactive_power, type = "l", xlab = "datetime"))

#Closing Session
dev.off()