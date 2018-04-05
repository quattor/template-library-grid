# This template install a script that can be used to check pbs_server or pbs_mom
# is running properly and restart it if not.

unique template features/torque2/pbs-monitoring;

include 'components/filecopy/config';

# Define PBS_MONITORING_NFS_FS to an empty string to disable the NFS file
# system check
variable PBS_MONITORING_NFS_FS ?= {
  nfs_fs_list = '';
  if ( is_defined(NFS_MOUNT_POINTS['mountedFS']) ) {
    foreach (fs;params;NFS_MOUNT_POINTS['mountedFS']) {
      nfs_fs_list = nfs_fs_list + ' ' + unescape(fs);
    };
  };
  nfs_fs_list;
};
variable PBS_MONITORING_SCRIPT ?= TORQUE_CONFIG_DIR+"/pbs-monitoring";

# When editing take care of the script nfs_fs_list variable setup
# from PBS_MONITORING_NFS_FS
variable PBS_MONITORING_SCRIPT_CONTENTS ?= {
  contents = <<EOF;
#!/bin/sh

export PATH=/sbin:/usr/sbin:/bin:/usr/bin

this_script=$(basename $0)
force_restart=0
pbs_server_check=1
local_fs_list=$(cat /proc/mounts | awk '{if (($1 !~ /^none$/) && ($3 ~ /^ext[0-9]+$|^xfs$/) && ($4 ~ /^rw$/)) print $2}')
EOF

  #Insert the actual list of NFS file systems
  contents = contents + "nfs_fs_list='"+PBS_MONITORING_NFS_FS+"'\n";

  contents = contents + <<EOF;

usage () {
  echo "Usage:    $(basename $0) [-mom] [-force]"
}


while [ -n "$(echo $1 | grep '^-')" ]
do
  case $1 in
    -force)
        force_restart=1
        ;;

    -mom)
        pbs_server_check=0
        ;;

    *)
      echo "Invalid option ($1)"
      usage
      exit 1
      ;;
 
  esac
  shift
done

if [ ${pbs_server_check} -eq 1 ]
then
  pbsbin=/usr/sbin/pbs_server
  pbssrv=pbs_server
else
  pbsbin=/usr/sbin/pbs_mom
  pbssrv=pbs_mom

  # Check that all the local file systems are writable
  # (a readonly file system is the sign of a disk pb)
  for fs in $local_fs_list
  do
    file=${fs}/${this_script}.test.to_delete
    touch ${file} > /dev/null 2>&1
    if [ $? -eq 0 ]
    then
      rm ${file}
    else
      echo "Local filesytem ${fs} not available. Stopping Torque client"
      service  ${pbssrv} status >/dev/null 2>&1
      if [ $? -eq 0 ]
      then
        service ${pbssrv} stop
        # Keep a lock file so that pbs-monintoring will restart it
        # when the problem is fixed.
        cat > /var/lock/subsys/pbs_mom <<EOT
Killed by Quattor because of an unvailable file system ($fs)
EOT
      else
        echo ${pbssrv} already stopped
      fi
      exit 1
    fi
  done

  # On client, check that NFS file systems if any are mounted
  for fs in $nfs_fs_list
  do
    # First check if it is listed in /proc/mounts
    status=$(cat /proc/mounts | awk '{if ($3=="nfs") print $2}' | grep -E "${fs}\$")
    if  [ -z "$status" ]
    then
      # May be a mount point managed by automount and not currently mounted. Try ls...
      ls -Ld ${fs} >/dev/null 2>&1
      if [ $? -ne 0 ]
      then
        echo "NFS filesytem ${fs} not available. Stopping Torque client"
        service  ${pbssrv} status >/dev/null 2>&1
        if [ $? -eq 0 ]
        then
          service ${pbssrv} stop
          # Keep a lock file so that pbs-monintoring will restart it
          # when the problem is fixed.
          cat > /var/lock/subsys/pbs_mom <<EOT
Killed by Quattor because of an unavailable file system ($fs)
EOT
        else
          echo ${pbssrv} already stopped
        fi
        exit 1
      fi
    #else
    #  echo "NFS filesystem $fs in /proc/mounts"
    fi
  done
fi

service $pbssrv status > /dev/null 2>&1
status=$?
if [ ${status} -ne 0 ]
then
  if [ ${status} -eq 3 -a ${force_restart} -eq 0 ]
  then
    echo "`date` - PBS has been properly stopped. Not restarting it (use -force to restart it)..."
  else
    echo "`date` - PBS not running. Restarting..."
    service $pbssrv start
  fi
else
  if [ ${pbs_server_check} -eq 1 ]
  then
    # Check pbs is responding
    # If not, check again is pbs is there as mdiag command sometimes crashes pbs ...
    qmgr </dev/null > /dev/null 2>&1
    if [ $? -ne 0 ]
    then
      pbspid=`ps -e -opid="",cmd="" | awk "{if (\\$2==\"${pbsbin}\") print \\$1}"`
      if [ -z "$pbspid" ]
      then
        echo "`date` - PBS service looked ok but PBS not running. Restarting..."
      else
        echo "`date` - PBS running (pid=$pbspid) but not responding. Killing and restarting..."
        kill -KILL $pbspid
      fi
      echo `date` - System load statictics :
      uptime
      vmstat
      service $pbssrv start
    fi
  fi
fi
EOF

  contents
};


# Now actually add the file to the configuration.
'/software/components/filecopy/services' =
  npush(escape(PBS_MONITORING_SCRIPT),
        dict('config',PBS_MONITORING_SCRIPT_CONTENTS,
             'owner','root:root',
             'perms', '0755'));
