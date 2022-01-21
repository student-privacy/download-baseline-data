# NCES Data public URL Cleaning

library(tidyverse)
setwd("./1-gcloud/")

d_wp <- read_csv("nces-data/all-institutional-facebook-urls.csv", col_types = cols(nces_id = col_character()))

clean_url <- function(strings) {
  return(
    strings %>%
      sapply(., utils::URLdecode) %>%  
      tolower() %>%
      str_remove_all("^http[s]?://") %>%   # optional transfer protocol specification at beginning
      str_remove_all("^w{3,}.") %>%  # optional www. at beginning
      str_replace_all("/{1,}","/") %>%   # redundant forward slashes
      str_remove_all("facebook.[a-z]{2,3}/") %>%  # international endings, .de, .fr, .it, ...
      str_remove_all("posts/.*|videos/.*|timeline.*|events/.*") %>% # content chunks
      str_remove_all("/$") %>%    # forward slashes at the end of URLs
      str_remove_all("pages/|pg/|hashtag/|people/") %>%  # old page identifyers
      str_remove_all("category/(?=\\S*['-])([a-zA-Z'-]+)/")  # category names with dashes
  )
}

d_wp$url_clean <- d_wp$url %>% clean_url()

d_wp$facebook_id <- d_wp$url_clean %>% 
  sapply(., function(x) { if (str_detect(x, "[[:digit:]]{9,1000}")) { return( str_extract(x, "[[:digit:]]{9,1000}") ) } else {return(NA)} }) %>%  # extract fb ids if possible
  str_replace_all("([.])|[[:punct:]]", "\\1")   # finally, punctuation (except dots) for final matching, result is either fb id or user_name

d_wp$user_name <- d_wp$url_clean %>% 
  str_remove_all("[[:digit:]]{9,}") %>%
  str_replace_all("([.])|[[:punct:]]", "\\1")    # the only punctation in facebook user names is a dot, all other punctation can be cleaned

d <- d_wp %>% select(user_name, facebook_id, nces_id)

d[d==""] <- NA

d <- d %>% select(facebook_id, user_name, nces_id) 

write.csv(d, "./stage-1/public-urls.csv", na="NULL", row.names=F, quote=T)

