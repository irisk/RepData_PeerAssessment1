data <- read.csv(file="activity.csv", header=TRUE)
#convert interval to a factor:
data$interval <- factor(data$interval)

library(dplyr)
library(ggplot2)


per_day <- group_by(data, date)
stepsPerDay <- summarise(per_day, totalSteps=sum(steps))
hist(stepsPerDay$totalSteps, breaks=10)

mean(stepsPerDay$totalSteps, na.rm = TRUE)
median(stepsPerDay$totalSteps, na.rm = TRUE)


per_interval <- group_by(data, interval)
stepsPerInterval <- summarise(per_interval, averageSteps=mean(steps, na.rm=TRUE))
plot(stepsPerInterval$interval, stepsPerInterval$averageSteps ) 
lines(stepsPerInterval$interval, stepsPerInterval$averageSteps, type="l")



which.max(stepsPerInterval$averageSteps)
sum(is.na(data$steps))

per_day <- group_by(data, date)
#get average steps per interval per day
averageStepsPerDay <- summarise(per_day, averageSteps=mean(steps))
#Set all NA to be 0
averageStepsPerDay$averageSteps[is.na(averageStepsPerDay$averageSteps)] <- 0
filledData <- merge(data, averageStepsPerDay, by="date")

filledData$steps[is.na(filledData$steps)] <- filledData$averageSteps[is.na(filledData$steps)]

per_day2 <- group_by(filledData, date)
stepsPerDay2 <- summarise(per_day2, totalSteps=sum(steps))
hist(stepsPerDay2$totalSteps, breaks=10) 
  
mean(stepsPerDay2$totalSteps, na.rm = TRUE)
median(stepsPerDay2$totalSteps, na.rm = TRUE)


filledData$day <- weekdays(as.Date(filledData$date,'%Y-%m-%d'))
filledData$weekday <- ifelse(filledData$day %in% c("Saturday", "Sunday"), "Weekend", "Weekday")
filledData$weekday <- factor(filledData$weekday)
groups2 <- group_by(filledData, interval,weekday)
weekdayData <- summarise(groups2, averageSteps=mean(steps))

library(lattice)
xyplot(averageSteps ~ interval | weekday, data=weekdayData,type='l', layout=c(1,2))


