library(dplyr)


# Load the data

if(!file.exists("./data")){
  dir.create("./data")
}

if(!file.exists("./data/household_power_consumption.zip")){
  fileUrl <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileUrl, destfile="./data/household_power_consumption.zip", method="curl")
}

consumption <- read.table(unzip("./data/household_power_consumption.zip", "household_power_consumption.txt"), header=TRUE, sep=";", na.strings="?")


# Do some minor transforms

start <- strptime("2007-02-01", "%Y-%m-%d")
end <- strptime("2007-02-03", "%Y-%m-%d")


consumption <- consumption %>% 
  mutate(datetime=strptime(paste(Date, Time), "%d/%m/%Y %H:%M:%S")) %>% 
  select(-Date, -Time) %>%
  filter(datetime > start, datetime < end)

toPlot = TRUE
if (toPlot) {
  png("plot4.png")
}

par(mfcol=c(2,2))
with(consumption, {
  plot(datetime, Global_active_power, type = "l", lty = 1, ylab="Global Active Power", xlab="")
  
  colors <- c("black", "red", "blue")
  plot(datetime, Sub_metering_1, type = "l", lty = 1, col=colors[1], xlab="", ylab="Energy Sub Metering")
  lines(datetime, Sub_metering_2, type = "l", lty = 1, col=colors[2])
  lines(datetime, Sub_metering_3, type = "l", lty = 1, col=colors[3])
  legend("topright", lty=1, col=colors, legend=c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), bty = "n", cex=0.8)
  
  plot(datetime, Voltage, type = "l", lty = 1, ylab="Voltage")
  
  plot(datetime, Global_reactive_power, type = "l", lty = 1)
})

## Don't forget to close the PNG device!
dev.off()
