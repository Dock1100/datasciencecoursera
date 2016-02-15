data_directory = "./data"
result_file = "./data/tidy_data.txt"


# concatenates file name with data_directory
get_sub_name <- function(b){
  return(paste(data_directory, b, sep = ""))
}

lazy_install <- function(package_name){
  print(paste("checking package", package_name))
  if(!(package_name %in% rownames(installed.packages()))){
    install.packages(package_name)
  }  
  library(package_name, character.only = TRUE)
}

download_data <- function() {
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  archive <- "/getdata-projectfiles-UCI HAR Dataset.zip"
  archive <- get_sub_name(archive)
  print("checking data archive")
  if (!file.exists(archive)) {
    if (!file.exists(data_directory)) {
      dir.create(data_directory)
      print(paste("working directory ", file_path_as_absolute(data_directory)))
    }
    print("downloading...")
    download.file(url, destfile=archive, mode="wb")
    print(paste("working archive ", file_path_as_absolute(archive)))
    unzip(archive, exdir=data_directory)
  } else {
    print("archive already downloaded")
  }
}

get_prepared_data <- function(){
  print("Reading train and test data")
  x_train <- read.table(get_sub_name("/UCI HAR Dataset/train/X_train.txt"))
  y_train <- read.table(get_sub_name("/UCI HAR Dataset/train/y_train.txt"))
  subject_train <- read.table(get_sub_name("/UCI HAR Dataset/train/subject_train.txt"))
  x_test <- read.table(get_sub_name("/UCI HAR Dataset/test/X_test.txt"))
  y_test <- read.table(get_sub_name("/UCI HAR Dataset/test/y_test.txt"))
  subject_test <- read.table(get_sub_name("/UCI HAR Dataset/test/subject_test.txt"))
  print("Merging train and test data")
  x_merge <- rbind(x_train, x_test)
  y_merge <- rbind(y_train, y_test)
  subject_merge <- rbind(subject_train, subject_test)
  return(list(x=x_merge, y=y_merge, subject=subject_merge))
}

get_mean_and_std <- function(df) {
  print("Reading features")
  features <- read.table(get_sub_name("/UCI HAR Dataset/features.txt"))
  mean_col <- sapply(features[,2], function(x) grepl("mean()", x, fixed=T))
  std_col <- sapply(features[,2], function(x) grepl("std()", x, fixed=T))
  result <- df[, (mean_col | std_col)]
  colnames(result) <- features[(mean_col | std_col), 2]
  return(result)
}

get_named_activities <- function(df) {
  colnames(df) <- "activity"
  df$activity[df$activity == 1] = "WALKING"
  df$activity[df$activity == 2] = "WALKING_UPSTAIRS"
  df$activity[df$activity == 3] = "WALKING_DOWNSTAIRS"
  df$activity[df$activity == 4] = "SITTING"
  df$activity[df$activity == 5] = "STANDING"
  df$activity[df$activity == 6] = "LAYING"
  return (df)
}

lazy_install("tools")
lazy_install("plyr")

download_data()
merged = get_prepared_data()
mean_std = get_mean_and_std(merged$x)
named_act = get_named_activities(merged$y)
colnames(merged$subject) <- c("subject")
combined = cbind(mean_std, named_act, merged$subject)
tidy <- ddply(combined, .(subject, activity), function(x) colMeans(x[,1:60]))
write.csv(tidy, result_file, row.names=FALSE)
print(paste("Result file ", file_path_as_absolute(result_file)))
