#! /usr/bin/env bash

# 1 Extract all profiles from data, takes ~ 45 mins

rscript extract-profiles.R

# 2 Extract and clean all post data, takes a few hours

rscript extract-posts.R
