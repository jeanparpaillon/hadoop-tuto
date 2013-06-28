#!/bin/sh
#
# Stop hadoop session
#
nojobid() {
    echo "No current session or invalid jobid"
    exit 0
}

topdir=$(cd $(dirname $0) && pwd)
hadoopdir=$topdir/hadoop-1.2.0

if test ! -e jobid.out; then
    nojobid
fi

if test ! -d $hadoopdir; then
    echo "No Hadoop. Please run setup.mk"
fi

masternode=$(head -1 nodes.out)
cfdir=$hadoopdir/conf
dfsdir=/tmp/hdfs
jobid=$(cat jobid.out)

###
echo "Stopping Hadoop services"
###
ssh $masternode $hadoopdir/bin/stop-all.sh

###
echo "Stopping Hadoop session $jobid"
###
llcancel $jobid

rm -f jobid.out

exit 0
