#!/bin/bash

sensors > values.txt

#greps the package temps
CORES=$(cat values.txt | grep 'Core')
echo $CORES > tmp.txt

#formats the text for accurate info
sed 's/) \?/)\n/g' tmp.txt > tmp2.txt
cat tmp2.txt | awk -F ' ' '{print $3}' > tmp.txt
cat tmp.txt | awk -F '+' '{print $2}' > tmp2.txt
cat tmp2.txt | awk -F '°C' '{print $1}' > tmp.txt
cat tmp.txt | awk -F '.' '{print $1}' > tmp2.txt

#parses the data and calculates the average
FILE=$(cat tmp2.txt)
CORES=0
TOT_TEMP=0
for VALUE in $FILE
do
  let CORES=CORES+1
  let TOT_TEMP=TOT_TEMP+VALUE
done

AVG_TEMP=0
let AVG_TEMP=TOT_TEMP/CORES

#prints out data
echo 'CPU: '$AVG_TEMP' C'

#clean up files
rm values.txt tmp.txt tmp2.txt
