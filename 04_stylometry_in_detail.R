# Stylometry in detail

# Welcome!
# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# before you start, install the required packages
# (if a warning is shown above)

# Call the packages
library(stylo)
library(e1071)
# ...you'll have to do it each time you re-start the project

### 1. Explore stylo results

# let's run a basic stylo analysis and save the result to a variable
stylo_result <- stylo(distance.measure="dist.delta",
                      corpus.lang = "English",
                      mfw.min=100, 
                      mfw.max=100)

# explore the result
names(stylo_result)

# see the distance table
distance_table <- stylo_result$distance.table
distance_table <- as.data.frame(distance_table)
View(distance_table)

# see the word frequencies
word_freq <- stylo_result$table.with.all.freqs
word_freq <- as.data.frame(t(word_freq))
View(word_freq)

# see the zeta scores
word_zscores <- stylo_result$table.with.all.zscores
word_zscores <- as.data.frame(t(word_zscores))
View(word_zscores)

### 2. Emulate stylo's procedure (manually)

# first, you need to get just the first 100 z-scores
my_zscores <- t(word_zscores[1:100,])

# then you calculate the distances using the "manhattan" method
# for just two texts (the first two)
my_distance <- dist(my_zscores[c(1,2),], method = "manhattan") / length(my_zscores[1,])
my_distance

# compare it to stylo results
View(distance_table)

### 3. Use machine learning

# identify the text we want to test
my_test_text <- rownames(my_zscores)[1]
my_test_text

# create training set (by deleting information on the test text)
train <- as.data.frame(my_zscores[-which(rownames(my_zscores) == my_test_text),])

# add information on the real authors to the training set
my_authors <- rownames(train)
my_authors <- strsplit(my_authors, "_")
my_authors <- sapply(my_authors, function(x) x[1])
my_authors

train$truth <- as.factor(my_authors)
View(train)

# create test set by selecting just the test text
test <- as.data.frame(t(my_zscores[which(rownames(my_zscores) == my_test_text),]))
View(test)

# then we train the model
model <- svm(train$truth~., train, type = "C")

# and we test it on the new data (test set)
res <- predict(model, newdata=test)
res

#####
# Your turn!
#####

# Make the stylometric analysis on a different corpus
# Three corpora available 
# (all based on ELTeC: https://www.distant-reading.net/eltec/)
# Italian 
# https://bit.ly/4hNdB8A
# French
# https://bit.ly/4j6EKVl
# German
# https://bit.ly/4l5SFMY

# # Suggested procedure
# rename the "corpus" folder in PositCloud (so you are not overwriting it),
# then use the "Upload" button in the "Files" panel
# tip: upload a compressed (.zip) version of the new "corpus" folder,
# as it will be decompressed automatically in PositCloud

# Note: once finished, remember to delete (or rename) the new "corpus" folder
# and restore the original one (with the 12 English texts)
