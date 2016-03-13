#!/bin/bash
#****************************************************************#
# ScriptName: make.sh
# Author: 云尘(jimmy)
# Create Date: 2015-12-22 17:27
# Modify Author: liujmsunits@hotmail.com
# Modify Date: 2015-12-22 17:27
# Function: 
#***************************************************************#
source ./configwget.sh
sed -i "s/base_mediator_agent/$base_mediator_agent/g" install.sh
sed -i "s/mediator_probe/$mediator_probe/g" install.sh
sed -i "s/configfile/$configfile/g" install.sh
