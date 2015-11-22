# Getting and Cleaning Data Course Project

## Steps to reproduce
1. Download data file from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip, unzip it and rename the folder with "data".
2. The "data" folder and `run_analysis.R` must both be at same directory.
3. Run script `run_analysis.R`
4. ...
5. PROFIT! // You should get the `output.txt` file with tidy data

## How does it works?
1. Loading data
```r

```

2. Merging data 
```r

```

3. Tiding 
```r

```

4. Generating output
```r
write.table(tidy, "output.txt", row.names = FALSE)
```