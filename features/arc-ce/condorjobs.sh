#!/bin/sh
condor_q -constraint 'JobStatus==2' -autoformat x509UserProxyVOName | sort | uniq -c > /var/local/condor_jobs_running
condor_q -constraint 'JobStatus==1' -autoformat x509UserProxyVOName | sort | uniq -c > /var/local/condor_jobs_idle
