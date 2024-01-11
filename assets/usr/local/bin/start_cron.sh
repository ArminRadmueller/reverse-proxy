#!/bin/bash

echo -n "Cleanup crond PID file..."

RunningPID=$(pidof cron)
if [ "$RunningPID" -gt 0 ]
then
    echo "crond runs in an orphaned state, killing..."
    kill $RunningPID
fi

(rm -f /var/run/crond.pid || true)

echo -n "Starting crond..."
/usr/sbin/cron -f -L 8

rm -f /var/run/crond.pid
