library(dplyr)

SourceFile <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"

DownloadedFile <- "./data/PowerData.zip"

PowerDataFile <- "./data/household_power_consumption.txt"

PlotFile <- "plot3.png"

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

	png(filename = PlotFile, width = 480, height = 480)

	plot(c(PowerData$DateTime, PowerData$DateTime, PowerData$DateTime), c(PowerData$Sub_metering_1, PowerData$Sub_metering_2, PowerData$Sub_metering_3), type = "n", xlab = "", ylab = "Energy sub metering")

	lines(PowerData$DateTime, PowerData$Sub_metering_1, col = "black")
	lines(PowerData$DateTime, PowerData$Sub_metering_2, col = "red")
	lines(PowerData$DateTime, PowerData$Sub_metering_3, col = "blue")

	legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1,1), col = c("black", "red", "blue"))

	dev.off()

	cat(PlotFile, "has been created\n")
}
