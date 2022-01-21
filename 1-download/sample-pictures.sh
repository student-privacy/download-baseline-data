#! /usr/bin/env bash

token=$(cat token.txt)

# Just testing, needs fresh downloads because link expires

from="2019-01-05T21:22:12"
to="2019-05-05T21:22:12"

curl "https://api.crowdtangle.com/posts?token=$token&startDate=$from&endDate=$to&listIds=1461358&sortBy=date&count=10000" > photos/temp.json

rscript sample-pictures.R

input="photos/urls.txt"
while IFS= read -r url
do
    wget $url
done < "$input"

