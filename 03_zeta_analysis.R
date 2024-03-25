# Zeta analysis

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

# first, we need to prepare the corpus by dividing it into two parts

# first, we list all the files in the "corpus" folder
list_files <- list.files("corpus", full.names = T)
list_files

# now we can create two groups (males and females)
male_files <- list_files[4:9]
male_files

female_files <- list_files[c(1:3, 10:12)]
female_files

# then we create two new folders
dir.create("primary_set")
dir.create("secondary_set")

# we create new names for the files to be copied
female_files_new <- gsub(pattern = "corpus/", replacement = "primary_set/", female_files, fixed = T)
male_files_new <- gsub(pattern = "corpus/", replacement = "secondary_set/", male_files, fixed = T)

# then we copy the files!
file.copy(male_files, male_files_new)
file.copy(female_files, female_files_new)

# now that everything is set...
# we can run the Zeta analysis (it's called "oppose" in stylo)
oppose_results <- oppose(text.slice.length = 3000,
       write.png.file = TRUE)

# for the "markers" visualization, you can use just an additional argument
oppose_results <- oppose(text.slice.length = 3000,
       write.png.file = TRUE,
       visualization = "markers")

# we can explore the results
names(oppose_results)

# see the summary of zeta scores (that indicate the positions in the graph)
full_scores <- oppose_results$summary.zeta.scores
full_scores_df <- data.frame(antimarkers = full_scores[,1], markers = full_scores[,2], group = full_scores[,3])
View(full_scores_df)

# important: delete the folders, in case you want to run different analyses
unlink("primary_set/", recursive = T)
unlink("secondary_set/", recursive = T)

#####
# Your turn!
#####

# repeat the whole procedure with a different grouping 
# e.g. Virginia Woolf vs. all the others...
