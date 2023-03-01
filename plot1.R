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
  png("plot1.png")
}

hist(consumption$Global_active_power, col="red", xlab="Global Active Power (kilowatts)", ylab="Frequency", main="Global Active Power")

## Don't forget to close the PNG device!
dev.off()