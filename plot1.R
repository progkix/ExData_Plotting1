library(dplyr)

SourceFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

DownloadedFile <- "./data/PowerData.zip"

PowerDataFile <- "./data/household_power_consumption.txt"

PlotFile <- "plot1.png"

if (!file.exists(DownloadedFile))
{
	cat("Downloading and extracting source data\n")

	download.file(SourceFile, DownloadedFile, quiet = TRUE)

	file <- unzip(DownloadedFile, overwrite = T, exdir = "./data")
}

if (file.exists(PowerDataFile))
{
	if (file.exists(PlotFile))
	{
		cat("Removing old", PlotFile, "\n")

		file.remove(PlotFile)
	}

	cat("Creating plot\n")

	PowerData <- filter(read.csv2(PowerDataFile, na.strings = "?"), Date == "1/2/2007" | Date == "2/2/2007")

	DateTime <- strptime(paste(PowerData$Date, PowerData$Time, sep=" "), "%d/%m/%Y %H:%M:%S")
	PowerData <- cbind(DateTime, PowerData)

	PowerData$Voltage <- as.numeric(as.character(PowerData$Voltage))
	PowerData$Global_active_power <- as.numeric(as.character(PowerData$Global_active_power))
	PowerData$Global_reactive_power <- as.numeric(as.character(PowerData$Global_reactive_power))

	PowerData$Sub_metering_1 <- as.numeric(as.character(PowerData$Sub_metering_1))
	PowerData$Sub_metering_2 <- as.numeric(as.character(PowerData$Sub_metering_2))
	PowerData$Sub_metering_3 <- as.numeric(as.character(PowerData$Sub_metering_3))

	hist(PowerData$Global_active_power, main = "Global Active Power", ylab = "Frequency", xlab = "Global Active Power (kilowatts)", col = "red", breaks = 13, ylim = c(0, 1200), xlim = c(0, 6), xaxp = c(0, 6, 3))

	dev.copy(png, file=PlotFile, width=480, height=480)
	dev.off()

	cat(PlotFile, "has been created\n")
}
