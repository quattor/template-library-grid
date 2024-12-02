#! /bin/bash                                                                                                                                                                                                

routedBy=`grep RoutedBy $_CONDOR_JOB_AD|cut -d '"' -f 2`
if [ "x$routedBy" == "xhtcondor-ce" ];
then
    . /etc/profile
fi

eval "$@"
