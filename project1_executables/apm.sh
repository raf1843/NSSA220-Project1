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
  echo
}

# Collect system metrics
collect_sys(){
	net_rrate=$(ifstat ens33 | sed -n '4p' | xargs | cut -f 7 -d ' ')
	net_trate=$(ifstat ens33 | sed -n '4p' | xargs | cut -f 9 -d ' ')
	
	hd_write=$(iostat sda | sed -n '7p' | xargs | cut -f 4 -d ' ')

	hd_util=$(df -hm / | sed -n '2p' | xargs | cut -f 4 -d ' ')
}

# Clean up
cleanup(){
  echo
}
trap cleanup EXIT

# main

spawn
collect_ps
collect_sys
