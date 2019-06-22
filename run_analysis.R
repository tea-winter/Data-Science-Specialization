filename <- "Coursera_DS3_Final.zip"

# Checking if archieve already exists.
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

# Checking if folder exists
if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# set path
path <- "UCI HAR Dataset"
# read all data
features <- read.table(file.path(path,"features.txt")) #read features
act <- read.table(file.path(path, "activity_labels.txt")) #read activities
subj_train <- read.table(file.path(path, "train", "subject_train.txt")) # read subject train
subj_test <- read.table(file.path(path, "test", "subject_test.txt")) # read subject test
X_train <- read.table(file.path(path, "train", "X_train.txt")) # read X train
Y_train <- read.table(file.path(path, "train", "Y_train.txt")) # read Y train
X_test <- read.table(file.path(path, "test", "X_test.txt")) # read X test
Y_test <- read.table(file.path(path, "test", "Y_test.txt")) # read Y test
# set collumn names of all data
colnames(features) <- c("n", "features")
colnames(act) <- c("code", "activities")
colnames(X_train) <- features$features
colnames(X_test) <- features$features
colnames(Y_train) <- "code"
colnames(Y_test) <- "code"
colnames(subj_train) <- "subjects"
colnames(subj_test) <- "subjects"
#1 merge data
X <- rbind(X_train, X_test)
Y <- rbind(Y_train, Y_test)
subj <- rbind(subj_train, subj_test)
Merged_Data <- cbind(subj, Y, X)
#2 Extracts data
sub_tidy_names <- features$features[grep("mean\\(\\)|std\\(\\)", features$features)]
library(readr)
library(dplyr)
Tidy_Data <- subset(Merged_Data, select = c("subjects", "code", as.character(sub_tidy_names)))
#3 descriptive activity 
Tidy_Data$code <- activities[Tidy_Data$code, 2]
#4 Appropriately labels 
names(Tidy_Data)
colnames(Tidy_Data)[2] <- "activities"
colnames(Tidy_Data) <- gsub("^t", "time", colnames(Tidy_Data))
colnames(Tidy_Data) <- gsub("^f", "frequency", colnames(Tidy_Data))
colnames(Tidy_Data) <- gsub("Acc", "Accelerometer", colnames(Tidy_Data))
colnames(Tidy_Data) <- gsub("Gyro", "Gyroscope", colnames(Tidy_Data))
colnames(Tidy_Data) <- gsub("Mag", "Magnitude", colnames(Tidy_Data))
colnames(Tidy_Data) <- gsub("BodyBody", "Body", colnames(Tidy_Data))
colnames(Tidy_Data) <-gsub("-mean()", "Mean", colnames(Tidy_Data), ignore.case = TRUE)
colnames(Tidy_Data) <-gsub("-std()", "STD", colnames(Tidy_Data), ignore.case = TRUE)
colnames(Tidy_Data) <-gsub("-freq()", "Frequency", colnames(Tidy_Data), ignore.case = TRUE)
colnames(Tidy_Data) <-gsub("angle", "Angle", colnames(Tidy_Data))
colnames(Tidy_Data) <-gsub("gravity", "Gravity", colnames(Tidy_Data))
colnames(Tidy_Data) # check result
#creates a second independent tidy data set 
Final_Data <- Tidy_Data %>%
  group_by(subjects, activities) %>%
  summarise_all(mean)

write.table(Final_Data, "Final_Data.txt", row.name=FALSE)
