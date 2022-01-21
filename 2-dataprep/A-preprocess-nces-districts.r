library(tidyverse)
setwd("./1-gcloud/")

d <- read.csv("./nces-data/nces-info-for-districts.csv", fill=T, encoding = "UTF-8") %>% 
  janitor::clean_names()

# Get Facebook ID and User name of districts

d$link_proc[is.na(d$link_proc)] <- ""

d$district_profile_id <- NA

d$district_facebook_id <- d$link_proc %>% 
  sapply(., function(x) { if (str_detect(x, "[[:digit:]]{9,1000}")) { return( str_extract(x, "[[:digit:]]{9,1000}") ) } else {return(NA)} }) %>%  # extract fb ids if possible
  str_replace_all("([.])|[[:punct:]]", "\\1")   # finally, punctuation (except dots) for final matching, result is either fb id or user_name

d$district_user_name <- d$link_proc %>% 
  str_remove_all("[[:digit:]]{9,}") %>%
  str_replace_all("([.])|[[:punct:]]", "\\1")    # the only punctation in facebook user names is a dot, all other punctation can be cleaned

d <- d %>% select(-link_proc, -proc_link)

# Disambiguate names

names(d)[grep("nces_id", names(d))] <- "district_nces_id"
names(d)[grep("link", names(d))] <- "district_facebook_url"
  
# NAs and remove non-UTF-8 chars

d <- d %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))

bad_char <- d$location_address_2_district_2017_18[1]  # hacked, just at 1st position for this file!
d[d==bad_char] <- NA
d[d==""] <- NA; d[d=="    "] <- NA
d[d=="-"] <- NA; d[d=="–"] <- NA; d[d=="–"] <- NA

# A lot of entries start with "="

d <- lapply(d, gsub, pattern='=', replacement='') %>% as.data.frame()

# Exclude quotation marks

d <- lapply(d, str_remove_all, pattern='[\"\']') %>% as.data.frame()

# Put primary key as first column

d <- d %>% select(district_nces_id, everything())

# Clean values to lower case were appropriate

cols <- c(8,9,10,12,15,16,20,23,26,28:42)

for (i in cols)
    d[,i] <- d[,i] %>% tolower()

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

write.table(d, "./stage-3/nces-districts.csv", na="NULL", row.names=F, col.names=F, 
            quote=quote_cols, sep=",")

