#!/bin/bash
# Application Performance Monitoring
# Starts 6 C exes, collects metrics, and cleans up
# Uses ps, ifstat, iostat, and df
# Outputs csv files

# Spawn processes
spawn(){
  # get gateway address
  bc=$( ifconfig ens33 | sed -n '2p' | xargs | cut -f 6 -d ' ' )
  gway=$( ping -b $bc -c 1 2>/dev/null | sed -n '2p' | cut -f 4 -d ' ' | sed s/://g )
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
    id=$(pidof $psname)
    kill -9 $id
    wait $id 2>/dev/null  # this allows for silent kill
  done
  echo # new line after CTRL-C
  echo "Check output in <ps_name>_metrics.csv and system_metrics.csv files"
}
trap cleanup EXIT

# main

spawn
while true
do
  collect_ps
  collect_sys
done
