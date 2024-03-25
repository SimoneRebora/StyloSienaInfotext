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
library(irr)
library(e1071)
library(tidyverse)
library(reshape2)
# ...you'll have to do it each time you re-start the project

### 1. Explore stylo results

# let's run a basic stylo analysis and save the result to a variable
stylo_result <- stylo(distance.measure="dist.delta",
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
my_distance = dist(my_zscores[c(1,2),], method = "manhattan") / length(my_zscores[1,])
my_distance

# for all texts
all_distances = dist(my_zscores, method = "manhattan") / length(my_zscores[1,])
all_distances

# create the dendrogram (manually)
plot(hclust(all_distances, method = "ward.D"))

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

# try to make a prediction for a different text
# you will have to re-run just the last lines of code 
# (i.e. the "Use machine learning" section)
# ...by changing a little piece

### 4. Make a graph like in the Harry Potter experiment

# first, let's select just the first ten z-scores
zscores_map <- word_zscores[1:10,]

# then we add the names
zscores_map$words <- rownames(zscores_map)

# ...and we "melt" the table
zscores_map <- melt(zscores_map)
colnames(zscores_map) <- c("word", "text", "z_score")
View(zscores_map)

# finally, we can create the plot
p1 <- ggplot(data = zscores_map) + 
  geom_bar(mapping = aes(x = word, y = z_score), stat = "identity") + 
  facet_wrap(~ text, nrow = 12) +
  labs(x = "most frequent words")

p1

# we save it in a good format (to make it readable)
ggsave(p1, filename = "Zscores_map.png", width = 4, height = 20)

### 5. Find most distinctive words

# select just the text that are clustering (e.g. Charlotte Bronte)
my_texts <- 1:3

zeta_scores <- stylo_result$table.with.all.zscores
zeta_scores <- zeta_scores[my_texts,1:100]

# calculate variance for each set of zeta scores (per word)
my_variance <- numeric()

for(i in 1:dim(zeta_scores)[2]){
  
  my_variance[i] <- mean(abs(zeta_scores[,i] - mean(zeta_scores[,i])))
  
  
}

# reorder the table based on the variance
zeta_scores <- as.data.frame(t(zeta_scores))
zeta_scores$variance <- my_variance
zeta_scores <- zeta_scores[order(zeta_scores$variance),]
View(zeta_scores)

# join variance info to the words
zeta_scores$word <- paste(rownames(zeta_scores), " (variance ", round(zeta_scores$variance, 2), ")", sep = "")
zeta_scores$variance <- NULL

# prepare first visualization (10 words with least variance)
zeta_scores_m <- melt(zeta_scores[1:10,], id.vars = "word", value.name = "zeta_value", variable.name = "Style")
zeta_scores_m$word <- factor(zeta_scores_m$word, levels = zeta_scores$word[1:10])

# make the plot
p1 <- ggplot(zeta_scores_m, aes(x = Style, y = zeta_value)) +
  geom_bar(stat = "identity") +
  facet_wrap(~word, nrow = 2) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  xlab(NULL)

p1

# save it
ggsave(p1, filename = "Zeta_pos.png", width = 14, height = 10, scale = 0.6)

#####
# Your turn!
#####

# find the most distinctive words for another author