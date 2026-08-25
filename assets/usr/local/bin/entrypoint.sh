#!/bin/bash

function startSupervisord()
{
    /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
}

if [ ! -f "/usr/local/bin/setup.sh" ]
    then
        echo "environment doesn't need to be prepared, run now process control system (supervisord)"
        startSupervisord
    else
        echo "environment will now be configured..."
        /usr/local/bin/setup.sh
        if [ $? -eq 0 ]
            then
                echo "environment setup completed, run now process control system (supervisord)"
                startSupervisord
            else
                echo "preparation script failed, execution aborted (check /usr/local/bin/setup.sh)"
                exit 1
        fi
fi
