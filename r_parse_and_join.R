
setwd('C:/Users/Ashton Chevallier/Documents/UC Berkeley/205')
download.file('https://raw.githubusercontent.com/pizzic/w205-class-project/master/medicare.csv','medicare.csv')
download.file('https://raw.githubusercontent.com/pizzic/w205-class-project/master/yelp_hospitals.csv','yelp_hospitals.csv')
download.file('https://raw.githubusercontent.com/pizzic/w205-class-project/master/Hospital%20Safety%20Grade/Hospital%20Safety%20Grade%20-%20Part%201.csv','hosptial_safety.csv')

med <- read.csv('medicare.csv', header = FALSE)
yelp <- read.csv('yelp_hospitals.csv')
hsg <- read.csv('hosptial_safety.csv')

library(dplyr)
library(stringr)

yelp <- unique(yelp[,2:7])
yelp$add <- str_trim( str_to_lower(str_replace_all(yelp$Address,"[',.-]","")))
med$add <- str_trim( str_to_lower(str_replace_all(med$V3,"[',.-]","")))
yelp$nm <- str_trim( str_to_lower(str_replace_all(yelp$Name,"[',.-]","")))
med$nm <- str_trim( str_to_lower(str_replace_all(med$V2,"[',.-]","")))
hsg$nm <- str_trim( str_to_lower(str_replace_all(hsg$Name,"[',.-]","")))
df <- med %>% left_join(yelp, by = c('V6' = 'ZipCode', 'nm'= 'nm' ))



text_split <- str_split(hsg$Address, ',')
hsg$add <- ''
hsg$zip <- 0
hsg$zip2 <- 0
for( i in 1:length(text_split)){
  
  hsg$add[i] <-  str_trim( str_to_lower(str_replace_all(text_split[[i]][1],"[',.-]","")))
  as.character(hsg$State[i])
  temp <- str_replace(text_split[[i]][2],as.character(hsg$State[i]),'')
  temp <- str_split(temp,'-')
  if(length(temp[[1]])>1){
    hsg$zip2[i] <-as.integer(str_trim(temp[[1]][2]))
  }
  hsg$zip[i] <- as.integer(str_trim(temp[[1]][1]))
}

df <- df %>% inner_join(hsg, by = c('nm'='nm', 'V6' = 'zip'))

out <- df %>% filter(!is.na(Rating))
write.csv(out,'Combined_Output.csv')
