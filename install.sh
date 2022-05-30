#!/bin/bash


if [ -z $HOME/bins/status ]
then
  mkdir $HOEM/bins/status
fi

cp status.sh $HOME/bins/status/

echo 'The file is now located at the prespecified path (check README), and you should now add an alias'
