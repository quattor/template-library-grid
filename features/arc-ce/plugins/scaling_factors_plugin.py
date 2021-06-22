#!/usr/bin/python
import re
from os.path import isfile

"""Usage: scaling_factors_plugin.py <status> <control dir> <jobid>

Authplugin for FINISHING STATE

Example:

  authplugin="FINISHING timeout=60,onfailure=pass,onsuccess=pass /usr/local/bin/scaling_factors_plugin.py %S %C %I"

"""

def ExitError(msg,code):
    """Print error message and exit"""
    from sys import exit
    print(msg)
    exit(code)

def GetScalingFactor(control_dir, jobid):

    errors_file = '%s/job.%s.errors' %(control_dir,jobid)

    if not isfile(errors_file):
       ExitError("No such errors file: %s"%errors_file,1)

    f = open(errors_file)
    errors = f.read()
    f.close()

    scaling = -1

    m = re.search('MATCH_EXP_MachineRalScaling = \"([\dE\+\.]+)\"', errors)
    if m:
       scaling = float(m.group(1))

    return scaling


def SetScaledTimes(control_dir, jobid):

    scaling_factor = GetScalingFactor(control_dir, jobid)

    diag_file = '%s/job.%s.diag' %(control_dir,jobid)

    if not isfile(diag_file):
       ExitError("No such errors file: %s"%diag_file,1)

    f = open(diag_file)
    lines = f.readlines()
    f.close()

    newlines = []

    types = ['WallTime=', 'UserTime=', 'KernelTime=']

    for line in lines:
       for type in types:
          if type in line and scaling_factor > 0:
             m = re.search('=(\d+)s', line)
             if m:
                scaled_time = int(float(m.group(1))*scaling_factor/2.6098)
                line = type + str(scaled_time) + 's\n'

       newlines.append(line)

       fw = open(diag_file, "w")
       fw.writelines(newlines)
       fw.close()

    return 0


def main():
    """Main"""

    import sys

    # Parse arguments

    if len(sys.argv) == 4:
        (exe, status, control_dir, jobid) = sys.argv
    else:
        ExitError("Wrong number of arguments\n"+__doc__,1)

    if status == "FINISHING":
        SetScaledTimes(control_dir, jobid)
        sys.exit(0)

    sys.exit(1)

if __name__ == "__main__":
    main()

