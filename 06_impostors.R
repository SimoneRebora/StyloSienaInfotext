# The Impostors method

# Welcome!
# This is an R script file, created by Simone
# Everything written after an hashtag is a comment
# Everything else is R code
# To activate the code, place the cursor on the corresponding line
# (or highlight multiple lines/pieces of code) 
# ...and press Ctrl+Enter (or Cmd+Enter for Mac)
# (the command will be automatically copy/pasted into the console)

# Call the packages
library(stylo)
# ...you'll have to do it each time you re-start the project

# load the case study (Galbraith vs. Rowling)
# taken from: https://computationalstylistics.github.io/docs/imposters
data(galbraith)

# get general info
help(galbraith)

# explore the dataset
rownames(galbraith)
colnames(galbraith)
galbraith

# use normal stylo on it
stylo(frequencies = galbraith,
      distance.measure="dist.delta",
      mfw.min=100, 
      mfw.max=100)

# try the impostors
rownames(galbraith)

# indicating the text to be tested (here, "The cuckoo's Calling"):
my_text_to_be_tested = galbraith[8,]

# defining the texts by the candidate author (here, the texts by Coben):
my_candidate = galbraith[1:7,]

# building the reference set by excluding the already-selected rows
my_imposters = galbraith[-c(8, 1:7),]

# launching the imposters method:
imposters(reference.set = my_imposters, test = my_text_to_be_tested, candidate.set = my_candidate)

#####
# Your turn!
#####

# try the impostors with J.K. Rowling as a candidate author

