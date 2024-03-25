# Rolling Stylometry

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
# ...you'll have to do it each time you re-start the project

# before starting the procedure, read documentation:
# https://computationalstylistics.github.io/blog/rolling_stylometry/

# important: we'll need the data in two folders
# "test_set" for the text to analyse
# "reference_set" for the reference texts

# first, we create the new folders (empty)
dir.create("test_set")
dir.create("reference_set")

# we list all files in the "corpus" folder
list_files <- list.files("corpus", full.names = T)
list_files

# we create new names for the files to be copied
list_files_new <- gsub(pattern = "corpus/", replacement = "reference_set/", list_files, fixed = T)

# then we copy the files!
file.copy(list_files, list_files_new)

# finally, we copy our test file
file.copy("materials/Woolf_Orlando_1928.txt", "test_set/My_text.txt")
# as it's only one, we can do it with a single command

# now, we are ready to call the rolling stylometry function
rolling_results <- rolling.classify(classification.method = "delta", 
                 slice.size = 5000, 
                 slice.overlap = 4500,
                 mfw=2000,
                 write.png.file = TRUE) 

# let's examine the results
names(rolling_results)

# see the rankings
rolling_results$classification.rankings

# see the scores
rolling_results$classification.scores

# let's try with a different selection of MFW
rolling_results <- rolling.classify(classification.method = "delta", 
                                    slice.size = 5000, 
                                    slice.overlap = 4500,
                                    mfw=100,
                                    write.png.file = TRUE) 

# important: delete the folders, in case you want to run different analyses
unlink("reference_set/", recursive = T)
unlink("test_set/", recursive = T)

#####
# Your turn!
#####

# repeat the whole procedure with the "Woolf_Pastiche.txt" file 
# in the "materials" folder
# ...who is the intruder in "Orlando"?
