#!/bin/bash

echo -n "Cleanup Apache PID file..."

RunningPID=$(pidof apache2)
if [ "$RunningPID" -gt 0 ]
then
    echo "apache2 runs in an orphaned state, killing..."
    kill $RunningPID
fi

(rm -f /var/run/apache2.pid || true)

echo -n "Starting Apache..."
/usr/sbin/apache2ctl -D FOREGROUND

rm -f /var/run/apache2.pid
