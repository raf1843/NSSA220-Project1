#!/bin/bash
# Application Performance Monitoring
# Starts 6 C exes, collects metrics, and cleans up
# Uses ps, ifstat, iostat, and df
# Outputs csv files

# Spawn processes
spawn(){
  #need "ifstat -d |"
  for((i=1; $i <= 6; i++))
  do
    echo $i
  done 
}

# Collect process metrics
collect_ps(){
  #2 cpu 3 Mem
  cpu_percent=$(ps -U root -u root u| cut -f 2 -d ' ')
  mem_percent=$(ps -U root -u root u| cut -f 3 -d ' ')
  echo "$SECONDS, $cpu_percent, $mem_percent" >> ps_metrics.csv
}

# Collect system metrics
collect_sys(){
  echo
}

# Clean up
cleanup(){
  echo
}
trap cleanup EXIT

# main

spawn
#while
	#sleep 5
	collect_ps
	collect_sys
