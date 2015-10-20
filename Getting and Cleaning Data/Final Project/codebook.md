
Install the packages if you dont already have them in R

```r
# Packages 
library(data.table)
library(reshape2)
library(dplyr)
```




###*****************************************************************************************
###                Downloading and reading the files in          *************************
###*****************************************************************************************
Download the files from R using download.file() or manually through the link 
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
Unzip the files using any unizip tool 
Once unizipped all the data files are present in the UCI HAR DATASET


```r
path<-"C:/Users/jaimi/Desktop/github/Main/Getting and Cleaning Data/Final Project Data Files/UCI HAR Dataset"
```

List all the files in the UCI HAR DATASET folder

```r
list.files(path)
```

```
## [1] "activity_labels.txt" "features.txt"        "features_info.txt"  
## [4] "README.txt"          "test"                "train"
```



'train/subject_train.txt': Each row identifies the subject who performed 
'the activity for each window sample. Its range is from 1 to 30. 

 Create data frames from the subject train and test files
 Total of 30 subjects which were distributed 70% in the Training dataset and 
 30% in the TestData set


```r
dataSuTr <- fread(file.path(path, "train", "subject_train.txt"))
dataSuTe <- fread(file.path(path, "test", "subject_test.txt"))

unique(dataSuTe)
```

```
##    V1
## 1:  2
## 2:  4
## 3:  9
## 4: 10
## 5: 12
## 6: 13
## 7: 18
## 8: 20
## 9: 24
```


Subject number 2,4,9,10,12,13,18,20,24 were choosen for the testing 
Rest went in the training dataset


'train/y_train.txt and y_test.txt': Training labels.
'six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING)
Reading in the activity labels (Y_train and Y_test) files


```r
dataTrLabel <- fread(file.path(path, "train", "Y_train.txt"))
dataTeLabel <- fread(file.path(path, "test", "Y_test.txt"))
```



'test, train/X_train and X_test.txt': Training and test set response for the 561 features.


```r
dataresponseTr <- fread(file.path(path, "train", "X_train.txt"))
dataresponseTe <- fread(file.path(path, "test", "X_test.txt"))
```




###***************************************************************************
###       1-Merging the training and the test-sets   *************************
###***************************************************************************

Merging all the subject labels of the test and training data


```r
dataSu<-rbind(dataSuTr,dataSuTe)
setnames(dataSu,names(dataSu),"subjectnumber")
```


Merging all the activity labels of the test and training data


```r
dataActivityLabel<-rbind(dataTrLabel,dataTeLabel)
setnames(dataActivityLabel,names(dataActivityLabel),"activitynumber")
```



Merging the responses for the test and the training datasets


```r
dataresponse<-rbind(dataresponseTr,dataresponseTe)
```


Merge the subject number, activity labels and responses into one data table


```r
data <- cbind(cbind(dataSu, dataActivityLabel), dataresponse)
```



Sort the dataframe by the ascending order and assign key to the subjectnumber and then activitynumber


```r
setkey(data,subjectnumber,activitynumber)


data[,.N, by=subjectnumber]   ## Check the number of responses each subject has
```

```
##     subjectnumber   N
##  1:             1 347
##  2:             2 302
##  3:             3 341
##  4:             4 317
##  5:             5 302
##  6:             6 325
##  7:             7 308
##  8:             8 281
##  9:             9 288
## 10:            10 294
## 11:            11 316
## 12:            12 320
## 13:            13 327
## 14:            14 323
## 15:            15 328
## 16:            16 366
## 17:            17 368
## 18:            18 364
## 19:            19 360
## 20:            20 354
## 21:            21 408
## 22:            22 321
## 23:            23 372
## 24:            24 381
## 25:            25 409
## 26:            26 392
## 27:            27 376
## 28:            28 382
## 29:            29 344
## 30:            30 383
##     subjectnumber   N
```




###***************************************************************************
###       2-Extract only the measurements of the mean and STD   **************
###***************************************************************************

Read the features.txt file to detwemine which variables in dt are measurements
for the mean and standard deviation

```r
dataFeatures<-fread(file.path(path,"features.txt"))
setnames(dataFeatures, names(dataFeatures), c("featurenumber", "featurename"))
```

Using grep1 and regular expression  the features contating only mean and std
were matched


```r
dataFeatures<-dataFeatures[grepl("mean\\(|std",featurename)]
```

The number of features containing mean and std are 66


```r
totalnoFeautres<-dim(dataFeatures)[1]
totalnoFeautres
```

```
## [1] 66
```



Accessing the feature numbers which had mean and std and converting them to strings 
to later access the data with only features with mean and std


```r
featureVars<-paste("V",dataFeatures$featurenumber,sep="")
```




Subsetting the columns with the mean and std features in addition to the subject
and activity label



```r
data<-data[,c(key(data),featureVars),with=FALSE]
```



###***************************************************************************
###              3-USE DESCRIPTIVE ACTIVITY NAMES        *********************
###***************************************************************************

```r
dataActivityNames <- fread(file.path(path, "activity_labels.txt"))
setnames(dataActivityNames, names(dataActivityNames), c("activitynumber", "activityname"))

data<-merge(dataActivityNames,data,by="activitynumber")

setkey(data,activitynumber,activityname,subjectnumber)
```


###*******************************************************************************
###           4- Descreptive Variable Names
###********************************************************************************


Convert the variables names V1,V2..variable names to descreptive names

To do this we use the names directly from the dataFeatures data table that we had
created earlier
So now each variable of the data set has secreptive variable names


```r
setnames(data, names(data), c(key(data),dataFeatures$featurename))
```





###**********************************************************************************
###            4-Making the data set tidy                 ***************************
###**********************************************************************************

First the activitynumber column was removed since its redundant as activity number
correponds to either of the six activities (walking,walking upstairs..laying etc.)
activityname column has the same information with description


```r
datatidy<-data[,activitynumber:=NULL]
setkey(datatidy,subjectnumber,activityname)
```


The goal of 

* tidy data is that each variable forms a column  
* each observation forms a row 
* Each table/files stores data about one kind of observation

Right now there are 66 different variables (example: fBodyAccMean(),tBodyACC-mean()-X.....) 
in our data set. This 66 features should be under one commmon variable which we can call
Features to result in a super long data set with four variable namely 
activityname,subjectnumber,feature and response

**To carry out that we will melt our dataset**


```r
datatidy<-data.table(melt(datatidy,id=key(datatidy),variable.name = "features"))
```

Next we make sure all the data is ordered properly by subject number and 
activity name and feaures

Using the arrange command of the dplyr package 



```r
datatidy<-arrange(datatidy,subjectnumber,activityname,features)
setkey(datatidy,subjectnumber,activityname,features)
```


##Final tidy data


```r
datatidyfinal<-datatidy[,list(count=.N,Mean_Feature=mean(value)),by=key(datatidy)]
```



convert the variables subject number and activityname to factors


```r
 datatidyfinal$subjectnumber<-factor(datatidyfinal$subjectnumber)
 datatidyfinal$activityname<-factor(datatidyfinal$activityname)
 str(datatidyfinal)
```

```
## Classes 'data.table' and 'data.frame':	11880 obs. of  5 variables:
##  $ subjectnumber: Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ activityname : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ features     : Factor w/ 66 levels "tBodyAcc-mean()-X",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ count        : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ Mean_Feature : num  0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...
##  - attr(*, ".internal.selfref")=<externalptr>
```


