# 1. Merge the training and the test sets to create one data set.

setwd("C:/Users/ronip/Desktop/WORKS/R/DataScience/ClearData")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
x_data <- rbind(x_train, x_test)
rm(x_train)
rm(x_test)

subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
subject_data <- rbind(subject_train, subject_test)
rm(subject_test)
rm(subject_train)

y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
y_data <- rbind(y_train, y_test)
rm(y_train)
rm(y_test)


# 2. Extract the measurements on the mean and standard deviation for each measurement.

features <- read.table("UCI HAR Dataset/features.txt")
rownum <- grep(pattern="mean\\()|std\\()" ,x=features[, 2],value=F) 
x_data <- x_data[,rownum]
names(x_data) <- gsub("\\()", "", grep(pattern="mean\\()|std\\()" ,x=features[, 2],value=T)) 
rm(features)
rm(rownum)


# 3. Use descriptive activity names to name the activities in the data set

activities <- read.table("UCI HAR Dataset/activity_labels.txt")
#install.packages("sqldf")
library(sqldf)
activities <- sqldf("SELECT V2 AS activity FROM y_data JOIN activities USING(V1)")
rm(y_data)


# 4. Appropriately label the data set with descriptive variable names. 

names(subject_data) <- "subject"
all_data <- data.frame(cbind(subject_data , activities, x_data))


# 5. Creates a 2nd, independent tidy data set with the average of each variable for 
# each activity and each subject.

tidy_data <- aggregate(. ~ subject+activity, data = all_data, mean)
write.table(x = tidy_data, file = "tidy_data.txt", row.name=FALSE)

