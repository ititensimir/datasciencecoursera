# download and unzip file given an url, the curl method is necessary for https
URL <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
ZIPFile <- "./getdata-projectfiles-UCI-HAR-Dataset.zip"
download.file(URL, destfile = ZIPFile, method="curl")
unzip(ZIPFile)

## read data from files
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
features <- read.table("./UCI HAR Dataset/features.txt")
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")

#bind the data train with data test
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)

# give user friendly names to features columns
names(features) <- c('feat_id', 'feat_name')
# look for mean and standard deviation (std) in featurues names
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x <- x[, index_features] 
names(x) <- gsub("\\(|\\)", "", (features[index_features, 2]))

# give user friendly names to activities columns
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]

names(y) <- "Activity"
names(s) <- "Subject"

# bind data tables 
myCleanData <- cbind(s, y, x)
# creates a further clean dataset with the average values
toBeAggregated <- myCleanData[, 3:dim(myCleanData)[2]] 
myCleanDataMean <- aggregate(toBeAggregated,list(myCleanData$Subject, myCleanData$Activity), mean)

#giving column names to myCleanDataMean
names(myCleanDataMean)[1] <- "Subject"
names(myCleanDataMean)[2] <- "Activity"

# write clean data on file
myCleanDataFile <- "./tidy-UCI-HAR-dataset.txt"
write.table(tidyDataSet, tidyDataFile)

# write clean data mean on file
myCleanDataMeanFile <- "./tidy-UCI-HAR-dataset-AVG.txt"
write.table(tidyDataAVGSet, tidyDataFileAVGtxt)
