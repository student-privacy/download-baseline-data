library(tidyverse)
setwd("./1-gcloud/")

filenames <- list.files(path="./post-data", pattern="*.csv", full.names=T)

get_year <- function(f) {
    return(str_sub(f, -26, -23))
}

files <- data.frame(path=filenames, year=sapply(filenames, get_year)) %>%
    arrange(year)

# Lets save files into csv's of 1 year

objects <- list()

for (i in 1:nrow(files)){

    objects[[i]] <- read_csv(files$path[i], quote = '""', col_types = cols(.default = "c")) %>%
        janitor::clean_names() %>%
        select(user_name, facebook_id) %>%
        filter(!duplicated(.))

    cat("\014", i, "out of", nrow(files), "files processed\n") 

}


d <- plyr::rbind.fill(objects) %>% filter(!duplicated(.)); objects <- list()

d$user_name[d$user_name==""] <- NA

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

write.table(d, "./stage-1/all-schools.csv", na="NULL", row.names=F, 
            col.names=T, quote=quote_cols, sep=",")

