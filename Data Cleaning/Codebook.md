## Scripts

* There is only one script, run_analysis.R

## Process

* Download Dataset
 * Pull the dataset from source URL
 * unzip
 * cleanup zip file
* Load Data
 * load features
 * load activities
 * load test data
 * load training data
* Process Data
 * combine subject, test_X, and test_y in test
 * combine subject, train_X, and train_y in to train
 * combine test and train into merge
 * find all features with 'std'
 * find all features with 'mean'
 * find all features that have both a std and mean entry
 * remove merge feature columns that do not have a std & mean entry
 * replace activity codes with activity labels
* Peform Renames
 * Capitalize Subject and Activity
 * Remove double and tripple periods
 * replace f with Frequencey
 * replace t with Time
 * remove duplicate Body labels
* Preform Output
 * Group
 * Summarize
 * Write out Averages.txt

## Variables

* Input Variables
 * features : Initial feature list, codes to labels
 * activities : Initial activities list, codes to labels
 * subject_test : Initial subject list for test data, codes only
 * subject_train : Initial subject list for train data, codes only
 * X_test : Testing Feature Data
 * y_test : Testing Target Data
 * X_train : Training Feature Data
 * y_train : Training Taret Data
* Intermediate Merge Variables
 * test : cbind of activities, X, and y data for testing
 * train : cbind of activities, X, and y data for training
 * mergeData : rbind of test and train
 * meanIdx : index of features with mean labeling
 * avgIdx : index of features with avg labelsing
 * meanLabels : feature names with mean labeling
 * avgLabels : feature naems with avg labeling
 * featureKeys : dataframe containing keys, avg labels, and mean labels for all features that contain both mean and avg
