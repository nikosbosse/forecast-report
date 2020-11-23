 #!bin/bash
 
 ## Store current working directory
 work_dir=$(pwd)
 
 ## Move out one directory and clone (or pull) data repo
 cd .. 
  if ([ -e covid19-forecast-hub-de ]); then
    printf "Updating forecasts \n"
    cd covid19-forecast-hub-de
    git pull
    cd ..
  else
    printf "Cloning forecasts repo\n"
    git clone "https://github.com/KITmetricslab/covid19-forecast-hub-de.git"
  fi