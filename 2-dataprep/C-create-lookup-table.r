# Master script to update and create master lookup table for profiles
# To be discussed and improved
# Additionally, script can still be made much more working memory efficient

# a) Initial creation

library(tidyverse)
setwd("./1-gcloud/")
options(scipen=999) # no e+n

schools_posts <- read.csv("./stage-1/all-schools.csv")
schools_public <- read.csv("./stage-1/public-urls.csv")

# 1 Create Profile ID to re-insert into post data for all schools

schools_posts %>% 
  mutate(profile_id = cumsum(!duplicated(schools_posts[1:2]))) %>% 
  select(profile_id, everything()) %>%
  write.csv("./stage-2/profile-id-reference.csv", row.names=FALSE)

# 2 Create NCES ID by Profile ID Lookup Table

# We have to think about facebook profiles connected to multiple schools (nces ids)

#> schools_public %>% select(-nces_id) %>% filter(!duplicated(.)) %>% nrow
#[1] 16171
#> schools_public %>% filter(!duplicated(.)) %>% nrow
#[1] 40760

schools_public$facebook_id <- as.numeric(schools_public$facebook_id)

# Create Profile ID to re-insert into post data

res <- schools_public[schools_public$user_name %in% schools_posts$user_name | schools_public$facebook_id %in% schools_posts$user_name,]
res <- res %>% 
  mutate(profile_id = cumsum(!duplicated(res[1:2]))) %>% 
  select(profile_id, everything())

# option 1: store multiple profile matches to list of nces ids and average nces data?

temp <- res %>% 
  group_by(profile_id) %>% 
  summarise(nces_new = list(nces_id)) %>% 
  ungroup() 

opt1 <- res %>% 
  left_join(temp, by="profile_id") %>% 
  select(-nces_id) %>% 
  rename(nces_id = nces_new) %>% 
  filter(!duplicated(.))

# option 2: only include unambiguous profiles in study sample (might introduce bias, need to check nces data on this)
# seems to remove many instances, could also choose one at random to increase sample size

opt2 <- res[!(duplicated(res[2:3]) | duplicated(res[2:3], fromLast = TRUE)),]

# To be discussed

d <- opt2

# Encode integers correctly

integers_only <- function(x) all(!grepl("\\D", x))
int_cols <- apply(d, 2, integers_only) %>% as.vector() %>% which()

for (i in 1:ncol(d))
  if (i %in% int_cols)
    d[,i][is.na(d[,i])] <- ""

# Encode decimal data type correctly

decimal_only <- function(x) x %>% str_remove_all("^\\-") %>% str_remove("\\.") %>% grepl(pattern="\\D", .) %>% `!` %>% all()
dec_cols <- apply(d, 2, decimal_only) %>% as.vector() %>% which()

for (i in 1:ncol(d))
  if ((i %in% dec_cols) & !(i %in% int_cols))
    d[,i][is.na(d[,i])] <- ""

# Choose all variables that are neither int nor dec for quoting

quote_cols <- (1:ncol(d))[!( (1:ncol(d) %in% int_cols) | (1:ncol(d) %in% dec_cols) )]

# Export

write.table(d, "./stage-3/lookup-table-profiles.csv", na="NULL", row.names=F, 
            col.names=F, quote=quote_cols, sep=",")


# b) Updating with new data input

# tbd


