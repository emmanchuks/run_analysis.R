library(dplyr)
## Data download and unzip 

# string variables for file download
fileName <- "UCIdata.zip"
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
dir <- "UCI HAR Dataset"

# File download verification. If file does not exist, download to working directory.
if(!file.exists(fileName)){
  download.file(url,fileName, mode = "wb") 
}

# File unzip verification. If the directory does not exist, unzip the downloaded file.
if(!file.exists(dir)){
  unzip("UCIdata.zip", files = NULL, exdir=".")
}

#Reading the training tables
traindfx <- read.table("UCI HAR Dataset/train/X_train.txt", header = FALSE)
traindfy <- read.table("UCI HAR Dataset/train/y_train.txt", header = FALSE)
subjtraindf <- read.table("UCI HAR Dataset/train/subject_train.txt", header = FALSE)

#Reading the testing tables
testdfx <- read.table("UCI HAR Dataset/test/X_test.txt", header = FALSE)
testdfy <- read.table("UCI HAR Dataset/test/y_test.txt", header = FALSE)
subtestdf <- read.table("UCI HAR Dataset/test/subject_test.txt", header = FALSE)

#Reading supportive metadata
features <- read.table("UCI HAR Dataset/features.txt")
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt")

#merging
mergeddfx <- rbind(traindfx, testdfx)
mergeddfy <- rbind(traindfy, testdfy)
mergedSubs <- rbind(subjtraindf, subtestdf)

# 2. Extracting the mean and standard deviation for each measurement.
selected_var <- features[grep("mean\\(\\)|std\\(\\)", features[,2]),]
mergeddfx <- mergeddfx[,selected_var[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(mergeddfy) <- "activity"
mergeddfy$activity_labels <- factor(mergeddfy$activity, labels = as.character(activity_labels[,2]))
activitylabel <- mergeddfy[,-1]

# 4. Appropriately labels the data set with descriptive variable names.
colnames(mergeddfx) <- features[selected_var[,1],2]

colnames(mergedSubs) <- "subject"

total <- cbind(mergeddfx, activitylabel, mergedSubs)
total_mean <- total %>% group_by(activity_labels, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "tidydata.txt", row.names = FALSE, col.names = TRUE)