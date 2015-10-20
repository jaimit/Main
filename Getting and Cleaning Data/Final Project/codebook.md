CodeBook
=====================================================

The final tidydata set has the following variables.
------------------------------

Variable name    | Description
-----------------|------------
subjectnumber    | Id of particular person who performed activity. (Range: 1-30)
activitynumber   | Activity type: WALKING, WALKING UPSTAIRS, WALKING DOWNSTAIRS, SITTING, STANDING, LAYING
feature          | Type of the feature listed below
count            | Total number of counts of observation of particular feature for each activity and subject in                  | original data
mean_feature     | Average value of each feature for each activity and each subject





Accelerometer and gyroscoper 3-axial raw signals were modified to get 561 features in the original data
Out of those, only the features with mean and std of different signals were extracted in the tidy data
The extracted features which makes the feature variable of the tidy data are listed below

* 'Acc':in the feature name denote the signal was obatined from a accelerometer. Separated into acceleration
        due to 'body' and 'gravity'
* 'Gryro':in the feature name denote the signal was obtained from a gryoscope. Only 'body' component
* '-XYZ' : denote 3-axial signals
* 't': at the start of the feature name denote time domain signal
* 'f': at the start of the feature name denote frequency domain signal
* 'Jerk': Jerk signals were obtained from body linear acceleration and velocity
* 'Mag' : denote the features with Magnitude of some of the three dimensional signals calculated using
          the euclidean norm
          
**featurename in the original dataset**  | **featurenumber**
------------- | -------------
1  | tBodyAcc-mean()-X
2 | tBodyAcc-mean()-Y
3 | tBodyAcc-mean()-Z
4 | tBodyAcc-std()-X
5 | tBodyAcc-std()-Y
6 | tBodyAcc-std()-Z
41| tGravityAcc-mean()-X
42| tGravityAcc-mean()-Y
43| tGravityAcc-mean()-Z
44| tGravityAcc-std()-X
45| tGravityAcc-std()-Y
46| tGravityAcc-std()-Z
81| tBodyAccJerk-mean()-X
82| tBodyAccJerk-mean()-Y
83| tBodyAccJerk-mean()-Z
84| tBodyAccJerk-std()-X
85| tBodyAccJerk-std()-Y
86| tBodyAccJerk-std()-Z
121| tBodyGyro-mean()-X
122| tBodyGyro-mean()-Y
123| tBodyGyro-mean()-Z
124| tBodyGyro-std()-X
125| tBodyGyro-std()-Y
126| tBodyGyro-std()-Z
161| tBodyGyroJerk-mean()-X
162| tBodyGyroJerk-mean()-Y
163| tBodyGyroJerk-mean()-Z
164| tBodyGyroJerk-std()-X
165| tBodyGyroJerk-std()-Y
166| tBodyGyroJerk-std()-Z
201| tBodyAccMag-mean()
202| tBodyAccMag-std()
214| tGravityAccMag-mean()
215| tGravityAccMag-std()
227| tBodyAccJerkMag-mean()
228| tBodyAccJerkMag-std()
240| tBodyGyroMag-mean()
241| tBodyGyroMag-std()
253| tBodyGyroJerkMag-mean()
254| tBodyGyroJerkMag-std()
266| fBodyAcc-mean()-X
267| fBodyAcc-mean()-Y
268| fBodyAcc-mean()-Z
269| fBodyAcc-std()-X
270| fBodyAcc-std()-Y
271| fBodyAcc-std()-Z
345| fBodyAccJerk-mean()-X
346| fBodyAccJerk-mean()-Y
347| fBodyAccJerk-mean()-Z
348| fBodyAccJerk-std()-X
349| fBodyAccJerk-std()-Y
350| fBodyAccJerk-std()-Z
424| fBodyGyro-mean()-X
425| fBodyGyro-mean()-Y  
426| fBodyGyro-mean()-Z
427| fBodyGyro-std()-X
428| fBodyGyro-std()-Y
429| fBodyGyro-std()-Z  
503| fBodyAccMag-mean()
504| fBodyAccMag-std()
516| fBodyBodyAccJerkMag-mean()
517| fBodyBodyAccJerkMag-std()
529| fBodyBodyGyroMag-mean()
530| fBodyBodyGyroMag-std()
542| fBodyBodyGyroJerkMag-mean()
543| fBodyGyroJerkMag-std()

     
        

The complete list of variables of each feature vector is available in 'features.txt' of the original data.

The summary of the tidy data is presented at the end of the codebook

# Transformation/Steps Carried out to get the tidy/clean Data

Install the packages if you dont already have them in R

```r
# Packages 
library(data.table)
library(reshape2)
library(dplyr)
```
###*****************************************************************************************
###                Downloading and reading the files in          ***************************
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
```


##Final tidy data


```r
datatidyfinal<-group_by(datatidy,subjectnumber,activityname,features)
datatidyfinal<- summarise(datatidyfinal,count=.N,mean=mean(value))

