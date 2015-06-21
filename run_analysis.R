# run_analysis.R - script to do the following steps
#
# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

featureNames <- read.table("./UCI HAR Dataset/features.txt",header = FALSE)


# Read in the data
subject_train_data <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test_data  <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

activity_train_data <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
activity_test_data <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)

feature_train_data <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
feature_test_data <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)

## Merge
subject_data <- rbind(subject_train_data,subject_test_data)
activity_data <- rbind(activity_train_data,activity_test_data)
feature_data <- rbind(feature_train_data,feature_test_data)


names(subject_data) <- c("subject")
names(activity_data) <- c("activity")
names(feature_data) <- featureNames$V2

complete_data <- cbind(feature_data,subject_data,activity_data)


## Extract only the measurements on the mean and standard deviation

#columns_with_mean_std <- grep(".*Mean.*|.*Std.*", names(complete_data), ignore.case=TRUE)
columns_with_mean_std <-featureNames$V2[grep("mean\\(\\)|std\\(\\)", featureNames$V2)]
selected_columns <- c(as.character(columns_with_mean_std), "subject", "activity" )

extracted_data <- subset(complete_data, select = selected_columns)

## Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("./UCI HAR Dataset/activity_labels.txt", header = FALSE)
extracted_data$activity = factor(extracted_data$activity, levels = c(1,2,3,4,5,6), labels=activityLabels$V2)

## Appropriately labels the data set with descriptive variable names. 
names(extracted_data) <- gsub("Acc","Accelerometer",names(extracted_data))
names(extracted_data) <- gsub("Gyro","Gyroscope",names(extracted_data))
names(extracted_data)<-gsub("BodyBody", "Body", names(extracted_data))
names(extracted_data)<-gsub("Mag", "Magnitude", names(extracted_data))
names(extracted_data)<-gsub("^t", "Time", names(extracted_data))
names(extracted_data)<-gsub("^f", "Frequency", names(extracted_data))
names(extracted_data)<-gsub("tBody", "TimeBody", names(extracted_data))
names(extracted_data)<-gsub("-mean()", "Mean", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-std()", "STD", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("-freq()", "Frequency", names(extracted_data), ignore.case = TRUE)
names(extracted_data)<-gsub("angle", "Angle", names(extracted_data))
names(extracted_data)<-gsub("gravity", "Gravity", names(extracted_data))

# Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy_data <- aggregate(. ~subject + activity, extracted_data, mean)
write.table(tidy_data, file = "tidydata.txt",row.name=FALSE)
