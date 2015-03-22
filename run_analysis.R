
# Load all the required libraries
library(data.table)
library(dplyr)
library(tidyr)

##First we get all the data
#getting train data & merging it 
traindata= read.csv("train/X_train.txt", sep="", header=FALSE)
traindata[,562] = read.csv("train/Y_train.txt", sep="", header=FALSE)
traindata[,563] = read.csv("train/subject_train.txt", sep="", header=FALSE)

#getting test data & merging it 
testdata = read.csv("test/X_test.txt", sep="", header=FALSE)
testdata[,562] = read.csv("test/Y_test.txt", sep="", header=FALSE)
testdata[,563] = read.csv("test/subject_test.txt", sep="", header=FALSE)

#getting activities data
activitiesdata=read.csv("activity_labels.txt", sep="", header=FALSE)

#getting features data
featuresdata = read.csv("features.txt", sep="", header=FALSE)

#Renaming the features names
featuresdata[,2] = gsub('-mean', 'Mean', featuresdata[,2])
featuresdata[,2] = gsub('-std', 'Std', featuresdata[,2])
featuresdata[,2] = gsub('[-()]', '', featuresdata[,2])

##1 Merges the training and the test sets to create one data set.
#merging data
mydata = rbind(traindata,testdata)

##2 Extracts only the measurements on the mean and standard deviation for each measurement. 
#selecting the required columns
mycolumns <- grep(".*Mean.*|.*Std.*", featuresdata[,2])
featuresdata <- featuresdata[mycolumns,]

#Add subject and activity
mycolumns <- c(mycolumns, 562, 563)

# Select required columns in mydata
mydata <- mydata[,mycolumns]

# Add the column names to mydata
colnames(mydata) <- c(featuresdata$V2, "Activity", "Subject")
colnames(mydata) <- tolower(colnames(mydata))

##3 Uses descriptive activity names to name the activities in the data set
i = 1
for (currentActivityLabel in activitiesdata$V2) {
  mydata$activity <- gsub(i, currentActivityLabel, mydata$activity)
  i <- i + 1
}

##4 Appropriately labels the data set with descriptive variable names. 
mydata$activity <- as.factor(mydata$activity)
mydata$subject <- as.factor(mydata$subject)

##5 From the data set in step 4, creates a second, independent tidy data set with the average 
##of each variable for each activity and each subject.

#agreggate data by activity and subject in order to get their mean
tidy = aggregate(mydata, by=list(activity = mydata$activity, subject=mydata$subject), mean)

# Remove subject and activity column
tidy[,90] = NULL
tidy[,89] = NULL
write.table(tidy, "tidy.txt", sep="\t", row.name=FALSE)
