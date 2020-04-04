#Load package to get and unzip data

library(data.table); library(reshape2)
fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileURL, destfile = "./data.zip")
unzip(zipfile = "data.zip")

#Read in activity labels

activity_labels <- read.delim("./UCI HAR Dataset/activity_labels.txt",header = FALSE
                              ,sep = "",col.names = c("Labels","activityName"))

#Read in features

features <- read.delim("./UCI HAR Dataset/features.txt",header = FALSE
                       ,sep = "",col.names = c("index","featureNames"))

#Filter down to features wanted

featuresWanted <- grep(pattern = "(mean|std)\\(\\)",x = features[,"featureNames"])
measurements <- features[featuresWanted, "featureNames"]
measurements <- gsub("[()]","", measurements)

#Read in training data

train_dat <- read.delim("./UCI HAR Dataset/train/X_train.txt",
                        header = FALSE,sep = "",dec = ".",as.is = TRUE)
train_dat <- train_dat[,featuresWanted]
data.table::setnames(train_dat, colnames(train_dat), measurements)
trainActivities <- read.delim(file = "./UCI HAR Dataset/train/y_train.txt",
                              header = FALSE,sep = "",as.is = TRUE,col.names = c("Activity"))
trainSubjects <- read.delim(file = "./UCI HAR Dataset/train/subject_train.txt",
                            header = FALSE,sep = "",as.is = TRUE,col.names = c("SubjectNum"))
train_dat <- cbind(trainSubjects,trainActivities,train_dat)

#Read in test data

test_dat <- read.delim("./UCI HAR Dataset/test/X_test.txt",
                       header = FALSE,sep = "",dec = ".",as.is = TRUE)
test_dat <- test_dat[,featuresWanted]
data.table::setnames(test_dat, colnames(test_dat), measurements)
testActivities <- read.delim(file = "./UCI HAR Dataset/test/y_test.txt",
                             header = FALSE,sep = "",as.is = TRUE,col.names = c("Activity"))
testSubjects <- read.delim(file = "./UCI HAR Dataset/test/subject_test.txt",
                           header = FALSE,sep = "",as.is = TRUE,col.names = c("SubjectNum"))
test_dat <- cbind(testSubjects,testActivities,test_dat)

#Merge/append train and test data

combined_data <- rbind(train_dat,test_dat)

#Convert the class lables in the activity name column to the actual activity name

combined_data$Activity <- factor(x = combined_data[,"Activity"],levels = activity_labels[,"Labels"],
                                 labels = activity_labels[,"activityName"])

combined_data$SubjectNum <- as.factor(x = combined_data$SubjectNum)

#Reshape the combined data to show the average of each variable for each activity and each subject

combined_data_aggregate <- reshape2::melt(data = combined_data, id = c("SubjectNum","Activity"))
combined_data_aggregate <- reshape2::dcast(data = combined_data_aggregate,
                                           SubjectNum + Activity ~ variable,fun.aggregate = mean)

#Export aggregated data to csv

write.csv(x = combined_data_aggregate,file = "./tidyData.csv",quote = FALSE)
write.table(combined_data_aggregate,file = "./tidyData.txt",quote = FALSE,row.names = FALSE)

