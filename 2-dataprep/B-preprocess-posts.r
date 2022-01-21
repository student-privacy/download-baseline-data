library(tidyverse)
# setwd("./1-gcloud/") if you have a .Rproj at ~/

filenames <- list.files(path="./post-data", pattern="*.csv", full.names=T)

get_year <- function(f) {
    return(str_sub(f, -26, -23))
}

files <- data.frame(path=filenames, year=sapply(filenames, get_year)) %>%
    arrange(year)

process_duplicates <- function(d) {
    return(d[!duplicated(d$url),])
}

clean_na <- function(d) {
    d[d==""] <- NA
    d[d=="N/A"] <- NA    
    return(d)
}

clean_text_vars <- function(d) {
    return(lapply(d, str_remove_all, pattern='[\r\n\"\']') %>% as.data.frame())
}

clean_datetime <- function(d) {
    d$created <- d$created %>%
        str_replace_all("/", "-") %>%
        str_replace_all("  ", " ") %>%
        str_replace_all(" AM| PM", "") %>%
        str_replace_all(" EDT", "-04") %>% # TIMESTAMP WITH TIME ZONE '2004-10-19 10:23:54+02'
        str_replace_all(" EST", "-04") %>%       
        str_replace_all(" CET", "+01") %>% # need to add more if team downloads from more TZ
        as.character()
    return(d)
}

integers_only <- function(x) all(!grepl("\\D", x))
decimal_only <- function(x) x %>% str_remove_all("^\\-") %>% str_remove("\\.") %>% grepl(pattern="\\D", .) %>% `!` %>% all()

preprocess_master <- function(d) {
    return(
        d %>%
            janitor::clean_names() %>%
            process_duplicates() %>%
            clean_na() %>%
            clean_text_vars() %>%
            clean_datetime() 
    )
}

# Lets save files into csv's of 1 year

j <- 1

for (i in 1:nrow(files)){
        
    if (i == 1){
    
        objects <- list()
        objects[[j]] <- read_csv(files$path[i], quote = '""', col_types = cols(.default = "c")) %>%
            preprocess_master()
        cat("\014", i, "out of", nrow(files), "files processed\n") 
        j <- j+1
        next
    
    }

    if (files$year[i] == files$year[i-1]){
        objects[[j]] <- read_csv(files$path[i], quote = '""', col_types = cols(.default = "c")) %>%
            preprocess_master()
        j <- j+1
    }

    else {
        d <- plyr::rbind.fill(objects); objects <- list()
        dec_cols <- apply(d, 2, decimal_only) %>% as.vector() %>% which()
        for (k in 1:ncol(d))
            if ((k %in% dec_cols))
                d[,k][is.na(d[,k])] <- ""
        quote_cols <- (1:ncol(d))[!( (1:ncol(d) %in% dec_cols) )]
        write.table(d, paste("./stage-2/posts", files$year[i], ".csv", sep=''),
                  na="NULL", row.names=F, col.names=T, sep=",", quote=quote_cols)
                  #quote=quote_cols, sep=",")
        #sink(paste0(files$year[i], "vars.txt"))
        #for (name in names(d)) # variable names seem consistent so far
        #    cat(name, "\n")
        #sink()
        rm(d)
        j <- 1
        objects[[j]] <- read_csv(files$path[i], quote = '""', col_types = cols(.default = "c")) %>%
            preprocess_master()
    }

    cat("\014", i, "out of", nrow(files), "files processed\n") 
    
}