#Alternate way 

#datatidy%>%
#           group_by(subjectnumber,activityname,features)%>%
#                                   summarise(count=.N,mean=mean(value))
```



convert the variables subject number and activityname to factors


```r
 datatidyfinal$subjectnumber<-factor(datatidyfinal$subjectnumber)
 datatidyfinal$activityname<-factor(datatidyfinal$activityname)
```
# Summary of the dataset using Str 

```r
 datatidyfinal
```

```
## Source: local data table [11,880 x 5]
## Groups: subjectnumber, activityname
## 
##    subjectnumber activityname             features count        mean
##           (fctr)       (fctr)               (fctr) (int)       (dbl)
## 1              1       LAYING    tBodyAcc-mean()-X    50  0.22159824
## 2              1       LAYING    tBodyAcc-mean()-Y    50 -0.04051395
## 3              1       LAYING    tBodyAcc-mean()-Z    50 -0.11320355
## 4              1       LAYING     tBodyAcc-std()-X    50 -0.92805647
## 5              1       LAYING     tBodyAcc-std()-Y    50 -0.83682741
## 6              1       LAYING     tBodyAcc-std()-Z    50 -0.82606140
## 7              1       LAYING tGravityAcc-mean()-X    50 -0.24888180
## 8              1       LAYING tGravityAcc-mean()-Y    50  0.70554977
## 9              1       LAYING tGravityAcc-mean()-Z    50  0.44581772
## 10             1       LAYING  tGravityAcc-std()-X    50 -0.89683002
## ..           ...          ...                  ...   ...         ...
```

```r
 str(datatidyfinal)
```

```
## Classes 'grouped_dt', 'tbl_dt', 'tbl', 'tbl_dt', 'tbl', 'data.table' and 'data.frame':	11880 obs. of  5 variables:
##  $ subjectnumber: Factor w/ 30 levels "1","2","3","4",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ activityname : Factor w/ 6 levels "LAYING","SITTING",..: 1 1 1 1 1 1 1 1 1 1 ...
##  $ features     : Factor w/ 66 levels "tBodyAcc-mean()-X",..: 1 2 3 4 5 6 7 8 9 10 ...
##  $ count        : int  50 50 50 50 50 50 50 50 50 50 ...
##  $ mean         : num  0.2216 -0.0405 -0.1132 -0.9281 -0.8368 ...
##  - attr(*, ".internal.selfref")=<externalptr> 
##  - attr(*, "vars")=List of 2
##   ..$ : symbol subjectnumber
##   ..$ : symbol activityname
```


##Few rows of the dataset

```r
datatidyfinal
```

```
## Source: local data table [11,880 x 5]
## Groups: subjectnumber, activityname
## 
##    subjectnumber activityname             features count        mean
##           (fctr)       (fctr)               (fctr) (int)       (dbl)
## 1              1       LAYING    tBodyAcc-mean()-X    50  0.22159824
## 2              1       LAYING    tBodyAcc-mean()-Y    50 -0.04051395
## 3              1       LAYING    tBodyAcc-mean()-Z    50 -0.11320355
## 4              1       LAYING     tBodyAcc-std()-X    50 -0.92805647
## 5              1       LAYING     tBodyAcc-std()-Y    50 -0.83682741
## 6              1       LAYING     tBodyAcc-std()-Z    50 -0.82606140
## 7              1       LAYING tGravityAcc-mean()-X    50 -0.24888180
## 8              1       LAYING tGravityAcc-mean()-Y    50  0.70554977
## 9              1       LAYING tGravityAcc-mean()-Z    50  0.44581772
## 10             1       LAYING  tGravityAcc-std()-X    50 -0.89683002
## ..           ...          ...                  ...   ...         ...
```

##Summary of the dataset


```r
summary(datatidyfinal)
```

```
##  subjectnumber              activityname               features    
##  1      : 396   LAYING            :1980   tBodyAcc-mean()-X:  180  
##  2      : 396   SITTING           :1980   tBodyAcc-mean()-Y:  180  
##  3      : 396   STANDING          :1980   tBodyAcc-mean()-Z:  180  
##  4      : 396   WALKING           :1980   tBodyAcc-std()-X :  180  
##  5      : 396   WALKING_DOWNSTAIRS:1980   tBodyAcc-std()-Y :  180  
##  6      : 396   WALKING_UPSTAIRS  :1980   tBodyAcc-std()-Z :  180  
##  (Other):9504                             (Other)          :10800  
##      count            mean         
##  Min.   :36.00   Min.   :-0.99767  
##  1st Qu.:49.00   1st Qu.:-0.96205  
##  Median :54.50   Median :-0.46989  
##  Mean   :57.22   Mean   :-0.48436  
##  3rd Qu.:63.25   3rd Qu.:-0.07836  
##  Max.   :95.00   Max.   : 0.97451  
## 
```


