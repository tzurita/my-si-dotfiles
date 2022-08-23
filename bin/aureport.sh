#!/bin/bash

failed_logins=`/sbin/aureport --input-logs -ts yesterday 00:00:00 |grep 'failed login'| awk -F: '{gsub(/^[ \t]+/, "", $2); print $2 }'`
output_file="/tmp/failedlogin.tmp"

echo $failed_logins
if [ "$failed_logins" -ge 10 ]; then
  /sbin/aureport --input-logs -l --failed --summary -i -ts yesterday 00:00:00 > "$output_file"
  /sbin/aureport --input-logs -l --failed -ts yesterday 00:00:00 >> "$output_file"
  mail -s "$(hostname) Failed Logins" unixsupp@si.edu < "$output_file"
else
	exit
fi

if [ -f "$output_file" ]; then
  rm "$output_file"
fi
