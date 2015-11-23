# Usefull data 
features <- read.table("data/features.txt")

# Datasets and variants
datasets <- c("train", "test")
colNames <- list(
    "X" = features[, 2],
    "subject" = "Subject",
    "y" = "Activity"
)
variants <- names(colNames)

# Reading data by variants and store to list
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

# Setting column names
for (j in seq_along(colNames)) {
    names(result[[j]]) <- colNames[[j]]
}

# Extracting only the measurements on the mean and standard deviation
colNames <- names(result[['X']])
colIndex <- grep("-(mean|std)", colNames)
result[['X']] <- result[['X']][, colIndex]
names(result[['X']]) <- colNames[colIndex]

# Using descriptive activity names
labels <- read.table("data/activity_labels.txt")
result[['y']][, 1] <- gsub("_", " ", labels[result[['y']][,1], 2])

# Clean data getted
clean = cbind(result[['subject']], result[['y']], result[['X']])
#write.table(clean, "output.clean.txt", row.names = FALSE)

# Cleaning
rm(list = c("result", "features", "labels", "datasets", "colNames", "colIndex", "variants", "i", "j", "tmp"))

# Tiding data
tidy <- aggregate(
    clean[, 3:ncol(clean)],
    by = list(clean$Subject, clean$Activity),
    FUN = mean
)
tidy <- tidy[order(tidy[1], tidy[2]), ]

# Output
write.table(tidy, "output.txt", row.names = FALSE)