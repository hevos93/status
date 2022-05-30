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

#cpu usage
CPU_USAGE_TMP=$(vmstat | awk '{if(NR==3) print $15}')
CPU_USAGE=100
let CPU_USAGE=CPU_USAGE-CPU_USAGE_TMP


#reports if integrated or dedicated gpu
GPU=$(optimus-manager --print-mode | awk -F ' ' '{print $5}')

#checks if the gpu is dedicated, and gets values
if [ $GPU = 'nvidia' ]
then
  CHECK='true'  

  #temps
  GPU_TEMP_TMP=$(nvidia-smi | awk '{if(NR==10) print $3}')
  GPU_TEMP=${GPU_TEMP_TMP::-1}

  #usage
  GPU_USAGE=$(nvidia-smi | awk '{if(NR==10) print $13'})
fi

#ram usage
vmstat -s > vmstat.txt

let TOTAL_MEM=$(cat vmstat.txt | awk '{if(NR==1) print $1}')/1000
let USED_MEM=$(cat vmstat.txt | awk '{if(NR==2) print $1}')/1000

awk -v v1=$TOTAL_MEM -v v2=$USED_MEM 'BEGIN { print (v2 / v1)*100 }' > ram.txt
MEM_USAGE=$(cat ram.txt | awk -F '.' '{print $1}')

#prints out data
echo 'CPU TEMP: '$AVG_TEMP' C'
echo 'CPU USAGE: '$CPU_USAGE'%'

printf '\n'

echo 'GPU MODE: '$GPU
if [ ! -z $CHECK ]
then
  echo 'GPU TEMP: '$GPU_TEMP' C'
  echo 'GPU USAGE: '$GPU_USAGE
fi

printf '\n'

echo 'RAM USAGE: '$MEM_USAGE'%'

#clean up files
rm values.txt tmp.txt tmp2.txt vmstat.txt ram.txt
