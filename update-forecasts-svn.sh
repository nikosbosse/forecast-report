#!bin/bash

## Store current working directory
work_dir=$(pwd)

## Move out one directory and clone (or pull) data repo
cd .. 
if ([ -e data-processed ]); then
printf "Updating forecasts \n"
cd data-processed
svn update
cd ..
else
printf "Cloning forecasts folder\n"
svn checkout https://github.com/KITmetricslab/covid19-forecast-hub-de/trunk/data-processed
fi