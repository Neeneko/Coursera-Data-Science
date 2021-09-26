library(dplyr)
library(stringr)

dataRoot <- "UCI HAR Dataset"

if (!file.exists(dataRoot)) 
{
  dataURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(dataURL,'tmp.zip',method='curl')
  unzip("tmp.zip") 
  unlink("tmp.zip")
}

features <- read.table(file.path(dataRoot,"features.txt"), sep=' ',col.names = c("code","label"),header=FALSE)
features$label <- make.names(features$label)
activities <- read.table(file.path(dataRoot,"activity_labels.txt"), sep=' ',col.names = c("code", "label"),header=FALSE)
subject_test <- read.table(file.path(dataRoot,"test","subject_test.txt"), col.names = "subject")
subject_train <- read.table(file.path(dataRoot,"train","subject_train.txt"), col.names = "subject")
X_test <- read.table(file.path(dataRoot,"test","X_test.txt"), col.names = features$label)
y_test <- read.table(file.path(dataRoot,"test","y_test.txt"), col.names = 'code')
X_train <- read.table(file.path(dataRoot,"train","X_train.txt"), col.names = features$label)
y_train <- read.table(file.path(dataRoot,"train","y_train.txt"), col.names = 'code')
test <- cbind(subject_test,y_test,X_test)
train <- cbind(subject_train,y_train,X_train)

mergeData <- rbind(test,train)

meanIdx <- grep('mean',features$label)
meanLabels <- data.frame(str_replace(features$label[meanIdx],'mean','fxn'),features$label[meanIdx])
colnames(meanLabels) <- c('key','label_mean')

stdIdx <- grep('std',features$label)
stdLabels <- data.frame(str_replace(features$label[stdIdx],'std','fxn'),features$label[stdIdx])
colnames(stdLabels) <- c('key','label_std')

featureKeys <- merge(x=meanLabels,y=stdLabels,by='key')
mergeData <- subset(mergeData,select=c('subject','code',featureKeys$label_mean,featureKeys$label_std))
mergeData$code <- activities[mergeData$code,2]

colnames(mergeData)[1] <- "Subject"
colnames(mergeData)[2] <- "Activity"
names(mergeData)<-gsub("\\.\\.", "\\.", names(mergeData))
names(mergeData)<-gsub("\\.\\.", "\\.", names(mergeData))
names(mergeData)<-gsub("BodyBody", "Body", names(mergeData))
names(mergeData)<-gsub("^t", "Time", names(mergeData))
names(mergeData)<-gsub("^f", "Freq", names(mergeData))

outData <- mergeData %>% group_by(Subject, Activity) %>% summarise_all(mean)
write.table(outData, "Averages.txt", row.name=FALSE)

