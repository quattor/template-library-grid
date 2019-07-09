#!/usr/bin/python

"""Usage: default_rte_plugin.py <status> <control dir> <jobid> <runtime environment>

Authplugin for PREPARING STATE

Example:

  authplugin="PREPARING timeout=60,onfailure=pass,onsuccess=pass /usr/local/bin/default_rte_plugin.py %S %C %I <rte>"

"""

def ExitError(msg,code):
    """Print error message and exit"""
    from sys import exit
    print(msg)
    exit(code)

def SetDefaultRTE(control_dir, jobid, default_rte):

    from os.path import isfile

    desc_file = '%s/job.%s.description' %(control_dir,jobid)

    if not isfile(desc_file):
       ExitError("No such description file: %s"%desc_file,1)

    f = open(desc_file)
    desc = f.read()
    f.close()

    if default_rte not in desc:
       with open(desc_file, "a") as myfile:
          myfile.write("( runtimeenvironment = \"" + default_rte + "\" )")

    if 'DIRAC' in desc and 'memory' not in desc:
       with open(desc_file, "a") as myfile:
          myfile.write("( memory = \"4000\" )")

    return 0

def main():
    """Main"""

    import sys

    # Parse arguments

    if len(sys.argv) == 5:
        (exe, status, control_dir, jobid, default_rte) = sys.argv
    else:
        ExitError("Wrong number of arguments\n"+__doc__,1)

    if status == "PREPARING":
        SetDefaultRTE(control_dir, jobid, default_rte)
        sys.exit(0)

    sys.exit(1)

if __name__ == "__main__":
    main()

