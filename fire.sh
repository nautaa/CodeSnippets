#!/bin/bash
PID=`ps -ef | grep server | grep -v grep | awk '{print $2}'`
if [ ${#PID} -eq 0 ]
then
    echo "server not running"
    exit -1
fi
echo "1:"
perf record -F 99 -g --proc-map-timeout 10000 -p $PID -- sleep 60
echo "2:"
perf script -i perf.data &> perf.unfold
echo "3:"
FlameGraph/stackcollapse-perf.pl perf.unfold &> perf.folded
echo "4:"
FlameGraph/flamegraph.pl --flamechart perf.folded > perf.svg
rm -rf perf.data* perf.folded perf.unfold
