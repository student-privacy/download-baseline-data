library(dplyr)
library(purrr)

# Sample response

rm(list=ls())

unlist_keep_null <- function(l) {
    l[sapply(l, is.null)] <- NA
    unlist(l)
}

j <- rjson::fromJSON(file="./photos/temp.json")$result$posts

    urls <- c(
        map(j, c("media", function(i) i[[1]], "url")) %>% unlist_keep_null()
    )

sink("out.txt")
for (url in urls) cat(url, "\n")
sink()

#################

set.seed(909)

# From 100 responses, sample 10 pictures

rm(list=ls())

unlist_keep_null <- function(l) {
    l[sapply(l, is.null)] <- NA
    unlist(l)
}

fns <- sample(dir("./json/", pattern="*.json", full.names=T), 100, replace=F)
res <- c(); i<-0

for (f in fns) 
{
    j <- rjson::fromJSON(file=f)$result$posts
   
    urls <- cbind(
        map(j, "date") %>% unlist_keep_null(),
        map(j, c("account", "id")) %>% unlist_keep_null(),
        map(j, "type") %>% unlist_keep_null(),
        map(j, c("media", function(i) i[[1]], "url")) %>% unlist_keep_null(),
        map(j, "postUrl") %>% unlist_keep_null()
    ) %>%
    as.data.frame() %>%
    magrittr::set_colnames(c("date", "user", "type", "image_url", "post_url")) %>%
    filter(type=="photo") %>% 
    select(post_url) %>%
    unlist() %>%
    sample(10, replace=F)

    res <- c(res, urls)

    i <- i+1; cat("\014", i, "% done\n")
}

sink("./photos/urls.txt")
for (url in res)
    cat(url, "\n")
sink()

######################

library(dplyr)
library(purrr)

# Sample response

rm(list=ls())

unlist_keep_null <- function(l) {
    l[sapply(l, is.null)] <- NA
    unlist(l)
}

# More info on sample

fns <- dir("./json/", pattern="*.json", full.names=T)
res <- list(); i<-1

for (f in fns) 
{
    j <- rjson::fromJSON(file=f)$result$posts
   
    urls <- cbind(
        map(j, "date") %>% unlist_keep_null(),
        map(j, c("account", "id")) %>% unlist_keep_null(),
        map(j, "type") %>% unlist_keep_null()
    ) %>%
    as.data.frame() %>%
    magrittr::set_colnames(c("date", "user", "type")) ->
        res[[i]]

    i <- i+1; cat("\014", i, "out of", length(fns), "done\n")
}

saveRDS(res, "res-list.rds")

###

library(tidyverse)

d<-readRDS("res-df.rds") 

# Number of posts
nrow(d)
# Number of posts: 18,005,519

# Posts by type
d %>%
    group_by(type) %>%
    count()

# A tibble: 17 x 2
# Groups:   type [17]
#   type                       n
#   <chr>                  <int>
# 1 album                    111
# 2 episode                   11
# 3 extra_clip                 3
# 4 link                 3701481
# 5 live_video              2071
# 6 live_video_complete   154716
# 7 live_video_scheduled    4974
# 8 music                      1
# 9 native_video          891586
#10 photo                9342593
#11 status               3500292
#12 swf                        3
#13 trailer                    1
#14 unknown                    4
#15 video                  89589
#16 vine                     302
#17 youtube               317781

# Number of shared pictures by year
d %>%
    filter(type=="photo") %>%
    mutate(year=lubridate::year(date)) %>%
    group_by(year) %>%
    count()

# A tibble: 16 x 2
# Groups:   year [16]
#    year       n
#   <dbl>   <int>
# 1  2005      12
# 2  2006       8
# 3  2007      21
# 4  2008      92
# 5  2009     804
# 6  2010    2866
# 7  2011    7578
# 8  2012   25956
# 9  2013   50130
#10  2014  172122
#11  2015  618972
#12  2016 1040400
#13  2017 1331808
#14  2018 1672927
#15  2019 2109076
#16  2020 2309821


