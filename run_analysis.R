#Read Files
path_rf <-file.path( "UCI HAR Dataset")
#List files to check whats in the folder
list.files(path_rf, recursive =TRUE)
#Read relevant files; Features data, Activity label, Subject
Fea.test <- read.table(file.path(path_rf, "test", "X_test.txt"), header = FALSE)
Fea.train <- read.table(file.path(path_rf, "train", "X_train.txt"), header = FALSE)
Act.test <- read.table(file.path(path_rf, "test", "Y_test.txt"), header = FALSE)
Act.train <- read.table(file.path(path_rf, "train", "Y_train.txt"), header = FALSE)
Sub.test <- read.table(file.path(path_rf, "test", "subject_test.txt"), header = FALSE)
Sub.train <- read.table(file.path(path_rf, "train", "subject_train.txt"), header = FALSE)
#Merge test and train data tables for each "subtable"
Feat. <-rbind(Fea.test, Fea.train)
Acti. <-rbind(Act.test, Act.train)
Subj. <-rbind(Sub.test, Sub.train)
# Add labels to variables
Feat.names <- read.table(file.path(path_rf, "features.txt"), head = FALSE)
names(Feat.) <- Feat.names$V2
names(Acti.)  <-c("activity")
names(Subj.) <- c("subject")
# Now put together these three "subtables" into one data table
Sam.data <- cbind(Subj., Acti., Feat.)
# Subset features to only those columns that are mean or std. dev.'s of measurements
n <- names(Feat.)
#Create vector of columns with mean or std
mastd <- grep("mean|std", n, value = TRUE)
#Select subset of columns
sel.cols <- c(as.character(mastd), "subject", "activity")
Sam.data1 <- subset(Sam.data, select=sel.cols)
#Rename activities from #s to descriptive names
# Create df with activity index #s and descriptions. Then replace
#indices with matching descriptions in df
actlabels <- read.table(file.path(path_rf, "activity_labels.txt"), header = F)
Sam.data1[,81] <- actlabels[Sam.data1[,81], 2]
# do an str of the df to  check progress and observe names that need to be changed.
str(Sam.data1)
#REplace appreviations in labels with full words with gsub and
#add underlines to make labels more readable
names(Sam.data1) <- gsub("^t", "Time_",names(Sam.data1))
names(Sam.data1) <- gsub("^f", "Frequency_",names(Sam.data1))
names(Sam.data1) <- gsub("Acc", "_Accelerometer",names(Sam.data1))
names(Sam.data1) <- gsub("Gyro", "_Gyroscope",names(Sam.data1))
names(Sam.data1) <- gsub("Mag", "_Magnitude",names(Sam.data1))
names(Sam.data1) <- gsub("Jerk", "_Jerk",names(Sam.data1))
#Group df by activity and subject, then compute averages of each variable
library(dplyr)
Sam.data2 <- group_by(Sam.data1, subject, activity)
Finaldata <-Sam.data2 %>% summarise_each(funs(mean))
#Copy final data to a text file using write.table function
write.table(Finaldata, file = "Finaldata.txt",row.name = F)
