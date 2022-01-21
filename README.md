# download-baseline-data
Codebase to Download CrowdTangle Data via Bash, Curl and Parsing it to CSV, Including NCES Data on Schools and Districts.

# `/1-download`

Code for downloading CrowdTangle post data via Bash and
parsing it to csv. Main script is `download.sh` to download posts
and saving them to json files in the `/json` folder.
The remaining scripts include some utility functions to 
process and sample the json output.

# `/2-dataprep`

Cleaning scripts for post and NCES data, including
the creation of a unique profile identifier
to match the two. 
**[Codebook](https://docs.google.com/document/d/1JnFNq2rv6zyTu_BKC0WRKgrJye8AfOF1TZnMOEdgxRA/edit)**.

# `/3-queries+analysis`

SQL commands and R scripts to export and analyze the
data sets descriptively. There is also a RMarkdown
notebook to investigate codes that may be useful.

## Setup

* download Curl and Cygwin if you are on a Windows machine

* put your CrowdTangle token as a one-line document to
`/1-download/token.txt`, see CrowdTangle/Settings/API access