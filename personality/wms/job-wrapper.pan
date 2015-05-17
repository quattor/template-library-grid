# Allow to install a modified version of WMS job wrapper

unique template personality/wms/job-wrapper;

include 'components/wmslb/config';

variable WMS_JOB_WRAPPER = EMI_LOCATION + '/etc/templates/template.sh';

variable WMS_JOB_WRAPPER_CONTENTS = <<EOF;
#!/bin/sh

trap 'fatal_error "Job has been terminated (got SIGXCPU)" "OSB"' XCPU
trap 'fatal_error "Job has been terminated (got SIGQUIT)" "OSB"' QUIT
trap 'fatal_error "Job has been terminated (got SIGINT)" "OSB"' INT
trap 'fatal_error "Job has been terminated (got SIGTERM)" "OSB"' TERM
#trap 'warning "Job has been signalled (got SIGUSR1)" "OSB"' SIGUSR1

# the bash builtin kill command is sometimes buggy with process groups
enable -n kill

##
## initializations
##

# explicitly addresses interoperability with OSG
if [ -r "${OSG_GRID}/setup.sh" ]; then
  source "${OSG_GRID}/setup.sh" &>/dev/null
fi

if [ -n "${__gatekeeper_hostname}" ]; then
  export EMI_WMS_LOG_DESTINATION="${__gatekeeper_hostname}"
fi

if [ -n "${__jobid}" ]; then
  export EMI_WMS_JOBID="${__jobid}"
fi

export EMI_WMS_SEQUENCE_CODE="$1"
shift

if [ -z "${EMI_WMS_LOCATION}" ]; then
  export EMI_WMS_LOCATION="${EMI_LOCATION:-/opt/glite}"
fi

if [ -z "${EDG_WL_LOCATION}" ]; then
  export EDG_WL_LOCATION="${EDG_LOCATION:-/opt/edg}"
fi

lb_logevent=${EMI_WMS_LOCATION}/bin/glite-lb-logevent
if [ ! -x "$lb_logevent" ]; then
  lb_logevent="${EDG_WL_LOCATION}/bin/edg-wl-logev"
fi

if [ "X${__input_base_url##*/}" != "X" ]; then
  __input_base_url="${__input_base_url}/"
fi

if [ "X${__output_base_url##*/}" != "X" ]; then
  __output_base_url="${__output_base_url}/"
fi

if [ -z "${EMI_LOCAL_COPY_RETRY_COUNT}" ]; then
  __copy_retry_count=6
else
  __copy_retry_count=${EMI_LOCAL_COPY_RETRY_COUNT}
fi

if [ -z "${EMI_LOCAL_COPY_RETRY_FIRST_WAIT}" ]; then
  __copy_retry_first_wait=300
else
  __copy_retry_first_wait=${EMI_LOCAL_COPY_RETRY_FIRST_WAIT}
fi

jw_host="`hostname -f`"
jw_newdir="${__jobid_to_filename}"
jw_maradona="${jw_newdir}.output"
jw_workdir="`pwd`"

##
# functions definitions
##

kill_with_children() { # 1 - parent PID
  if [ -n "$1" ]
  then
    local ppid=$1
    kill -STOP $ppid
    local kill_list=$ppid
    for i in `ps -ef | awk '$3 == '${ppid}' { print $2 }'`
    do
      kill_list="$kill_list $i"
    done
    kill -9 $kill_list
  else
    echo "kill_with_children() called with an empty pid"
  fi
}

do_transfer() # 1 - command, 2 - source, 3 - dest, 4 - std err, 5 - exit code file
{
  $1 "$2" "$3" 2>"$4"
  echo $? > "$5"
}

proxy_checker()
{
  while [ 1 -eq 1 ]; do
    time_left=`grid-proxy-info -timeleft 2>/dev/null || echo 0`
    if [ $time_left -lt 0 ]; then
      break;
    else
      sleep $time_left
    fi
  done

  fatal_error "Job killed by the jobwrapper because of user proxy expiration"
}

jw_echo() # 1 - msg
{
  echo "$1"
  echo "$1" >> "${jw_maradona}"
}

log_event() # 1 - event
{
  export EMI_WMS_SEQUENCE_CODE=`$lb_logevent\
    --jobid="$EMI_WMS_JOBID"\
    --source=LRMS\
    --sequence="$EMI_WMS_SEQUENCE_CODE"\
    --event="$1"\
    --node="$jw_host"\
    || echo $EMI_WMS_SEQUENCE_CODE`
}

log_done_ok() # 1 - exit code
{
  export EMI_WMS_SEQUENCE_CODE=`$lb_logevent\
    --jobid="$EMI_WMS_JOBID"\
    --source=LRMS\
    --sequence="$EMI_WMS_SEQUENCE_CODE"\
    --event="Done"\
    --status_code=OK\
    --exit_code="$1"\
    || echo $EMI_WMS_SEQUENCE_CODE`
}

