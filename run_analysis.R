## 1. Merges the training and the test sets to create one data set.

dataActivityTest  <- read.table("test/y_test.txt", col.names="label")
dataActivityTrain <- read.table("train/y_train.txt", col.names="label")
dataSubjectTrain <- read.table("train/subject_train.txt", col.names="subject")
dataSubjectTest  <- read.table("test/subject_test.txt", col.names="subject")
dataFeaturesTest  <- read.table("test/X_test.txt")
dataFeaturesTrain <- read.table("train/X_train.txt")

dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table("features.txt", header = FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

dataCombine <- cbind(dataSubject, dataActivity)
data <- cbind(dataFeatures, dataCombine)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
data<-subset(data,select=selectedNames)

## 3. Uses descriptive activity names to name the activities in the data set
activityLabels <- read.table("activity_labels.txt",header = FALSE)

## 4. Appropriately labels the data set with descriptive activity names.
names(data)<-gsub("^t", "time", names(data))
names(data)<-gsub("^f", "frequency", names(data))
names(data)<-gsub("Acc", "Accelerometer", names(data))
names(data)<-gsub("Gyro", "Gyroscope", names(data))
names(data)<-gsub("Mag", "Magnitude", names(data))
names(data)<-gsub("BodyBody", "Body", names(data))

## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(plyr);
TidyData<-aggregate(. ~subject + activity, Data, mean)
TidyData<-TidyData[order(TidyData$subject,TidyData$activity),]
write.table(TidyData, file = "tidydata.txt",row.name=FALSE)
