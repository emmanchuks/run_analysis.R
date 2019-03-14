library(dplyr)

##Download data
if (!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/UCI_HAR_Dataset.txt", method="auto")

df <- read.csv("UCI_HAR_Dataset.txt")

# read train data
#traindf0 <- "./data/UCI_HAR_Dataset.txt"
traindfx <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
traindfy <- read.table("./UCI_HAR_dataset/train/Y_train.txt")
Subtraindf <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

# read test data
testdfx <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
testdfY <- read.table(".UCI_HAR_Dataset/test/Y_test.txt")
Subtestdf <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")

# read data description
featuresdf <- read.table(".UCI_HAR_Dataset/features/features.txt")

# Read activity labels
activitylabelsdf <- read.table(".UCI_HAR_Dataset/activity/activity_labels.txt")

# 1. Merges the training and the test sets.
mergeddfx <- rbind(x_train, x_test)
mergeddfy <- rbind(y_train, y_test)
mergedSubs<- rbind(Sub_train, Sub_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_var <- featuresdf[grep("mean\\(\\)|std\\(\\)", featuresdf[,2]),]
mergeddfx <- mergedSubs[,selected_var[,1]]

# 3. Using descriptive activity names to name the activities in the data set
colnames(mergeddfy) <- "activity"
mergeddfy$activitylabelsdf <- factor(mergeddfy$activity, labels = as.character(activitylabelsdf [,2]))
activitylabelsdf <- mergeddfy[,-1]

# 4. Appropriately labelling the data set with descriptive variable names.
colnames(mergeddfx) <- featuresdf[selected_var[,1],2]

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Sub_total) <- "subject"
total <- cbind(mergedSubs, activitylabelsdf, Sub_total)
total_mean <- total %>% group_by(activitylabelsdf, subject) s%>% summarize_each(funs(mean))
write.table(total_mean, file = "UCI_HAR_Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)