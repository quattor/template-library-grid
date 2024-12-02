#!/bin/sh
#
# Init file for OpenSSH server daemon for GRIF interrsite logins
#
# chkconfig: 2345 99 25
# description: OpenSSH server daemon for GRIF intersite logins
#

#this is a sh script : don't assume environment is defined, especially when using "service" to restart services
#and globus things really need the globus environment
ENV_FILE="/etc/profile.d/env.sh"
if [ -f $ENV_FILE ]; then
         source $ENV_FILE
else
        echo "error : could not source environment for GLOBUS initialisation ($ENV_FILE)" >&2
        exit 2
fi

export GRIDMAPDIR=/etc/grid-security/gridmapdir

GLOBUS_LOCATION="/opt/globus"
export GLOBUS_LOCATION

. ${GLOBUS_LOCATION}/libexec/globus-script-initializer
. ${libexecdir}/globus-sh-tools.sh

PID_FILE=${localstatedir}/sshd.pid
EOF

SSHD_ARGS="-p GSISSH_PORT"

do_start()
{
    if [ ! -d $localstatedir ]; then
        mkdir -p $localstatedir
    fi
    echo -n "Starting up GSI-OpenSSH sshd server... "
    ${sbindir}/sshd $SSHD_ARGS > /dev/null 2>&1 &
    if [ $? -eq 0 ]; then
        echo "done."
    else
        echo "failed to start GSI-OpenSSH sshd server!"
    fi
}

do_stop()
{
    echo -n "Stopping the GSI-OpenSSH sshd server... "
    pid=`cat $PID_FILE`
    kill -TERM $pid
    sleep 2
    kill -TERM $pid 2> /dev/null
    rm -f $PID_FILE
    echo "done."
}

case "$1" in
    start)
        if [ ! -f $PID_FILE ]; then
            do_start
        else
            pid=`cat $PID_FILE`
            psout=`ps -A | grep $pid | grep -v grep | awk "{if (\\\$1 == $pid) print}"`
            if [ "x$psout" = "x" ]; then
                echo "Found stale sshd pid file... removing it."
                rm -f $PID_FILE
                do_start
            else
                echo "GSI-OpenSSH sshd server is already running!"
            fi
        fi
        ;;

    stop)
        if [ -f $PID_FILE ] ; then
            do_stop
        else
            echo "The server's pid file does not exist!  Are you sure the server is running?"
        fi
        ;;

    restart)
        $0 stop
        $0 start
        ;;

    *)
        echo "Usage: $0 (start|stop|restart)"
        exit 1
esac

exit 0
