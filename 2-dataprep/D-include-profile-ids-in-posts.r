library(tidyverse)
# setwd("./1-gcloud/") if you have a .Rproj at ~/
options(scipen=999) # no e+n

filenames <- list.files(path="./stage-2/", full.names=T)

ref <- read_csv(filenames[grep("reference", filenames)], col_types = cols(.default = "c"))

decimal_only <- function(x) x %>% str_remove_all("^\\-") %>% str_remove("\\.") %>% grepl(pattern="\\D", .) %>% `!` %>% all()

i <- 1

for (f in filenames[grep("posts", filenames)]){

    d <- read_csv(f, quote='""', col_types = cols(.default = "c"))

    d <- d %>% 
        left_join(ref, by=c("user_name", "facebook_id")) %>%
        select(profile_id, everything())

    # Encode numerical variables correctly
    dec_cols <- apply(d, 2, decimal_only) %>% as.vector() %>% which()
    for (k in 1:ncol(d))
        if ((k %in% dec_cols))
            d[,k][is.na(d[,k])] <- ""
    quote_cols <- (1:ncol(d))[!(1:ncol(d) %in% dec_cols)]
    
    d %>%
        write.table(paste("./stage-3/posts-upload-", i, ".csv", sep=''),
                  na="NULL", row.names=F, col.names=F, quote=quote_cols, sep=",")
    
    cat("\014", i, "out of", length(filenames[grep("posts", filenames)]), "processed\n")
    i <- i+1
   
}


