## Expected Project Outcome in Brief

Here are the data for the project:
    
    https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement.
Uses descriptive activity names to name the activities in the data set.
Appropriately labels the data set with descriptive activity names.
Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
Good luck!
    
## Outline of the procedure

    * run_analysis.R takes converts the original data into the tidy data
    * Set the path variable in the run_analysis.R to proper location where the original data is downloaded on        the local matchine
    * The run_analysis.R also provides code for downloading the files. They need to be uncommented for the use.
    * The details of the steps/transformations taken to clean the data are provided in the file codebook.md

# Outcome

    * A tidydataset file called "tidydata.txt" is obtained in a text file using the write.table() and  
      row.name=FALSE
    
    
    
