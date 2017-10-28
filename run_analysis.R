library("plyr")
library("dplyr")
setwd('C:\\Users\\hhegde\\Documents\\courseera\\Peer-graded Assignment Getting and Cleaning Data Course Project')
rm(list=ls())

if(!file.exists("dataset.zip")){
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","dataset.zip")
}
if(!dir.exists("UCI HAR Dataset")){
  unzip("dataset.zip")  
}

#reading training dataset  
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt")
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt")

#reading testing dataset
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt")
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt")


#merging test and training datasets
xmerged <- rbind(xtrain, xtest)
ymerged <- rbind(ytrain, ytest)
submerged <- rbind(subtrain, subtest)

#read features
features <- read.table("UCI HAR Dataset/features.txt")

#keep only required features
whichfeatures <- grep("-(mean|std)\\(\\)", features[, 2])
xmerged <- as_tibble(xmerged[, whichfeatures])
names(xmerged) <- features[whichfeatures, 2]

activities <- read.table("UCI HAR Dataset/activity_labels.txt")

ymerged[,1]<- activities[ymerged[, 1], 2]
names(ymerged) <- "activity"
names(submerged) <- "subject"

allmerged <- cbind(xmerged, ymerged, submerged)
avg_merged <- ddply(allmerged, .(subject, activity), function(x) colMeans(x[, 1:66]))

# write to file
write.table(avg_merged, "tidydata.txt", row.name=FALSE)