log_done_failed() # 1 - exit code
{
  export EMI_WMS_SEQUENCE_CODE=`$lb_logevent\
    --jobid="$EMI_WMS_JOBID"\
    --source=LRMS\
    --sequence="$EMI_WMS_SEQUENCE_CODE"\
    --event="Done"\
    --reason="$1"\
    --status_code=FAILED\
    --exit_code="$1"\
    || echo $EMI_WMS_SEQUENCE_CODE`
}

log_event_reason() # 1 - event, 2 - reason
{
  export EMI_WMS_SEQUENCE_CODE=`$lb_logevent\
    --jobid="$EMI_WMS_JOBID"\
    --source=LRMS\
    --sequence="$EMI_WMS_SEQUENCE_CODE"\
    --event="$1"\
    --reason="$2"\
    --node="$jw_host"\
    || echo $EMI_WMS_SEQUENCE_CODE`
}

log_resource_usage() # 1 - resource, 2 - quantity, 3 - unit
{
  export EMI_WMS_SEQUENCE_CODE=`$lb_logevent\
    --jobid="$EMI_WMS_JOBID"\
    --source=LRMS\
    --sequence="$EMI_WMS_SEQUENCE_CODE"\
    --event=ResourceUsage\
    --resource="$1"\
    --quantity="$2"\
    --unit="$3"\
    || echo $EMI_WMS_SEQUENCE_CODE`
}

warning()
{
  local term_delay=10
  jw_echo "$1"
  log_event_reason "Running" "job received SIGUSR1 as warning, terminating in $term_delay seconds"
  kill -USR1 -$user_job_pid # forwarding to the user job (just in case)
  sleep $term_delay
  fatal_error "Job termination $term_delay seconds after having being warned" $2
}

fatal_error() # 1 - reason, 2 - transfer OSB
{
  jw_echo "$1"
  log_done_failed "$1"
  if [ "x$2" -eq "xOSB" ]; then
    OSB_transfer
  fi
  doExit 1
}

truncate() # 1 - file name, 2 - bytes num., 3 - name of the truncated file
{
  tail "$1" --bytes=$2>$3 2>/dev/null
  return $?
}

sort_by_size() # 1 - file names vector, 2 - directory
{
  local tmp_sort_file=`mktemp -q tmp.XXXXXXXXXX`
  if [ ! -f "$tmp_sort_file" ]; then
    jw_echo "Cannot generate temporary file"
    return $?
  fi
  eval tmpvar="$1[@]"
  eval elements="\${$tmpvar}"
  for fname in "${elements}"; do
    fsize=`stat -t $2/$fname 2>/dev/null | awk '{print $2}'`
    if [ -z "$fsize" ]; then
      fsize=0
    fi
    echo "$fsize $fname" >> "$tmp_sort_file"
  done
  unset "$1"
  eval "$1=(`sort -n $tmp_sort_file|awk '{print $2}'`)"
  rm -f "$tmp_sort_file"
}

is_integer() { # 1 - value to be checked
  if [ -z "${1//[0-9]/}" ] && [ -n "$1" ] ; then
    return 0
  else
    return 1
  fi
}

retry_copy() # 1 - command, 2 - source, 3 - dest
{
  local count=0
  local succeded=1
  local sleep_time=0
  while [ $count -le ${__copy_retry_count} -a $succeded -ne 0 ];
  do
    time_left=`grid-proxy-info -timeleft 2>/dev/null || echo 0`;
    if [ $time_left -lt $sleep_time ]; then
      return 1
    fi
    sleep $sleep_time
    if [ $sleep_time -eq 0 ]; then
      sleep_time=${__copy_retry_first_wait}
    else
      sleep_time=`expr $sleep_time \* 2`
    fi
    transfer_stderr=`mktemp -q std_err.XXXXXXXXXX`
    if [ ! -f "$transfer_stderr" ]; then
      transfer_stderr="/dev/null"
    fi
    transfer_exitcode=`mktemp -q tr_exit_code.XXXXXXXXXX`
    if [ ! -f "$transfer_exitcode" ]; then
      transfer_exitcode="/dev/null"
    fi
    do_transfer $1 "$2" "$3" "$transfer_stderr" "$transfer_exitcode"&
    transfer_watchdog=$!
    transfer_timeout=3600
    while [ $transfer_timeout -gt 0 ];
    do
      if [ -z `ps -p $transfer_watchdog -o pid=` ]; then
        break;
      fi 
      sleep 1
      let "transfer_timeout--"
    done
    if [ $transfer_timeout -le 0 ]; then
      echo "Killing transfer watchdog (pid=$transfer_watchdog)..."
      kill_with_children $transfer_watchdog
      log_event_reason "Running" "Hanging transfer"
      return 1
    else
      succeded=`cat $transfer_exitcode 2>/dev/null`
      if [ -z $succeded ]; then
        log_event_reason "Running" "Cannot retrieve return value for transfer"
        return 1 # will cause a fatal_error
      else
        if [ "$succeded" -ne "0" ]; then
          log_event_reason "Running" "Error during transfer"
          return $succeded # will cause a fatal_error
        fi
      fi
    fi
    rm -f "$transfer_stderr" "$transfer_exitcode"
    count=`expr $count + 1`
  done
  return ${succeded}
}

