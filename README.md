Getting and Cleaning Data Final Project
=======================================

This run_analysis.R script is a script that will take the training and test data and merge them together and then further clean the data.

# Usage
First one must download the UCI Har dataset from

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

and unzip it into the root of their workspace. Next one must make sure they have the dyplr package installed. When the run_analysis.R script is sourced, then one can create a tidy data set by calling the getTidyDataSet function.


# How we clean the data
Below we will describe the steps in order of how we process the data.

## Methods

### Getting the data
First we fetch the X data set for the test data. Then before we do anything else we read in the column names from features.txt. When we read in those column names we clean the column names in the following way
- We append "_Mean" at the end because once we fully tidy the data, then the values of the rows associated with the column will be an average.
- We remove parentheses
- We replace dashes with underscores which was done to improve readability
- We replace commas with underscores which was done to imporve readability
- We replace the beginning t with timeDomain as to make the column's purpose clearer
- We replace the beggining f with frequencyDomain as to make the column's purpose clearer
- We replace occurences of acc and Acc with Accerlation to improve the column's readability
- We replace occurnces of mag and Mag with Magnitude to imporve the column's readability

After we clean the columns we read in the y_test.txt and append that to the previous data frame under the column name activity_id. We do the same with subject_test.txt and append it as a column named subject_id. Finally, to associate each row with it's activity label we read in the activity_labels.txt and call the merge command where we join on the activity_id column. When we return the data frame we drop the activity_id column as it's not longer needed since we have access to the activity_label information.

### Processing the data
We repeat the above described process for the training data as well. To merge the data frames we simply call rbind on the test data and training data. Now we are only interested in the columns that calculations for mean and standard deviation. So we find the columns that contain either mean or std using grep with the value argument set to TRUE. With that we select all those columns as well as the subject_id and activty_label columns as they are needed later for further processing.

Next, we are interested in summarizing the data for each subject_id and each activity_label. There are 30 subjects and 6 labels which implies we expect the summarized data set to contain 180 rows. Using the dplyr package we group by subject_id and then activity_label which we chain into the summarize_each command where we pass in the function mean which will take the the mean of the rows associated with each of the groups.# CourseraCleaningDataCourseProject
