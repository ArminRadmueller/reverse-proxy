#!/bin/bash

for filename in /etc/supervisor/conf.d/*.conf; do

    process=$(basename ${filename} .conf)
    supervisorctl status "${process}" 2>&1 | grep -q -v RUNNING && echo "'${process}' is not running" && exit 1;

done

echo "OK, all necessary processes are running"

exit 0;
