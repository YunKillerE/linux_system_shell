#!/bin/bash
#


# Group
PWD=`pwd`

#squidhost="$image"
#homehost="@home@"
#allhome="$homehost $assets $msvchost"
#allhost="$lvs $log $image $homehost $kunlun $proxy $tmd"
allhost="client master"
host1=""
# Single
if [ $# -eq 1 ]
then
        POINT=`echo $1 | grep "\." | wc -l`
        if [ $POINT -eq 1 ]
        then
                echo $1
        else
                eval "single=\$$1"
                if [ -n "$single" ]
                then
                        echo $single
                else
                        echo $1
                fi
        fi
fi
