# packages only need to be installed once per dev machine
#install.packages("jsonlite")
#install.packages("httr")

library(jsonlite)
library(httr)
library(dplyr)

# Make a variable base.url that has the same base url from the poke api documentation.
# (Hint: visit http://pokeapi.co/ to find the base url)
baseurl <- ("http://pokeapi.co/api/v2")

# Make a variable called movie that has the names of your favorite pokemon
# be aware of casing! 
# There are multiple ways to call the pokemon. What are the 2 ways you can call 
# it with the Poke API? 
movie <- ("oddish")


# Make a variable called pokemon url that holds your favorite pokemon's url 
pokemon.url <- paste0(baseurl, "/pokemon/", movie, "/") %>% print()

# Use the GET function to call the url, store it in a variable called response
response <- GET(pokemon.url)

# Use the names function to learn more response. Print it out. It will return a list of ten 
# names within the response object. You can think of the list names as column names. 
names(response)

# Within the printed list the most important values we are looking at is 
# 'status_code'. It will tell us if our API worked with the network. 
# Be sure that the code is working by checking it with this page. 
# https://en.wikipedia.org/wiki/List_of_HTTP_status_codes
# hint: remeber you can call this similar to how you would call a column!
print(response$status_code)


# Now that you have confirmed your URL is working, let's read in the JSON file
# create a variable body that stores the data from the URL
# what function did we use to extract the data from response?
body <- content(response, "text")


# create a variable poke.data that will convert the JSON string into a list
poke.data <- fromJSON(body)

# Print out the keys from the poke.data by using the names function
names(poke.data)

# Check if poke.data is a data frame. Print that value.
is.data.frame(poke.data) %>% print()

# Check if moves in poke.data is a data frame. Moves is one of the many keys stored in this
# JSON object. How would you call moves? Print that value.
is.data.frame(poke.data$moves) %>% print()

# Food for thought
# What do you think is the diffrence between the two outputs above? Why are they different?
# poke.data is made up of data frames; moves is one of those data frames

# Create a data frame named poke.moves with the moves. be sure to use the head function to only get the
# first few values. Feel free to use view to look at the dataframe.
poke.moves <- head(poke.data$moves)

# Flatten the poke.moves data frame
poke.moves <- flatten(poke.moves)

# Use the colnames function to learn what columns are in your poke.moves data frame. Print this.
colnames(poke.moves) %>% print()

# Using dplyr remove all columns except the one with your move names. 
poke.moves <- poke.moves %>% select(move.name)

# Using dplyr add one coloumn that indicates the type of the move (feel free to guess!) and one column that 
# indicates on a scale of 1-5 how much you like that move, with 1 being not at all and 5 being it's my favorite. 
poke.moves <- mutate(poke.moves, move.type = c("normal", "normal", "normal", "normal", "poison", "grass"), move.rate = round(runif(6, min = 1, max = 5), digits = 0))
print(poke.moves)

# Using dplyr order the moves by rank. Higher ranking moves should be on the top of the dataframe. 
poke.moves %>% arrange(-move.rate)

# Bonus 1
# Download a sprite of your pokemon. Be sure to download it to your png folder. Name the downloaded file using
# your pokemon's name. Be sure to check that there is a link to the sprite you chose.

