# The number of train and test records, respectively.
# Setting them with smaller values (say, 100) allows the script to run faster for testing purposes
NTRAIN <- 7352
NTEST <- 2947

# 1. Merges the training and the test sets to create one data set.
# Read training dataset
train <- read.table("../Data/train/X_train.txt", sep="", header=F, nrows=NTRAIN)

# Read testing dataset
test <- read.table("../Data/test/X_test.txt", sep="", header=F, nrows=NTEST)

# Merge train & test dataset
all <- rbind(train, test)

# Remove variables train and test to save space, as they are no longer needed
remove(train)
remove(test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

# Read the feature names
features <- read.table("../Data/features.txt", sep="", header=F, stringsAsFactors=F)
features <- features$V2

# Find the columns with mean and std. Use "mean\(" instead of just "mean" to exclude features meanFreq()
good_columns <- grep("mean\\(|std", features, ignore.case=T)

# Select only mean & std columns
all <- all[, good_columns]

# Give headings to the combined dataset
names(all) <- features[good_columns]

# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive activity names. 

# Read the activity labels:
activity_labels <- read.table("../Data/activity_labels.txt", sep="", header=F)
activity_labels <- activity_labels$V2

# Read y_train and y_test
y_train <- read.table("../Data/train/y_train.txt", sep="", header=F, nrows=NTRAIN)
y_test <- read.table("../Data/test/y_test.txt", sep="", header=F, nrows=NTEST)
y_all <- rbind(y_train, y_test)

# Add column to all
all[,"Activity"] <- lapply(y_all, function(t) { activity_labels[t] })

# Remove y_all, y_train, y_test as they are no longer needed
remove(y_all)
remove(y_train)
remove(y_test)

# Read the subject
subject_train <- read.table("../Data/train/subject_train.txt", sep="", header=F, nrows=NTRAIN)
subject_test <- read.table("../Data/test/subject_test.txt", sep="", header=F, nrows=NTEST)
subject_all <- rbind(subject_train, subject_test)
all[,"Subject"] <- subject_all

# Remove subject_train, subject_test, subject_all as they are no longer needed
remove(subject_all)
remove(subject_train)
remove(subject_test)

# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.
tidy <- aggregate(all[,c(1:66)], by=list(all$Activity, all$Subject), FUN=mean)

# Rename column 1 and 2 of tidy (from Group.1 to Activity and Group.2 to Subject)
colnames(tidy)[1] <- "Activity"
colnames(tidy)[2] <- "Subject"

# Store the tidied data
write.table(tidy, "tidy_data.txt")