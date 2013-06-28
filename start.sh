#!/bin/sh -e
#
# Start an 'idle' job and deploy Hadoop on the reserved nodes
#
topdir=$(dirname $0)
hadoopdir=$topdir/hadoop-1.2.0

if test ! -d $hadoopdir; then
    echo "No Hadoop. Please run setup.mk"
fi

###
echo "Starting Hadoop session"
###
llsubmit ssh.cmd 2>&1 | grep "The job" | sed -e 's/^llsubmit: The job "\([a-z0-9\.]\+\)\".*/\1/' > jobid.out
jobid=$(cat jobid.out)
llq -l $jobid | grep 'Task Instance' | tail -4 | sed -e 's/^.*\(node[0-9]\+\).*/\1/' > nodes.out

###
echo "Setting up hadoop site"
###
masternode=$(head -1 nodes.out)
cfdir=$hadoopdir/conf
dfsdir=/tmp/hdfs
sed -e 's/@MASTERNODE@/'$masternode'/g' conf/core-site.xml > $cfdir/core-site.xml
sed -e 's/@DFSDIR@/'$dfsdir'/g' conf/hdfs-site.xml > $cfdir/hdfs-site.xml
sed -e 's/@MASTERNODE@/'$masternode'/g; s/@HADOOPDIR@/'$hadoopdir'/g' conf/mapred-site.xml > $cfdir/mapred-site.xml
tail -n +2 nodes.out > $cfdir/slaves

###
echo "Starting Hadoop cluster from $masternode"
###
ssh $masternode $hadoopdir/bin/start-all.sh

exit 0