# Getting and Cleaning Data Course Project Code Book

## How does it works?
### Setuping
```r
features <- read.table("data/features.txt")
labels <- read.table("data/activity_labels.txt")

datasets <- c("train", "test")
colNames <- list(
    "X" = features[, 2],
    "subject" = "subject",
    "y" = "Activity"
)
variants <- names(colNames)
```

### Loading data
```r
result <- list()
for (i in seq_along(datasets)) {
    for (j in seq_along(variants)) {
        if (is.null(result[variants[j]])) {
            result[variants[j]] <- data.frame()
        }
        
        tmp <- read.table(
            paste(
                "data/", datasets[i], "/",
                variants[j], "_" , datasets[i], ".txt",
                sep = ""
            )
        )
        
        result[[variants[j]]] <- rbind(result[[variants[j]]], tmp)
    }
}
```

### Setting column names
```r
for (j in seq_along(colNames)) {
    names(result[[j]]) <- colNames[j]
}
```

### Extracting only the measurements on the mean and standard deviation
```r
colNames <- names(result[['X']])
colIndex <- grep("-(mean|std)", colNames)
result[['X']] <- result[['X']][, colIndex]
names(result[['X']]) <- colNames[colIndex, ]
```

### Using descripting activity name
```r
labels <- read.table("data/activity_labels.txt")
result[['y']][,1] <- gsub("_", " ", labels[result[['y']][,1], 2])
```

### Merging data 
```r
clean = cbind(result[['subject']], result[['y']], result[['X']])
```

### Tiding 
```r
tidy <- aggregate(
    clean[, 3:ncol(clean)],
    by = list(clean$Subject, clean$Activity),
    FUN = mean
)
```

### Generating output
```r
write.table(tidy, "output.txt", row.names = FALSE)
```
