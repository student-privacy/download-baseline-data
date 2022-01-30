library(dplyr)
library(purrr)

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

extract_json_profiles <- function(file) {
    j <- jsonlite::fromJSON(file=file)$result$posts
    cbind(map(j, c("account", "id")) %>% unlist_keep_null(), 
          map(j, c("account", "handle")) %>% unlist_keep_null()) %>%
        as.data.frame() %>% 
        filter(!duplicated(.))
}

result <- list(); i <- 1
files <- get_all_years(); l <- files %>% length()

for (file in files){
    result[[i]] <- extract_json_profiles(file)
    cat("\014", i, "out of", l, "files processed.\n"); i <- i+1
}

plyr::rbind.fill(result) %>%
    filter(!duplicated(.)) %>%
    magrittr::set_colnames(c("facebook_id", "user_name")) %>%
    mutate(profile_id = cumsum(!duplicated(.))) %>% 
    select(profile_id, everything()) %>%
    write.table("./csv/all-profiles.csv", na="NULL", row.names=F, col.names=T, 
            quote=2, sep=",")

