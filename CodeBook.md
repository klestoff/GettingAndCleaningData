# Getting and Cleaning Data Course Project Code Book

## Variables and it's description
Variable  | Description
----------|-------------


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
#### Prepare
```r
subs = unique(clean$Subject)
acts = unique(clean$Activity)

tidy = 
    as.data.frame(
        matrix(
            nrow = length(subs) * length(acts),
            ncol = ncol(clean)
        )
    )
```

#### Processing
```r
row = 1
for (i in seq_along(subs)) {
    for (j in seq_along(acts)) {
        tidy[row, 1] <- subs[i]
        tidy[row, 2] <- acts[j]
        tidy[row, 3:ncol(clean)] <-
            colMeans(
                clean[
                    clean$Subject == subs[i] &
                    clean$Activity == acts[j],
                    3:ncol(clean)
                ],
                na.rm = TRUE
            )
            
        row = row + 1
    }
}
```

### Generating output
```r
write.table(tidy, "output.txt", row.names = FALSE)
```