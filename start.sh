#!/bin/sh -e
#
# Start an 'idle' job and deploy Hadoop on the reserved nodes
#
topdir=$(cd $(dirname $0) && pwd)
hadoopdir=$topdir/hadoop-1.2.0
hadoop=$hadoopdir/bin/hadoop

if test ! -d $hadoopdir; then
    echo "No Hadoop. Please run setup.mk"
fi

cfdir=$hadoopdir/conf
dfsdir=/tmp/hdfs

###
echo "Starting Hadoop session"
###
llsubmit ssh.cmd 2>&1 | grep "The job" | sed -e 's/^llsubmit: The job "\([a-z0-9\.]\+\)\".*/\1/' > jobid.out
jobid=$(cat jobid.out)
llq -l $jobid | grep 'Task Instance' | tail -n +2 | sed -e 's/^.*\(node[0-9]\+\).*/\1/' > nodes.out
masternode=$(head -1 nodes.out)

###
echo "Setting up hadoop site"
###
sed -e 's#@MASTERNODE@#'$masternode'#g' conf/core-site.xml > $cfdir/core-site.xml
sed -e 's#@DFSDIR@#'$dfsdir'#g' conf/hdfs-site.xml > $cfdir/hdfs-site.xml
sed -e 's#@MASTERNODE@#'$masternode'#g; s#@HADOOPDIR@#'$hadoopdir'#g' conf/mapred-site.xml > $cfdir/mapred-site.xml
cp conf/hadoop-env.sh $cfdir/hadoop-env.sh
tail -n +2 nodes.out > $cfdir/slaves

###
echo "Starting Hadoop cluster from $masternode"
###
while read node; do 
    rm -fr $dfsdir
    mkdir -p $dfsdir/data
    mkdir -p $dfsdir/name
done < nodes.out

ssh $masternode $hadoop namenode -format
ssh $masternode $hadoopdir/bin/start-all.sh

###
echo "Setup environment for multi-user"
###
$hadoop fs -mkdir /app/hadoop/tmp/mapred/staging
$hadoop fs -chmod -R 1777 /app/hadoop/tmp/mapred/staging
$hadoop fs -chmod -R 1777 /app/hadoop/tmp/mapred/staging

exit 0
