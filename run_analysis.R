library(dplyr)

getTidyDataSet <- function() {
  rawData <- getMeanAndStandardDeviationData()
  summaryData <- rawData %>% 
                group_by(subject_id, activity_label) %>% 
                  summarise_each(funs(mean))
}

getMeanAndStandardDeviationData <- function() {
  mergedData <- getMergedData()
  columnsThatCorrespondToMeanOrStd <- grep("mean|std", names(mergedData), value = T)
  mergedData <- mergedData[c(columnsThatCorrespondToMeanOrStd, "subject_id", "activity_label")]
}

getMergedData <- function() {
  testData <- getData("test")
  trainData <- getData("train")
  mergedData <- rbind(testData, trainData)
}

getData <- function(folder) {
  path <- paste0("UCI\ HAR\ Dataset/", folder, "/")
  
  xValue <- read.table(paste0(path, "X_", folder, ".txt"))
  columnNames <- getXDataColumnNames()
  names(xValue) <- columnNames
  
  yValue <- read.table(paste0(path, "y_", folder, ".txt"))
  subjectTest <- read.table(paste0(path, "subject_", folder, ".txt"))

  xValue$activity_id <- yValue$V1
  xValue$subject_id <- subjectTest$V1

  activityLabels <- getActivityLabels()
  merge <- merge(xValue, activityLabels, by.x = "activity_id", by.y = "activity_id")
  merge[, -1]
}

getXDataColumnNames <- function() {
  columnNames <- read.table("UCI\ HAR\ Dataset/features.txt")
  columnNames <- columnNames$V2
  columnNames <- paste0(columnNames, "_Mean")
  columnNames <- gsub("[()]", "", columnNames)
  columnNames <- gsub("[-]", "_", columnNames)
  columnNames <- gsub("[,]", "_", columnNames)
  columnNames <- gsub("^t", "timeDomain", columnNames)
  columnNames <- gsub("^f", "frequencyDomain", columnNames)
  columnNames <- gsub("[Aa]cc", "Acceleration", columnNames)
  columnNames <- gsub("[Mm]ag", "Magnitude", columnNames)
}

getActivityData <- function(path, folder) {
  activitylabel <- getActivityLabels()
  yValue <- read.table(paste0(path, "y_", folder, ".txt"))
  names(yValue) <- "activity_id"
  merge <- merge(activitylabel, yValue)
  merge$activity_label
}

getActivityLabels <- function() {
  activityLabels <- read.table("UCI\ HAR\ Dataset/activity_labels.txt")
  names(activityLabels) <- c("activity_id", "activity_label")
  activityLabels
}