library(dplyr)
library(purrr)
library(readr)
library(stringr)

rm(list=ls())

get_files_year <- function(year) {
    list.files(path="./json", pattern=paste0(year, "-*"), full.names=T) %>% 
        gtools::mixedsort(decreasing=T)
}

get_all_years <- function(range=2005:2020) {
    res <- c()
    for (year in range)
        res <- c(res, get_files_year(year))
    res
}

unlist_keep_null <- function(l) {
    l[sapply(l, is.null)] <- NA
    unlist(l)
}

extract_json_posts <- function(file, reference=reference) {

    j <- rjson::fromJSON(file=file)$result$posts
   
    cbind(
        map(j, c("account", "id")) %>% unlist_keep_null(),
        map(j, c("account", "handle")) %>% unlist_keep_null(),
        map(j, "date") %>% unlist_keep_null(),
        map(j, "updated") %>% unlist_keep_null(),
        map(j, "type") %>% unlist_keep_null(),
        map(j, "caption") %>% unlist_keep_null(),
        map(j, "description") %>% unlist_keep_null(),
        map(j, "postUrl") %>% unlist_keep_null(),
        map(j, c("media", function(i) i[[1]], "url")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "likeCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "shareCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "commentCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "loveCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "wowCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "hahaCount")) %>% unlist_keep_null()    ,
        map(j, c("statistics", "actual", "sadCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "angryCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "thankfulCount")) %>% unlist_keep_null(),
        map(j, c("statistics", "actual", "careCount")) %>% unlist_keep_null(),
        map(j, "score") %>% unlist_keep_null(),   
        map(j, "subscriberCount") %>% unlist_keep_null(),  
        map(j, c("account", "subscriberCount")) %>% unlist_keep_null(),
        map(j, c("account", "url")) %>% unlist_keep_null(),
        map(j, c("account", "accountType")) %>% unlist_keep_null()
    ) %>%
    as.data.frame() %>%
    magrittr::set_colnames(c(
                             "facebook_id", 
                             "user_name",
                             "created",
                             "updated",
                             "type",
                             "caption",
                             "description",
                             "url",
                             "media_url",
                             "likes",
                             "shares",
                             "comments",
                             "love",
                             "wow",
                             "haha",
                             "sad",
                             "angry",
                             "thankful",
                             "care",
                             "score",
                             "subs_post",
                             "subs_account",
                             "url_account",
                             "type_account"
                             )) %>%
    left_join(reference, by=c("facebook_id", "user_name")) %>%
    select(profile_id, everything())

}

process_duplicates <- function(d) {
    d[!duplicated(d$url),]
}

clean_na <- function(d) {
    d[d==""] <- NA
    d[d=="N/A"] <- NA    
    d
}

clean_text_vars <- function(d) {
    lapply(d, str_remove_all, pattern='[\r\n\"\']') %>% as.data.frame()
}

correct_quotes <- function(d) {
    lapply(d, str_replace_all, pattern="[\u2018\u2019\u201A\u201B\u2032\u2035]", replacement="'") %>% as.data.frame()
}

correct_encoding <- function(d) {
    lapply(d, str_remove_all, pattern='[^ -~]') %>% as.data.frame()
}

decimal_only <- function(x) x %>% str_remove_all("^\\-") %>% str_remove("\\.") %>% grepl(pattern="\\D", .) %>% `!` %>% all()

wrap_up <- function(result, lastfile) {

    lastfile <- lastfile %>% str_remove_all("[\\.\\/]|json")

    d <- do.call(rbind, result) %>%
        process_duplicates() %>%
        clean_na() %>%
        clean_text_vars() %>%
        correct_quotes() %>%
        correct_encoding()

    dec_cols <- apply(d, 2, decimal_only) %>% as.vector() %>% which()
        for (k in 1:ncol(d))
            if ((k %in% dec_cols))
                d[,k][is.na(d[,k])] <- ""

    # Also, timestamps should not be quoted when missing
    dec_cols <- c(dec_cols, which(names(d) %in% c("created", "updated")))
    
    quote_cols <- (1:ncol(d))[!( (1:ncol(d) %in% dec_cols) )]
    
    write.table(d, paste0("./csv/posts-until-", lastfile, ".csv"),
                  na="NULL", row.names=F, col.names=F, sep=",", 
                  quote=quote_cols)

}

# Merge 500 API responses (500k posts) into one csv
# Assign profile ID to each response

reference <- read_csv("./csv/all-profiles.csv", 
                             col_types = list(col_character(), col_character(), col_character()))
reference$user_name[is.na(reference$user_name)] <- ""

result <- list(); i <- 1
files <- get_all_years(); l <- files %>% length()

for (file in files){

    result[[i]] <- extract_json_posts(file, reference=reference)
    
    if (i%%30==0 | i==l) {
            cat("Result will be wrapped to until", file, "...\n")
            wrap_up(result, lastfile=file)
            result <- list()
    }

    cat("\014", i, "out of", l, "files processed.\n"); i <- i+1
    
}

