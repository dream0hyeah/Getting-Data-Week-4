## step 1: Merges the training and the test sets to create one data set.

subject_train<-read.table("~/Desktop/Coursera/UCI HAR Dataset/train/subject_train.txt")
X_train<-read.table("~/Desktop/Coursera/UCI HAR Dataset/train/X_train.txt")
y_train<-read.table("~/Desktop/Coursera/UCI HAR Dataset/train/y_train.txt")

subject_test<-read.table("~/Desktop/Coursera/UCI HAR Dataset/test/subject_test.txt")
X_test<-read.table("~/Desktop/Coursera/UCI HAR Dataset/test/X_test.txt")
y_test<-read.table("~/Desktop/Coursera/UCI HAR Dataset/test/y_test.txt")

featureNames<-read.table("~/Desktop/Coursera/UCI HAR Dataset/features.txt")
names(X_train)<-featureNames$V2
names(subject_train)<-"subjectID"
names(y_train)<-"activity"
names(X_test)<-featureNames$V2
names(subject_test)<-"subjectID"
names(y_test)<-"activity"

train<-cbind(subject_train,y_train,X_train)
test<-cbind(subject_test,y_test,X_test)
combined<-rbind(train,test)
head(combined)

## STEP 2: Extracts only the measurements on the mean and standard
meanstdcols<-grepl("mean|std",names(combined))
combined<-combined[,meanstdcols]
head(combined)

## STEP 3: Uses descriptive activity names to name the activities in the data set.
## STEP 4: Appropriately labels the data set with descriptive activity names. 
combined$activity <- factor(combined$activity, 
                            labels=c("Walking","Walking Upstairs", "Walking Downstairs", "Sitting", "Standing", "Laying"))
combined[50,2]

## STEP 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
install.packages("reshape2")
library(reshape2)
melted<-melt(combined,id=c("subjectID","activity"))
head(melted)
tidy<-dcast(melted,subjectID+activity~variable,mean)
head(tidy)
str(tidy)
write.table(tidy,"tidy.txt",row.names=FALSE)
