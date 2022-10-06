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
  # start processes and csv files
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
  # NOTE: need to figure out how to cut the 'k' off - something with sed?
  net_rrate=$(ifstat -a ens33 2>/dev/null | sed -n '4p' | xargs | cut -f 7 -d ' ')
  net_trate=$(ifstat -a ens33 2>/dev/null | sed -n '4p' | xargs | cut -f 9 -d ' ')
  hd_write=$(iostat sda | sed -n '7p' | xargs | cut -f 4 -d ' ')
  hd_util=$(df -hm / | sed -n '2p' | xargs | cut -f 4 -d ' ')
  echo "$SECONDS,$net_rrate,$net_trate,$hd_write,$hd_util" >> system_metrics.csv
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
  sleep 5
  collect_ps
  collect_sys
done

