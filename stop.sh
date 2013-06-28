#!/bin/bash
#
# Stop hadoop session
#
function nojobid {
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

masternode=login
cfdir=$hadoopdir/conf
dfsdir=/tmp/hdfs
jobid=$(cat jobid.out)

###
echo "Stopping Hadoop services"
###
ssh $masternode $hadoopdir/bin/stop-all.sh

###
echo "Cleanup"
###
rm -rf $dfsdir
cat nodes.out | while read node; do
    ssh $node rm -rf $dfsdir
done

###
echo "Stopping Hadoop session $jobid"
###
llcancel $jobid

rm -f jobid.out

exit 0
