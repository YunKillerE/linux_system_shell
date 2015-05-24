#!/bin/bash
#

# Creator: tiexin  2007-06-04 v1.0
# Update: 2008-04-02 v1.1 ; Add obj/desc/srvreq

group=$(/root/bin/gethost.sh $1)

msg () {
    cat << EOF
Usage: $0 [hostname] [statistics information]
Statistics Information:
  load          Display systemn load in 5 minutes
  traf          Display the last 10 minutes : Network Traffic/sec
EOF
}


case $2 in
    load)
        channel="ssh -o ConnectTimeout=1"
        cmd="w | grep load  | awk '{print \$(NF-2)}'   |awk -F "," '{print \$1}'"
        ;; 
    traf)
        channel="ssh -o ConnectTimeout=1"
        cmd="env -i sar -n DEV | grep -E 'bond0|eth0' |grep -v Av | tail -2 | head -1 |awk '{printf \"%s %0.2fMbps\n\",\"Traffic:\",\$6/1000000*8}'"
        ;;
    *)
        msg
        exit 0
        ;;
esac
    
for server in $group; do
   if [ $2 == "obj"   ];then    
      echo -e "\033[32;1m========================= $server ========================\033[0m";
    $channel $server "$cmd"| awk '{bytes+=$1}END{print bytes}' 
   else
     echo -e "\033[32;1m========================= $server ========================\033[0m";
    $channel $server "$cmd"
  fi
done
