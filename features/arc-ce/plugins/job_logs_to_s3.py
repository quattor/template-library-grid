#!/usr/bin/python
import datetime
import re
from os.path import isfile
import boto
import boto.s3.connection
from boto.s3.key import Key
from sys import argv
import logging
import socket
from functools import wraps
import errno
import os
import signal

class TimeoutError(Exception):
    pass

def timeout(seconds=10, error_message=os.strerror(errno.ETIME)):
    def decorator(func):
        def _handle_timeout(signum, frame):
            raise TimeoutError(error_message)

        def wrapper(*args, **kwargs):
            signal.signal(signal.SIGALRM, _handle_timeout)
            signal.alarm(seconds)
            try:
                result = func(*args, **kwargs)
            finally:
                signal.alarm(0)
            return result

        return wraps(func)(wrapper)

    return decorator

"""Usage: job_logs_to_s3.py <status> <control dir> <jobid>

Authplugin for FINISHING STATE

Example:

  authplugin="FINISHING timeout=60,onfailure=pass,onsuccess=pass /usr/local/bin/job_logs_to_s3 %S %C %I"

"""

logging.basicConfig(filename='/var/spool/arc/logs/logstos3.log',level=logging.INFO)

def ExitError(msg, code):
    """Print error message and exit"""
    from sys import exit
    print(msg)
    exit(code)

def GetVO(control_dir, jobid):

    errors_file = '%s/job.%s.errors' %(control_dir, jobid)

    if not isfile(errors_file):
       ExitError("No such errors file: %s"%errors_file, 1)

    f = open(errors_file)
    errors = f.read()
    f.close()

    m = re.search('x509UserProxyVOName = "([\w\.]+)"', errors)
    if m:
       vo = m.group(1)
       return vo
    else:
       return "undefined"

def WriteFileToS3(creds, file_name, key):
    conn = boto.connect_s3(
        aws_access_key_id = creds[0],
        aws_secret_access_key = creds[1],
        host = 's3.echo.stfc.ac.uk',
        port = 443,
        is_secure=True,
        calling_format = boto.s3.connection.OrdinaryCallingFormat(),
    )

    k = Key(conn.get_bucket('lhcb-jobs'))
    k.key = key

    with open(file_name,'r') as f:
        k.compute_md5(f)

    k.set_contents_from_filename(file_name)

    return 0

@timeout(4)
def CopyLogsToS3(control_dir, jobid, creds):

    grami_file = '%s/job.%s.grami' %(control_dir, jobid)

    if not isfile(grami_file):
       ExitError("No such grami file: %s"%grami_file, 1)

    f = open(grami_file)
    grami = f.read()
    f.close()

    currentDate = datetime.datetime.today().strftime('%Y-%m-%d')

    m = re.search("joboption_stdout='([\w\/\.]+)'", grami)
    if m:
       stdoutF = m.group(1)
       logging.info('Writing %s from job %s to S3' % (stdoutF, jobid))
       WriteFileToS3(creds, stdoutF, "%s/%s/%s/std.out" % (currentDate, socket.gethostname(), jobid))

    m = re.search("joboption_stderr='([\w\/\.]+)'", grami)
    if m:
       stderrF = m.group(1)
       logging.info('Writing %s from job %s to S3' % (stderrF, jobid))
       WriteFileToS3(creds, stderrF, "%s/%s/%s/std.err" % (currentDate, socket.gethostname(), jobid))

    return 0


def main():
    """Main"""

    import sys

    creds = [line.rstrip('\n') for line in open('/etc/credentials-s3')]

    # Parse arguments

    if len(sys.argv) == 4:
        (exe, status, control_dir, jobid) = sys.argv
    else:
        ExitError("Wrong number of arguments\n" + __doc__, 1)

    if status == "FINISHING":
        vo = GetVO(control_dir, jobid)
        if vo == "lhcb":
            CopyLogsToS3(control_dir, jobid, creds)
        sys.exit(0)

    sys.exit(1)

if __name__ == "__main__":
    main()

