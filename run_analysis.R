
DATA_DIR_PREFIX<-"UCI HAR Dataset"

get_data <- function(dir)
{
    # first get the set.
    rootdir <- DATA_DIR_PREFIX 
    xydir <- paste(DATA_DIR_PREFIX, dir, sep="/")
    features <- read.table(paste(rootdir, "features.txt", sep="/"))
    activity <- read.table(paste(rootdir, "activity_labels.txt", sep="/"))
    s <- read.table(paste(xydir, "/subject_", dir, ".txt", sep=""))
    x <- read.table(paste(xydir, "/X_", dir, ".txt", sep=""))
    y <- read.table(paste(xydir, "/y_", dir, ".txt", sep=""))
    names(y) <- c("ActivityId")
    names(activity) <- c("Activity Id", "ActivityType")
    
    # Now we have Activity Name in y data, use this from now on
    y_name <- merge(y, activity, all.x=TRUE, sort=F)
    
    # Put the right names for test_x and test_s data.
    names(x) <- as.character(features$V2)
    names(s) <- c("Subject")
    
    
    # Now combine test_s, test_x and test_y_name
    all <- data.frame(s, y_name, x, stringsAsFactors=FALSE)
    names(all) <- c(names(s), names(y_name), names(x))
    all
}

merge_test_train <- function()
{
    d_test <- get_data("test")
    d_train <- get_data("train")
    
    d_all <- rbind(d_test, d_train, stringsAsFactors=FALSE)
    d_all
}

get_mean_std <- function()
{
    # Get the merged data
    d_all <- merge_test_train()
    
    # Now get "ActivityType" column and all columns with std() and mean()
    yc <- c(4, grep("-mean\\(\\)|-std\\(\\)", names(d_all)))
    d_mean_std <- d_all[, yc]
    d_mean_std
}

tidy_data <- function()
{
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
}

write_tidy_data <- function()
{
    # Get tidy data.
    td <- tidy_data()
    
    # Write it to a file.
    write.table(td, file="tidy_data.txt", na="NA", row.names=FALSE)
}

run <- function()
{
    # get mean std data.
    data_m <- get_mean_std()
    
    # write this to a file.
    write.table(data_m, file="mean_std_data.txt", na="NA", row.names=FALSE)
    
    write_tidy_data()
}