doExit() # 1 - status
{
  local jw_status=$1

  jw_echo "jw exit status = ${jw_status}"

  if [ -n "${jw_maradona}" ]; then
    if [ -r "${jw_maradona}" ]; then
      retry_copy "globus-url-copy" "file://${jw_workdir}/${jw_maradona}" "${__jw_maradonaprotocol}"
      globus_copy_status=$?
    else
      jw_echo "jw_maradona not readable, so not sent"
      globus_copy_status=0
    fi
  else
    jw_echo "jw_maradona was found unset or empty"
    globus_copy_status=0
  fi

  if [ -n "${jw_newdir}" ]; then
    rm -rf "../${jw_newdir}"
  fi

  if [ -n "$proxy_watchdog" ]
  then
    echo "doExit(): Killing proxy watchdog (pid=$proxy_watchdog)..."
    kill_with_children $proxy_watchdog 
  fi
  kill -9 -$user_job_pid 2>/dev/null

  if [ ${jw_status} -eq 0 ]; then
    exit ${globus_copy_status}
  else
    exit ${jw_status}
  fi
}

doDSUploadTmp()
{
  local filename="${__dsupload}"
  echo "#" >> "$filename.tmp"
  echo "# Autogenerated by JobWrapper!" >> "$filename.tmp"
  echo "#" >> "$filename.tmp"
  echo "# The file contains the results of the upload and registration" >> "$filename.tmp"
  echo "# process in the following format:" >> "$filename.tmp"
  echo "# <outputfile> <lfn|guid|Error>" >> "$filename.tmp"
  echo "" >> "$filename.tmp"
}

doDSUpload()
{
  local filename="${__dsupload}"
  mv -fv "$filename.tmp" "$filename"
}

doCheckReplicaFile()
{
  local sourcefile=$1
  local filename="${__dsupload}"
  local exit_status=0
  if [ ! -f "${jw_workdir}/$sourcefile" ]; then
    echo "$sourcefile    Error: File $sourcefile has not been found on the WN $jw_host" >> "$filename.tmp"
    exit_status=1
  fi
  echo >> "$filename.tmp"
  return $exit_status
}

doReplicaFile()
{
  local sourcefile=$1
  local filename="${__dsupload}"
  local exit_status=0
  local localf=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" 2>&1`
  result=$?
  if [ $result -eq 0 ]; then
    echo "$sourcefile    $localf" >> "$filename.tmp"
  else
    echo "$sourcefile    Error: $localf" >> "$filename.tmp"
    exit_status=1
  fi
  
  echo >> "$filename.tmp"
  return $exit_status
}

doReplicaFilewithLFN()
{
  local sourcefile="$1"
  local lfn="$2"
  local filename="${__dsupload}"
  local exit_status=0
  local localf=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" -l "$lfn" 2>&1`
  result=$?
  if [ $result -eq 0 ]; then
    echo "$sourcefile    $lfn" >> "$filename.tmp"
  else
    local localnew=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" 2>&1`
    result=$?
    if [ $result -eq 0 ]; then
      echo "$sourcefile $localnew" >> "$filename.tmp"
    else
      echo "$sourcefile Error: $localf; $localnew" >> "$filename.tmp"
      exit_status=1
    fi
  fi
  
  echo >> "$filename.tmp"
  return $exit_status
}

doReplicaFilewithSE()
{
  local sourcefile="$1"
  local se="$2"
  local filename="${__dsupload}"
  local exit_status=0
  local localf=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" -d "$se" 2>&1`
  result=$?
  if [ $result -eq 0 ]; then
    echo "$sourcefile  $localf" >> "$filename.tmp"
  else
    local localnew=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" 2>&1`
    result=$?
    if [ $result -eq 0 ]; then
      echo "$sourcefile $localnew" >> "$filename.tmp"
    else
      echo "$sourcefile Error: $localf; $localnew" >> "$filename.tmp"
      exit_status=1
    fi
  fi

  echo >> "$filename.tmp"
  return $exit_status
}

