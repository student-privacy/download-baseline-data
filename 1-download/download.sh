#! /usr/bin/env bash

# token.txt is masked to Git and is a one-line document with your 
# CrowdTangle token, which is located at Setting/API Access.

token=$(cat token.txt)

# General remarks:

# We need a start date and end time point, defaults to GMT/UTC
# Max difference is one year, max return is 10k posts 
# Just like your FB timeline, most recent tweets are returned first.
# >> For each year, start from Dec 31st and update start date 
# >> where download exceeded

# Rate Limit is 6 requests per minute, console sleeps 10 s at bad status return 
# such that limit is always reset if exceeded

# Approach: Get year, update start and end based on function input, curl output

# Disclaimer: I mostly have 1 timeout in between each query

get_year ()
{
printf "\n*** Downloading all post data in $1 ***\n\n"
printf "*** Cleaning json/ directory ***\n"
cd json
sleep 2
find . -size 0 -delete
touch .gitkeep
cd ..
printf "\n*** Checking for previous file of year $1 in json/ for obtaining timeframe ***\n\n"
sleep 2
lastfile=$(ls -v json | grep "^$1-" | tail -n 1)
if ! [[ -z $lastfile ]]
then
      printf "*** Found file: $lastfile ***\n"
	  count=$(echo ${lastfile:5} | sed 's/.json//g')
	  let count+=1
	  printf "*** Will count files starting at $count ***\n"
	  end=$(tail -c 10000 json/$lastfile | grep -oP '\"date\":\"[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}' | tail -n 1 | sed 's/[a-z\"]*//g' | cut -c2- | sed 's/ /T/g')
	  printf "*** Start date form last session found at $end ***\n"
	  sleep 2
else
      printf "*** Found NO previous file for $1, will set default start value ***\n\n"
	  end="$1-12-31T23:59:59"
	  let count=1
	  printf "*** Start date set to $end ***\n"
	  sleep 2
fi
start="$1-01-01T00:00:00"
printf "*** Initializing download... ***\n\n"
printf "*** Files will be stored in directory json/ with signature $1-{1,2,...n} ***\n\n"
sleep 1
let returned=999
while [[ returned -gt 149 ]]
do
  touch json/$1-$count.json
  printf "*** Trying to download $start until $end into json/$1-$count.json... ***\n\n"
  while [[ $(head -c 50 json/$1-$count.json | grep -oP '^[^0-9]*\K[0-9]+') -ne 200 ]]
  do
    curl --max-time 90 "https://api.crowdtangle.com/posts?token=$token&startDate=$start&endDate=$end&listIds=1461358&sortBy=date&count=10000" > json/$1-$count.json
	if [[ $(head -c 50 json/$1-$count.json | grep -oP '^[^0-9]*\K[0-9]+') -ne 200 ]]
	then 
	  printf "\n*** Last download returned bad status or failed. Setting console to sleep for 10 seconds and retrying ***\n\n"
	  sleep 10
	fi
  done
  end=$(tail -c 10000 json/$1-$count.json | grep -oP '\"date\":\"[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}:[0-9]{2}' | tail -n 1 | sed 's/[a-z\"]*//g' | cut -c2- | sed 's/ /T/g')
  returned=$(head -c 150 json/$1-$count.json | wc -c) # empty returns have < 150 bytes
  let count+=1
done	
let count-=1
rm json/$1-$count.json # remove last return as it is empty
printf "*** YEAR $1 DOWNLOAD COMPLETE ***\n\n"
} 

# Download years separately, re-run command for year multiple times if you can not
# download a year in one sitting

get_year 2017

# ...
