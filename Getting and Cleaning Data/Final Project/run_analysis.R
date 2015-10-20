
# Install the packages if you dont already have them in R

# Packages 
library(data.table)
library(reshape2)
library(dplyr)


##*****************************************************************************************
##                Downloading and reading the files in          *************************
##*****************************************************************************************
# Download the files from R using download.file() or manually through the link 
#https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
# Unzip the files using any unizip tool 
# Once unizipped all the data files are present in the UCI HAR DATASET


path<-"C:/Users/jaimi/Desktop/github/Main/Getting and Cleaning Data/Final Project Data Files/UCI HAR Dataset"


# List all the files in the UCI HAR DATASET folder

list.files(path)



#'train/subject_train.txt': Each row identifies the subject who performed 
#'the activity for each window sample. Its range is from 1 to 30. 

# Create data frames from the subject train and test files
#Total of 30 subjects which were distributed 70% in the Training dataset and 
# 30% in the TestData set

dataSuTr <- fread(file.path(path, "train", "subject_train.txt"))
dataSuTe <- fread(file.path(path, "test", "subject_test.txt"))

unique(dataSuTe)
#Subject number 2,4,9,10,12,13,18,20,24 were choosen for the testing 
# Rest went in the training dataset


#'train/y_train.txt and y_test.txt': Training labels.
#'six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
# Reading in the activity labels (Y_train and Y_test) files
dataTrLabel <- fread(file.path(path, "train", "Y_train.txt"))
dataTeLabel <- fread(file.path(path, "test", "Y_test.txt"))


#'test, train/X_train and X_test.txt': Training and test set response for the 561 features.

dataresponseTr <- fread(file.path(path, "train", "X_train.txt"))
dataresponseTe <- fread(file.path(path, "test", "X_test.txt"))


###***************************************************************************
###       1-Merging the training and the test-sets   *************************
###***************************************************************************

#Merging all the subject labels of the test and training data
dataSu<-rbind(dataSuTr,dataSuTe)
setnames(dataSu,names(dataSu),"subjectnumber")

#Merging all the activity labels of the test and training data
dataActivityLabel<-rbind(dataTrLabel,dataTeLabel)
setnames(dataActivityLabel,names(dataActivityLabel),"activitynumber")

#Merging the responses for the test and the training datasets

dataresponse<-rbind(dataresponseTr,dataresponseTe)

# Merge the subject number, activity labels and responses into one data table
data <- cbind(cbind(dataSu, dataActivityLabel), dataresponse)

## Sort the dataframe by the ascending order and assign key to the subjectnumber and then activitynumber

setkey(data,subjectnumber,activitynumber)


data[,.N, by=subjectnumber]   ## Check the number of responses each subject has


###***************************************************************************
###       2-Extract only the measurements of the mean and STD   **************
###***************************************************************************

# Read the features.txt file to detwemine which variables in dt are measurements
#for the mean and standard deviation

dataFeatures<-fread(file.path(path,"features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featurenumber", "featurename"))


# Using grep1 and regular expression  the features contating only mean and std
#were matched

dataFeatures<-dataFeatures[grepl("mean\\(|std",featurename)]

#The number of features containing mean and std are 66
totalnoFeautres<-dim(dataFeatures)[1]

#Accessing the feature numbers which had mean and std and converting them to strings 
# to later access the data with only features with mean and std

featureVars<-paste("V",dataFeatures$featurenumber,sep="")


## Subsetting the columns with the mean and std features in addition to the subject
# and activity label 

data<-data[,c(key(data),featureVars),with=FALSE]

##***************************************************************************
##              3-USE DESCRIPTIVE ACTIVITY NAMES        *********************
##***************************************************************************

dataActivityNames <- fread(file.path(path, "activity_labels.txt"))
setnames(dataActivityNames, names(dataActivityNames), c("activitynumber", "activityname"))

data<-merge(dataActivityNames,data,by="activitynumber")

setkey(data,activitynumber,activityname,subjectnumber)




##*******************************************************************************
##           4- Descreptive Variable Names
##********************************************************************************


# Convert the variables names V1,V2..variable names to descreptive names

# To do this we use the names directly from the dataFeatures data table that we had
#created earlier

# So now each variable of the data set has secreptive variable names

setnames(data, names(data), c(key(data),dataFeatures$featurename))


##**********************************************************************************
##*           4-Making the data set tidy                 ***************************
##**********************************************************************************

# First the activitynumber column was removed since its redundant as activity number
#correponds to either of the six activities (walking,walking upstairs..laying etc.)
#activityname column has the same information with description

datatidy<-data[,activitynumber:=NULL]
setkey(datatidy,subjectnumber,activityname)


#The goal of 1] tidy data is that each variable forms a column  2] each observation forms 
# a row 3] Each table/files stores data about one kind of observation

# Right now there are 66 different variables (example: fBodyAccMean(),tBodyACC-mean()-X.....) 
#in our data set. This 66 features should be under one commmon variable which we can call
#features to result in a super long data set with four variable namely 
#activityname,subjectnumber,feature and response


# To carry out that we will melt our dataset

datatidy<-data.table(melt(datatidy,id=key(datatidy),variable.name = "features"))

#Next we make sure all the data is ordered properly by subject number and 
#activity name and feaures

#Using the arrange command of the dplyr package 

datatidy<-arrange(datatidy,subjectnumber,activityname,features)
setkey(datatidy,subjectnumber,activityname,features)

#Final tidy data

datatidyfinal<-datatidy[,list(count=.N,Mean_Feature=mean(value)),by=key(datatidy)]

#convert the variables subject number and activityname to factors
 datatidyfinal$subjectnumber<-factor(datatidyfinal$subjectnumber)
 datatidyfinal$activityname<-factor(datatidyfinal$activityname)

str(datatidyfinal)