doReplicaFilewithLFNAndSE()
{
  local sourcefile="$1"
  local lfn="$2"
  local se="$3"
  local filename="${__dsupload}"
  local exit_status=0
  local localf=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" -l "$lfn" -d "$se" 2>&1`
  result=$?
  if [ $result -eq 0 ]; then
    echo "$sourcefile    $localf" >> "$filename.tmp"
  else
    local localse=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" -d "$se" 2>&1`
    result=$?
    if [ $result -eq 0 ]; then
      echo "$sourcefile    $localse" >> "$filename.tmp"
    else
      local locallfn=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" -l "$lfn" 2>&1`
      result=$?
      if [ $result -eq 0 ]; then 
        echo "$sourcefile    $locallfn" >> "$filename.tmp"
      else
        local localnew=`${edg_rm_command} --vo=${__vo} copyAndRegisterFile "file://${jw_workdir}/$sourcefile" 2>&1`
        result=$?
        if [ $result -eq 0 ]; then
          echo "$sourcefile    $localnew" >> "$filename.tmp"
        else
          echo "$sourcefile    Error: $localf; $localse; $locallfn; $localnew" >> "$filename.tmp"
          exit_status=1
        fi    
      fi
    fi
  fi
    
  echo >> "$filename.tmp"
  return $exit_status
}

function send_partial_file
{
  # Use local variables to avoid conflicts with main program
  local TRIGGERFILE=$1
  local DESTURL=$2
  local POLL_INTERVAL=$3
  local FILESUFFIX=partialtrf
  local GLOBUS_RETURN_CODE
  local SLICENAME
  local LISTFILE=`pwd`/listfile.$$
  local LAST_CYCLE=""
  local SLEEP_PID
  local MD5
  local OLDSIZE
  local NEWSIZE
  local COUNTER
  # Loop forever (need to be killed by main program)
  while [ -z "$LAST_CYCLE" ] ; do
    # Go to sleep, but be ready to wake up when the user job finishes
    sleep $POLL_INTERVAL & SLEEP_PID=$!
    trap 'LAST_CYCLE="y"; kill -ALRM $SLEEP_PID >/dev/null 2>&1' USR2
    wait $SLEEP_PID >/dev/null 2>&1
    # Retrieve the list of files to be monitored
    if [ "${TRIGGERFILE:0:9}" == "gsiftp://" ]; then
      globus-url-copy "${TRIGGERFILE}" "file://${LISTFILE}"
    elif [ "${TRIGGERFILE:0:8}" == "https://" -o "${TRIGGERFILE:0:7}" == "http://" ]; then
      htcp "${TRIGGERFILE}" "file://${LISTFILE}"
    else
      false
    fi
    # Skip iteration if unable to get the list
    # (can be used to switch off monitoring)
    if [ "$?" -ne "0" ] ; then
      continue
    fi
    for SRCFILE in `cat "$LISTFILE"` ; do
      # SRCFILE must contain the full path
      if [ "$SRCFILE" == "`basename $SRCFILE`" ] ; then
        SRCFILE=`pwd`/$SRCFILE
      fi
      if [ -f $SRCFILE ] ; then
        # Point to the "state" variables of the current file
        # (we will use indirect reference)
        MD5=`expr "$(echo $SRCFILE | md5sum)" : '\([^ ]*\).*'`
        OLDSIZE="OLDSIZE_$MD5"
        COUNTER="COUNTER_$MD5"
        # Initialize variables if referenced for the first time
        if [ -z "${!OLDSIZE}" ]; then eval local $OLDSIZE=0; fi
        if [ -z "${!COUNTER}" ]; then eval local $COUNTER=1; fi
        # Make a snapshot of the current file
        cp $SRCFILE ${SRCFILE}.${FILESUFFIX}
        NEWSIZE=`stat -c %s ${SRCFILE}.${FILESUFFIX}`
        if [ "${NEWSIZE}" -gt "${!OLDSIZE}" ] ; then
          let "DIFFSIZE = NEWSIZE - $OLDSIZE"
          SLICENAME=$SRCFILE.`date +%Y%m%d%H%M%S`_${!COUNTER}
          tail -c "$DIFFSIZE" "${SRCFILE}.${FILESUFFIX}" > "$SLICENAME"
          if [ "${DESTURL:0:9}" == "gsiftp://" ]; then
            globus-url-copy "file://$SLICENAME" "${DESTURL}/`basename $SLICENAME`"
          elif [ "${DESTURL:0:8}" == "https://" -o "${DESTURL:0:7}" == "http://" ]; then
            htcp "file://$SLICENAME" "${DESTURL}/`basename $SLICENAME`"
          else
            false
          fi
          GLOBUS_RETURN_CODE=$?
          rm -f "${SRCFILE}.${FILESUFFIX}" "$SLICENAME"
          if [ "$GLOBUS_RETURN_CODE" -eq "0" ] ; then
            let "$OLDSIZE = NEWSIZE"
            let "$COUNTER += 1"
          fi # else we will send this chunk toghether with the next one
        fi # else the file size didn't increase
      fi
    done
  done
  rm -f "$LISTFILE" # some cleanup
}

