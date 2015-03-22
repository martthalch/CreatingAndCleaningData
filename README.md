# CreatingAndCleaningData
The repo constains the following script:

- run _analysis.R:
This scriptrequires for ou to have unzipped the "UCI HAR Dataset". The working directory for this script should be the folder "UCI HAR Dataset"

This script takes all the test and train data from the data set and merges it into a big data set.
The columns that are kept are those related to STD deviation and mean.

The script generates a txt file called "tidy.txt". This file contains the means of all the columns by test subject and by activity
