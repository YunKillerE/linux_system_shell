#!/bin/bash
#
# Function: scp config file to each <grouphost>
# Usage: gmscp.sh <grouphost> local_full_path_file remote_full_path_file
# Usage_eg: gmscp.sh homehost /home/admin/cai/conf/httpd.conf /home/admin/cai/conf/httpd.conf 
# LastModify: caosir 2005/01/04 09:47:00
#

if [ $# != 3 ]; then
    echo "Usage: $0 <grouphost> 'local_full_path_file' 'remote_full_path_file'";
    echo "Sample: gmscp.sh homehost /home/admin/cai/conf/httpd.conf /home/admin/cai/conf/httpd.conf";
    exit 1;
fi

    cd ~/.
    eval host='$1'
    DESTHOSTS=`/root/bin/gethost.sh $host`

    SERVERS=`echo $DESTHOSTS`

    for DEST_HOST in $SERVERS ; do
        echo -e "\033[32;1m========================== $DEST_HOST ==========================\033[0m";
        scp -r -p $2 $DEST_HOST:$3
    done

    echo -e "\033[32;1m========================= All done!!! ======================\033[0m";