OSB_transfer()
{
  # uncomment this one below if the order in the osb originally 
  # specified is not of some relevance to the user
  #sort_by_size __output_file ${jw_workdir}

  local file_size_acc=0
  local current_file=0
  local total_files=${#__wmp_output_dest_file[@]}
  for f in "${__wmp_output_dest_file[@]}"
  do
    if [ -r "${__wmp_output_file[$current_file]}" ]; then
      file=`basename $f`
      s="${jw_workdir}/${__wmp_output_file[$current_file]}"
      if [ ${__osb_wildcards_support} -eq 0 ]; then
        d="${f}"
      else
        d="${__output_sandbox_base_dest_uri}/${file}"
      fi
      if [ ${max_osb_size} -ge 0 ]; then
        # TODO
        #if hostname=wms
          file_size=`stat -t $s | awk '{print $2}'`
          if [ -z "$file_size" ]; then
            file_size=0
          fi
          file_size_acc=`expr $file_size_acc + $file_size`
        #fi
        if [ $file_size_acc -le ${max_osb_size} ]; then
          if [ "${f:0:9}" == "gsiftp://" ]; then
            retry_copy "globus-url-copy" "file://$s" "$d"
          elif [ "${f:0:8}" == "https://" -o "${f:0:7}" == "http://" ]; then
            retry_copy "htcp" "file://$s" "$d"
          else
            false
          fi
        else
          jw_echo "OSB quota exceeded for $s, truncating needed"
          file_size_acc=`expr $file_size_acc - $file_size`
          remaining_files=`expr $total_files \- $current_file`
          remaining_space=`expr $max_osb_size \- $file_size_acc`
          trunc_len=`expr $remaining_space / $remaining_files`
          if [ $? != 0 ]; then
            trunc_len=0
          fi
          file_size_acc=`expr $file_size_acc + $trunc_len`
          #if [ $trunc_len -lt 10 ]; then # non trivial truncation
            #jw_echo "Not enough room for a significant truncation on file ${file}, not sending"
          #else
            truncate "$s" $trunc_len "$s.tail"
            if [ $? != 0 ]; then
              jw_echo "Could not truncate output sandbox file ${file}, not sending"
            else
              jw_echo "Truncated last $trunc_len bytes for file ${file}"
              if [ "${f:0:9}" == "gsiftp://" ]; then
                retry_copy "globus-url-copy" "file://$s.tail" "$d.tail"
              elif [ "${f:0:8}" == "https://" -o "${f:0:7}" == "http://" ]; then
                retry_copy "htcp" "file://$s.tail" "$d.tail"
              else
                false
              fi
            fi
          #fi
        fi
      else # unlimited osb
        if [ "${f:0:9}" == "gsiftp://" ]; then
          retry_copy "globus-url-copy" "file://$s" "$d"
        elif [ "${f:0:8}" == "https://" -o "${f:0:7}" == "http://" ]; then
          retry_copy "htcp" "file://$s" "$d"
        else
          false
        fi
      fi
      if [ $? != 0 ]; then
        fatal_error "Cannot upload file://$s into $d"
      fi
    else
      jw_echo "Cannot read or missing file ${__wmp_output_file[$current_file]}"
    fi
    let "++current_file"
  done
}

##
## let's start it up
##

if [ ${__job_type} -eq 1 -o ${__job_type} -eq 2 ]; then
  # MPI (LSF or PBS)
  mkdir -p .mpi/${jw_newdir}
  if [ $? != 0 ]; then
    fatal_error "Cannot create .mpi/${jw_newdir} directory"
  fi
  cd .mpi/${jw_newdir}
else #if [ ${__job_type} -eq 0 -o ${__job_type} -eq 3 ]; then
  mkdir ${jw_newdir}
  if [ $? != 0 ]; then
    fatal_error "Cannot create ${jw_newdir} directory"
  fi
  cd ${jw_newdir}
fi
jw_workdir="`pwd`"

log_event "Running"

max_osb_size=${__max_outputsandbox_size}
is_integer ${EMI_LOCAL_MAX_OSB_SIZE}
if [ $? -eq 0 ]; then
  if [ ${EMI_LOCAL_MAX_OSB_SIZE} -lt $max_osb_size ]; then
    max_osb_size=${EMI_LOCAL_MAX_OSB_SIZE}
  fi
fi

vo_hook="lcg-jobwrapper-hook.sh" # common-agreed now hard-coded
if [ -n "${__ce_application_dir}" ]; then
  if [ -d "${__ce_application_dir}" ]; then
    if [ -r "${__ce_application_dir}/${vo_hook}" ]; then
      . "${__ce_application_dir}/${vo_hook}"
    elif [ -r "${__ce_application_dir}/${__vo}/${vo_hook}" ]; then
      . "${__ce_application_dir}/${__vo}/${vo_hook}"
    else
      jw_echo "${vo_hook} not readable or not present"
    fi
  else
    jw_echo "${__ce_application_dir} not found or not a directory"
  fi
fi
unset vo_hook

# customization point #1
# Be sure to update workdir as it may be changed by cp_1.sh
if [ -n "${EMI_LOCAL_CUSTOMIZATION_DIR}" ]; then
  if [ -r "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_1.sh" ]; then
    . "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_1.sh"
  fi
fi
jw_workdir="`pwd`"

# EMI_WMS_RB_BROKERINFO must be defined after execution of cp_1.sh in case
# workdir (used as destination when downloading sandbox) has been updated
if [ -n "${__brokerinfo}" ]; then
  export EMI_WMS_RB_BROKERINFO="$jw_workdir/${__brokerinfo}"
fi

# the test -w on work dir is unsuitable on AFS machines
tmpfile=`mktemp -q tmp.XXXXXXXXXX`
if [ ! -f "$tmpfile" ]; then
  fatal_error "Working directory not writable"
else
  rm "$tmpfile"
fi
unset tmpfile

touch "${jw_maradona}"

if [ -z "${GLOBUS_LOCATION}" ]; then
  fatal_error "GLOBUS_LOCATION undefined"
elif [ -r "${GLOBUS_LOCATION}/etc/globus-user-env.sh" ]; then
  . "${GLOBUS_LOCATION}/etc/globus-user-env.sh"
else
  fatal_error "${GLOBUS_LOCATION}/etc/globus-user-env.sh not found or unreadable"
fi

umask 022

# input sandbox download
for f in ${__wmp_input_base_file[@]}
do
  if [ -z "${__wmp_input_base_dest_file}" ]; then
    file=`basename ${f}`
  else
    file=`basename ${__wmp_input_base_dest_file[$index]}`
  fi
  if [ "${f:0:9}" == "gsiftp://" ]; then
    retry_copy "globus-url-copy" "${f}" "file://${jw_workdir}/${file}"
  elif [ "${f:0:8}" == "https://" -o "${f:0:7}" == "http://" ]; then
    retry_copy "htcp" "${f}" "file://${jw_workdir}/${file}"
  else
    false
  fi 
  if [ $? != 0 ]; then
    fatal_error "Cannot download ${file} from ${f}"
  fi
done

if [ -r "${__job}" ]; then
  chmod +x "${__job}" 2>/dev/null
else
  fatal_error "${__job} not found or unreadable"
fi

# user script (before taking the token, shallow-sensitive)
if [ -n "${__prologue}" ]; then
  if [ -r "${__prologue}" ]; then
    (
    for env in ${__environment[@]}
    do
      eval export $env
    done
    chmod +x "${__prologue}" 2>/dev/null
    ${__prologue} "${__prologue_arguments}" >/dev/null 2>&1
    exit $?
    )
    prologue_status=$?
    if [ ${prologue_status} -ne 0 ]; then
      fatal_error "prologue failed with error ${prologue_status}"
    fi
  else
    fatal_error "prologue ${__prologue} not found"
  fi
fi

if [ ${__perusal_support} -eq 1 ]; then
  send_partial_file ${__perusal_listfileuri} ${__perusal_filesdesturi} ${__perusal_timeinterval} & send_pid=$!
fi

if [ -n "${__shallow_resubmission_token}" ]; then

  # Look for an executable gridftp_rm command
  for gridftp_rm_command in $EMI_LOCATION/bin/glite-gridftp-rm \
                            `which glite-gridftp-rm 2>/dev/null` \
                            $EDG_LOCATION/bin/edg-gridftp-rm \
                            `which edg-gridftp-rm 2>/dev/null` \
                            $GLOBUS_LOCATION/bin/uberftp \
                            `which uberftp 2>/dev/null`; do
    if [ -x "${gridftp_rm_command}" ]; then
      break;
    fi
  done

  if [ ! -x "${gridftp_rm_command}" ]; then
    fatal_error "No *ftp for rm command found"
  else
    is_uberftp=`expr match "${gridftp_rm_command}" '.*uberftp'`
    if [ $is_uberftp -eq 0 ]; then
      $gridftp_rm_command ${__shallow_resubmission_token} &>/dev/null
    else # uberftp
      tkn=${__shallow_resubmission_token} # will reduce lines length
      scheme=${tkn:0:`expr match "${tkn}" '[[:alpha:]][[:alnum:]+.-]*://'`}
      remaining=${tkn:${#scheme}:${#tkn}-${#scheme}}
      hostname=${remaining:0:`expr match "$remaining" '[[:alnum:]_.~!$&()-]*'`}
      token_fullpath=${remaining:${#hostname}:${#remaining}-${#hostname}}
      $gridftp_rm_command $hostname "quote dele ${token_fullpath}" &>/dev/null
    fi
    result=$?
    if [ $result -eq 0 ]; then
      log_event "ReallyRunning"
      jw_echo "Take token: ${EMI_WMS_SEQUENCE_CODE}"
    else
      fatal_error "Cannot take token for ${EMI_WMS_JOBID}"
    fi
  fi
fi

if [ ${__job_type} -eq 1 ]; then # MPI LSF
  hostfile="host$$"
  # touch $hostfile
  for mpi_host in "${LSB_HOSTS}"
    do echo "$mpi_host" >> $hostfile
  done
elif [ ${__job_type} -eq 2 ]; then
  hostfile="${PBS_NODEFILE}"
fi
if [ ${__job_type} -eq 1 -o ${__job_type} -eq 2 ]; then # MPI LSF, PBS
  for i in `cat "$hostfile"`; do
    ssh ${i} mkdir -p `pwd`
    /usr/bin/scp -rp ./* "${i}:`pwd`"
    ssh ${i} chmod 755 `pwd`/${__job}
  done
fi

if [ 1 -eq 1 ]; then # dump variable to be set?
  time_cmd=`which time 2>/dev/null`
  if [ -x "$time_cmd" ]; then
    time_cmd="$time_cmd -p"
    tmp_time_file=`mktemp -q tmp.XXXXXXXXXX`
    if [ $? -ne 0 ]; then
      jw_echo "Cannot generate temporary file"
      unset tmp_time_file 
    fi
  else
    jw_echo "Cannot find 'time' command"
  fi
fi

if [ ${__job_type} -eq 0 ]; then # normal
  executable="${__job}"
elif [ ${__job_type} -eq 1 -o ${__job_type} -eq 2 ]; then # MPI LSF, PBS
  executable="mpirun"
  __arguments="-np ${__nodes} -machinefile ${hostfile} ${__job} ${__arguments}"
fi

if [ ${__job_type} -ne 3 ]; then # all but interactive
  if [ -n "${__standard_input}" ]; then
    std_input=" <\"${__standard_input}\" "
  fi
  if [ -n "${__standard_output}" ]; then
    std_output=" >\"${__standard_output}\" "
  else
    std_output=" >/dev/null "
  fi
  if [ -n "${__standard_error}" ]; then
    std_error=" 2>\"${__standard_error}\" "
  else
    std_error=" 2>/dev/null "
  fi
fi

(
  for env in ${__environment[@]}
  do
    eval export $env
  done

  if [ -f "$tmp_time_file" ]; then
    full_cmd_line="($time_cmd -o \"$tmp_time_file\" \"${executable}\" ${__arguments} ${std_input} ${std_output} ${std_error})"
  else
    full_cmd_line="\"${executable}\" ${__arguments} ${std_input} ${std_output} ${std_error}"
  fi

  if [ -z "$EDG_WL_NOSETPGRP" ]; then
    trap 'IGNORING' TTIN
    trap 'IGNORING' TTOU
  fi

  # finally getting to the core business
  eval "${full_cmd_line}" &
  user_job_pid=$!

  # customization point
  if [ -n "${EMI_LOCAL_CUSTOMIZATION_DIR}" ]; then
    if [ -r "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_1_5.sh" ]; then
      . "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_1_5.sh"
    fi
  fi

  proxy_checker &
  proxy_watchdog=$!

  wait $user_job_pid
  user_job_status=$?
  echo "Killing proxy watchdog (pid=$proxy_watchdog)..."
  kill_with_children $proxy_watchdog
  exit $user_job_status
)
status=$?
jw_echo "job exit status = ${status}"

# reports the time usage
if [ -f "$tmp_time_file" -a -n "$time_cmd" ]; then
  log_resource_usage "real" "`grep real $tmp_time_file | cut -d' ' -f 2`" "s"
  log_resource_usage "user" "`grep user $tmp_time_file | cut -d' ' -f 2`" "s"
  log_resource_usage "sys" "`grep sys $tmp_time_file | cut -d' ' -f 2`" "s"
  rm -f "$tmp_time_file"
fi 

# customization point #2
if [ -n "${EMI_LOCAL_CUSTOMIZATION_DIR}" ]; then
  if [ -r "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_2.sh" ]; then
    . "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_2.sh"
  fi
fi

if [ ${__perusal_support} -eq 1 ]; then
  kill -USR2 $send_pid
  wait $send_pid 
fi

if [ ${__output_data} -eq 1 ]; then
  return_value=0
  if [ $status -eq 0 ]; then
    local=`doDSUploadTmp`
    status=$?
    return_value=$status
    local_cnt=0
    for edg_rm_command in "${EMI_LOCATION}/bin/lcg-replica-manager" \
                          "/opt/lcg/bin/lcg-replica-manager" \
                          "${LCG_LOCATION}/bin/lcg-replica-manager" \
                          "/opt/lcg/bin/lcg-replica-manager" \
                          "${EMI_LOCATION}/bin/edg-rm" \
                          "${EDG_LOCATION}/bin/edg-rm" \
                          "`which lcg-replica-manager 2>/dev/null`" \
                          "`which edg-rm 2>/dev/null`"; do
      if [ -x "${edg_rm_command}" ]; then
        break;
      fi
    done
    if [ ! -x "${edg_rm_command}" ]; then
      fatal_error "Cannot find edg-rm command"
    else
      for outputfile in ${__output_file[@]}
      do
        local=`doCheckReplicaFile ${__output_file}`
        status=$?
        if [ $status -ne 0 ]; then
          return_value=1
        else
          if [ -z "${__output_lfn}" -a -z "${__output_se}"] ; then
            local=`doReplicaFile $outputfile`
          elif [ -n "${__output_lfn}" -a -z "${__output_se}"] ; then
            local=`doReplicaFilewithLFN $outputfile ${__output_lfn[$local_cnt]}`
          elif [ -z "${__output_lfn}" -a -n "${__output_se}"] ; then
            local=`doReplicaFilewithSE $outputfile ${__output_se[$local_cnt]}`
          else
            local=`doReplicaFilewithLFNAndSE $outputfile ${__output_lfn[$local_cnt]} ${__output_se[$local_cnt]}`
          fi
          status=$?
        fi
        let "++local_cnt"
      done
      local=`doDSUpload`
      status=$?
    fi
  fi
fi

if [ -n "${__epilogue}" ]; then
  if [ -r "${__epilogue}" ]; then
    (
    for env in ${__environment[@]}
    do
      eval export $env
    done
    chmod +x "${__epilogue}" 2>/dev/null
    ${__epilogue} "${__epilogue_arguments}" >/dev/null 2>&1
    exit $?
    )
    epilogue_status=$?
    if [ ${epilogue_status} -ne 0 ]; then
      fatal_error "epilogue failed with error ${epilogue_status}"
    fi
  else
    fatal_error "epilogue ${__epilogue} not found"
  fi
fi

OSB_transfer

log_done_ok "${status}"

# DGAS specific stuff: do it only if DAGS client is installed
if [ -x ${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient} ]; then
  if [ -n "${LSB_JOBID}" ]; then
    cat "${X509_USER_PROXY}" | ${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient -s ${__gatekeeper_hostname}:56569: -L lsf_${LSB_JOBID} -G ${EMI_WMS_JOBID} -C ${__globus_resource_contact_string} -H "$HLR_LOCATION"
    if [ $? != 0 ]; then
      jw_echo "Error transferring gianduia with command: cat ${X509_USER_PROXY} | ${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient -s ${__gatekeeper_hostname}:56569: -L lsf_${LSB_JOBID} -G ${EMI_WMS_JOBID} -C ${__globus_resource_contact_string} -H $HLR_LOCATION"
    fi
  fi

  if [ -n "${PBS_JOBID}" ]; then
    cat ${X509_USER_PROXY} | ${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient -s ${__gatekeeper_hostname}:56569: -L pbs_${PBS_JOBID} -G ${EMI_WMS_JOBID} -C ${__globus_resource_contact_string} -H "$HLR_LOCATION"
    if [ $? != 0 ]; then
      jw_echo "Error transferring gianduia with command: cat ${X509_USER_PROXY} | ${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient -s ${__gatekeeper_hostname}:56569: -L pbs_${PBS_JOBID} -G ${EMI_WMS_JOBID} -C ${__globus_resource_contact_string} -H $HLR_LOCATION"
    fi
  fi
else
  jw_echo "${EMI_WMS_LOCATION}/libexec/EMI_dgas_ceServiceClient not installed: ignoring gianduia transfer."
fi

# customization point #3
if [ -n "${EMI_LOCAL_CUSTOMIZATION_DIR}" ]; then
  if [ -r "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_3.sh" ]; then
    . "${EMI_LOCAL_CUSTOMIZATION_DIR}/cp_3.sh"
  fi
fi

doExit 0
EOF

'/software/components/wmslb/services/wm/jobWrapper/file' = WMS_JOB_WRAPPER;
'/software/components/wmslb/services/wm/jobWrapper/contents' = WMS_JOB_WRAPPER_CONTENTS;
