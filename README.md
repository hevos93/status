#Status script for linux
##Install
Run the installation script: install.sh
The installation script copies the script to your home directory and to a folder named bins.
/$HOME/bins/status/

The intended use is with an alias, so add this to your favorite terminals rc file.

alias status=/$HOME/bins/status/status.sh

##Dependencies
lm-sensors - Run through sensors-detect
optimus-manager - To see which GPU is used
