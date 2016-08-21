#!/bin/bash
# When the load of cpu is high,fetching the top 10  busiest processes.

proc_cpu_top10(){
	ps aux | grep -v 'USER' | sort -nr -k 3 | head -10 | awk '{printf("%s\t%s\n",$3,$NF)}'
}
