library(tidyverse)
setwd("./1-gcloud/")

d <- read.csv("./nces-data/ELSI_csv_export_6374077161361122015895.csv", fill=T, encoding = "UTF-8") %>% 
  janitor::clean_names() 

# First name is weird

names(d)[1] <- "school_name"

# NAs and remove non-UTF-8 chars

d <- d %>% mutate_if(is.character, ~gsub('[^ -~]', '', .))

bad_char <- d$location_address_2_public_school_2018_19[1]  # hacked, just at 1st position for this file!
d[d==bad_char] <- NA
d[d==""] <- NA; d[d=="    "] <- NA
d[d=="-"] <- NA; d[d=="–"] <- NA; d[d=="–"] <- NA # this could take a few moments

# A lot of entries start with "="

d <- lapply(d, gsub, pattern='=', replacement='') %>% as.data.frame()

# Exclude quotation marks

d <- lapply(d, str_remove_all, pattern='[\"\']') %>% as.data.frame()

# Put primary key as first column

d <- d %>% select(school_id_nces_assigned_public_school_latest_available_year, everything())

# Clean values to lower case were appropriate

cols <- c(3,4,9,18,33:38,46,47,49:51)

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

write.table(d, "./stage-3/nces-schools.csv", na="NULL", row.names=F, col.names=F, 
            quote=quote_cols, sep=",")
