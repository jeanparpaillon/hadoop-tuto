#!/bin/sh -e
#
# Start an 'idle' job and deploy Hadoop on the reserved nodes
#

jobid=$(llsubmit ssh.cmd 2>&1 | grep "The job" | sed -e 's/^llsubmit: The job "\([a-z0-9\.]\+\)\".*/\1/')
nodes=$(llq -l $jobid | grep 'Task Instance' | tail -4 | sed -e 's/^.*\(node[0-9]\+\).*/\1/')

echo $jobid > jobid.out
echo "Started Hadoop session on nodes: $nodes"

exit 0
