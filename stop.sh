#!/bin/sh -e
#
# Stop hadoop session
#
nojobid() {
    echo "No current session or invalid jobid"
    exit 0
}

if test ! -e jobid.out; then
    nojobid
fi

jobid=$(cat jobid.out)
echo "Stopping Hadoop session $jobid"
llcancel $jobid

rm -f jobid.out

exit 0
