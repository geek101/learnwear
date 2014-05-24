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
   "Activity Type" and calculate mean for all the variables and output that set.
   Please refer to ```tidy_data()```. One can also use ```write_tidy_data()``` to output
   the data frame to "tidy_data.txt" file.

 