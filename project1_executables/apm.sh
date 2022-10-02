#!/bin/bash
# Application Performance Monitoring
# Starts 6 C exes, collects metrics, and cleans up
# Uses ps, ifstat, iostat, and df
# Outputs csv files

# Spawn processes
spawn(){
  # hardcoded gateway address
  gway='192.168.182.2'
  ifstat -d 1
  for((i=1; $i <= 6; i++))
  do
    psname="APM${i}"
    chmod 755 $psname
    ./$psname $gway &
    echo Seconds,%CPU,%Memory > "${psname}_metrics.csv"
  done 
  # also start csv file for system
  echo Seconds,RX Data Rate,TX Data Rate,Disk Writes,Available Disk Capacity > system_metrics.csv
}

# Collect process metrics
collect_ps(){
  echo
}

# Collect system metrics
collect_sys(){
  echo
}

# Clean up
cleanup(){
  pkill ifstat
  for((i=1; $i <= 6; i++))
  do
    psname="APM${i}"
    pkill $psname   # would like to figure out how to make this silent
  done
}
trap cleanup EXIT

# main

spawn
while true
do
  collect_ps
  collect_sys
done
