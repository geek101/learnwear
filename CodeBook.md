Data Guide
==========

The following tasks are performed to the data

1. For both the types of data i.e "test" and "train" X_/y_ files
   are merged with the content in "activity_labels.txt" and we create
   a final dataframe what also has the "Subject" id for which the measurement
   is taken. Please refer ```get_data()```

2. Once we have the sets from both "test" and "train" directory we merge them
   to a single set using ```rbind()```. Please refer ```merge_test_train()```
   function.

3. The set obtained is used to extrat all columns that have "-mean()" or "-std()"
   column name and that data along with the "Activity Type" is put in a different set.
   Please refer to ```get_mean_std```.

4. To get the tidy data we use the data from step 2 and split it based in "Subject" and
   "Activity Type" and calculate mean/average for all the variables and output that set.
   Please refer to ```tidy_data()```. One can also use ```write_tidy_data()``` to output
   the data frame to "tidy_data.txt" file.


<h2>Details About the Mean/Std dataset "mean_std_data.txt"</h2>

1. The following grep() function is used to get all mean and std variables from the 
   merged dataset.
   ```
    d_all <- merge_test_train()
    
    # Now get "ActivityType" column and all columns with std() and mean()
    yc <- c(4, grep("-mean\\(\\)|-std\\(\\)", names(d_all)))
    d_mean_std <- d_all[, yc]
    d_mean_std
   ```
    
2. The summary of data is as follows.
```
mdata <- read.table("mean_std_data.txt", header=TRUE)
nrow(mdata)
[1] 61795

ncol(mdata)
[1] 67
   
Number of variables is 66.
   
head(mdata,1)
  "ActivityType" "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y"
1      WALKING         0.2571778       -0.02328523 .....

names(mdata)
"ActivityType" "tBodyAcc-mean()-X" "tBodyAcc-mean()-Y" "tBodyAcc-mean()-Z" "tBodyAcc-std()-X" "tBodyAcc-std()-Y" "tBodyAcc-std()-Z" "tGravityAcc-mean()-X" "tGravityAcc-mean()-Y" "tGravityAcc-mean()-Z" "tGravityAcc-std()-X" "tGravityAcc-std()-Y" "tGravityAcc-std()-Z" "tBodyAccJerk-mean()-X" "tBodyAccJerk-mean()-Y" "tBodyAccJerk-mean()-Z" "tBodyAccJerk-std()-X" "tBodyAccJerk-std()-Y" "tBodyAccJerk-std()-Z" "tBodyGyro-mean()-X" "tBodyGyro-mean()-Y" "tBodyGyro-mean()-Z" "tBodyGyro-std()-X" "tBodyGyro-std()-Y" "tBodyGyro-std()-Z" "tBodyGyroJerk-mean()-X" "tBodyGyroJerk-mean()-Y" "tBodyGyroJerk-mean()-Z" "tBodyGyroJerk-std()-X" "tBodyGyroJerk-std()-Y" "tBodyGyroJerk-std()-Z" "tBodyAccMag-mean()" "tBodyAccMag-std()" "tGravityAccMag-mean()" "tGravityAccMag-std()" "tBodyAccJerkMag-mean()" "tBodyAccJerkMag-std()" "tBodyGyroMag-mean()" "tBodyGyroMag-std()" "tBodyGyroJerkMag-mean()" "tBodyGyroJerkMag-std()" "fBodyAcc-mean()-X" "fBodyAcc-mean()-Y" "fBodyAcc-mean()-Z" "fBodyAcc-std()-X" "fBodyAcc-std()-Y" "fBodyAcc-std()-Z" "fBodyAccJerk-mean()-X" "fBodyAccJerk-mean()-Y" "fBodyAccJerk-mean()-Z" "fBodyAccJerk-std()-X" "fBodyAccJerk-std()-Y" "fBodyAccJerk-std()-Z" "fBodyGyro-mean()-X" "fBodyGyro-mean()-Y" "fBodyGyro-mean()-Z" "fBodyGyro-std()-X" "fBodyGyro-std()-Y" "fBodyGyro-std()-Z" "fBodyAccMag-mean()" "fBodyAccMag-std()" "fBodyBodyAccJerkMag-mean()" "fBodyBodyAccJerkMag-std()" "fBodyBodyGyroMag-mean()" "fBodyBodyGyroMag-std()" "fBodyBodyGyroJerkMag-mean()" "fBodyBodyGyroJerkMag-std()" 
```

<h2> Details of Tidy dataset "tidy_data.txt" </h2>

1. The merged data is split and combined as described above.

```
# Get all data
d_all <- merge_test_train()
    
# Split the data frame by Subject and ActivityType" combinations
s <- split(d_all, d_all[, c("Subject", "ActivityType")])

# lets loop through the split data frame and get the mean of all
# data variables
final_d <- data.frame()
names_c <- vector()
for (i in 1:length(s)) {
   d <- s[[i]]
   cmean <- colMeans(d[, c(5:ncol(d))])
   names_c <- paste(names(cmean), "avg", sep="-")
      if (is.nan(cmean) || is.na(cmean))
         next
   cmean<-c(c(d[1,c(1)]), c(d[1, c(4)]), cmean)
   dim(cmean) <- c(1, length(cmean))
   nf <- data.frame(cmean)
   final_d <- rbind(final_d, nf)
}
names(final_d) <- c("Subject", "ActivityType", names_c)
final_d
```

2. Summary of data.

```
tdata <- read.table("tidy_data.txt", header=TRUE)
nrow(tdata)
[1] 180

ncol(tdata)
[1] 563

# Number of variables 561

# List of first few variables/column names

"Subject" "ActivityType" "tBodyAcc-mean()-X-avg" "tBodyAcc-mean()-Y-avg" "tBodyAcc-mean()-Z-avg" 
"tBodyAcc-std()-X-avg" ...

head(tdata, 1)
  "Subject" "ActivityType" "tBodyAcc-mean()-X-avg" "tBodyAcc-mean()-Y-avg" "tBodyAcc-mean()-Z-avg" ...
1       1            1             0.2656969           -0.01829817            -0.1078457 ...
```
