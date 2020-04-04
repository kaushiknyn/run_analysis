# run_analysis
Repository for the run analysis project for Course 3 - getting and cleaning data

The script is coded in a pretty straight forward way works as follows:
1. The code starts off by installing the data. table and reshape2 packages, downloads and unzips the run analysis data folder
2. It reads in the activity.txt file and adds column lables to it
3. It then reads in the features.txt file and adds column lables to it
4. It then filters down the features data to the ones that corresponds to mean and standard deviation along with a little more cleaning resulting in the measurements vector
5. Then the train (X_train.txt) data is imported
6. The column names are assigned to the train data from the measurements vector 
7. The train data is appended with the train activities (y_train.txt) and subject data (subject_data.txt)
8. Steps 5,6,7 are repeated for the test data as well
9. The train and the test data are merged to form one combined dataset
10. The values in the "Activity" column are then matched with the activityName from the trainActivities dataset and coverted into a factor variable
11. The SubjectNum column is also converted into a factor variable
12. The combined dataset is then aggregated use the reshape2 functions melt and dcast to display the mean of each variable by SubjetNum and Activity
