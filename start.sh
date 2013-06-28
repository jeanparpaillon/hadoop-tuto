#!/bin/bash -e
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

echo "Setup masternode"
#masternode=$(head -1 nodes.out)
masternode=login

###
echo "Setting up hadoop site"
###
sed -e 's#@MASTERNODE@#'$masternode'#g' conf/core-site.xml > $cfdir/core-site.xml
sed -e 's#@DFSDIR@#'$dfsdir'#g' conf/hdfs-site.xml > $cfdir/hdfs-site.xml
sed -e 's#@MASTERNODE@#'$masternode'#g; s#@HADOOPDIR@#'$hadoopdir'#g' conf/mapred-site.xml > $cfdir/mapred-site.xml
cp conf/hadoop-env.sh $cfdir/hadoop-env.sh

echo "Setup slave nodes"
#tail -n +2 nodes.out > $cfdir/slaves
cp nodes.out $cfdir/slaves

###
echo "Starting Hadoop cluster from $masternode"
###
echo "Cleaning up node: $masternode"
ssh $masternode rm -rf $dfsdir
for node in `cat nodes.out`; do 
    echo "Cleaning up node: $node"
    ssh $node rm -fr $dfsdir
done

ssh $masternode $hadoop namenode -format
ssh $masternode $hadoopdir/bin/start-all.sh

###
echo "Create users output"
###
for i in `seq 11 60`; do 
    ssh $masternode $hadoop fs -mkdir /tmp/hadoop-eleve$i/mapred/staging
    ssh $masternode $hadoop fs -chown -R eleve$i:F_Ecole13 /tmp/hadoop-eleve$i/mapred/staging
    ssh $masternode $hadoop fs -mkdir /user/eleve$i
    ssh $masternode $hadoop fs -chown -R eleve$i:F_Ecole13 /user/eleve$i
done

exit 0
