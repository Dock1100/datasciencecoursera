The script `run_analysis.R` does the following:
- downloads, if needed, the data 
  [Human Activity Recognition Using Smartphones](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- From the data set in previous step, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
- Saves the tidy dataset to csv file.
  
# run_analysis.R

The script requires packages "tools" and "plyr" (it will download them automaticly). Working directory and traget file are setted in variables **data_directory** and **result_file** at the begining of script.

```
data_directory = "./data"
result_file = "./data/tidy_data.txt"
```

Variable list and descriptions
------------------------------

Variable name | Description
--------------|------------
merged        | contains merged data returned by get_prepared_data()
mean_std      | contains mean and standard devalvation values, calculated by get_mean_and_std(arg), with passed argument x of merged data
named_act     | contains data frame with named activites
combined      | contains concatecated data set of mean, standatd devalvation, named activites, merged subjects
tidy         | contains tidy data

# The original data set

The original data set is split into training and test sets where each partition is also split into three files that contain
- measurements from the accelerometer and gyroscope (X_smt)
- activity label (y_smt)
- identifier of the subject (subject_smt)

# Getting and cleaning data

- Merge the training and test sets, they are big, so it`s slow operation. **get_prepared_data**

- Extract mean and standard deviation features. **get_mean_and_std** 
- Replace activity names defined in `activity_labels.txt` in the original data folder. **get_named_activities** `values are hardcoded`
- Create a tidy data set with the average of each variable for
each activity and each subject. The tidy data set is saved to `result_file = "./data/tidy.csv"`.
