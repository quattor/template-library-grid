#!/usr/bin/python
# Add HTCondor job information from the history files to a MySQL database

from xml.etree import ElementTree
import mysql.connector
import sys
import subprocess
import glob
from datetime import datetime, timedelta

# Open connection to database
cnx = mysql.connector.connect(host='condormon.gridpp.rl.ac.uk', user='condorwrite', password='insert_a_good_password_here', database='condorjobs')

# Useful function
def getValue(node):
   for bit in node.getchildren():
      text = bit.text
   return text

# Generate date string to use for finding the right history files
usedate = datetime.now()
mydate = '%d%02d%02d' % (usedate.year, usedate.month, usedate.day)

# Get list of all required files
if len(sys.argv) == 1:
   files = glob.glob('/var/lib/condor/spool/history.'+mydate+'*')
else:
   files = sys.argv
   files.pop(0)

for file in files:
   print file

   # Copy history file to long-term storage directory if necessary
   p = subprocess.Popen(["cp", "-f", file, "/var/local/condor-history/."], stdout=subprocess.PIPE)
   output, err = p.communicate()

   # Read in XML output from condor_history
   p = subprocess.Popen(["condor_history", "-xml", "-file", file], stdout=subprocess.PIPE)
   output, err = p.communicate()
   document = ElementTree.fromstring(output)

   data = {}
   count = 0
   countA = 0
   countW = 0

   # List of required attributes
   req = ['ClusterId', 'ProcId', 'GlobalJobId', 'Owner', 'AcctGroup', 'ExitStatus', 'LastRemoteHost', 'RequestCpus', 'RequestMemory', 'QDate', 'JobCurrentStartDate', 'CompletionDate', 'RemoteUserCpu', 'RemoteSysCpu', 'RemoteWallClockTime' ,'ResidentSetSize_RAW', 'ImageSize_RAW', 'DiskUsage_RAW', 'NumJobStarts', 'NumShadowStarts', 'MATCH_EXP_MachineRalScaling']

   for job in document.findall( 'c' ):
      data = {}
      data['AcctGroup'] = ''      
      data['LastRemoteHost'] = ''
      data['QDate'] = 0
      data['JobCurrentStartDate'] = 0
      data['CompletionDate'] = 0
      data['NumJobStarts'] = 0
      data['NumShadowStarts'] = 0
      data['RemoteUserCpu'] = 0
      data['RemoteSysCpu'] = 0
      data['RemoteWallClockTime'] = 0
      data['ResidentSetSize_RAW'] = 0
      data['ImageSize_RAW'] = 0
      data['DiskUsage_RAW'] = 0
      data['MATCH_EXP_MachineRalScaling'] = 0

      for bit in job.findall( 'a' ):   
         attr = bit.attrib[ 'n' ]
         for item in req:
            if attr == item:
               data[item] = getValue(bit)

      # Check if the current job has already been inserted into the database
      cursor1 = cnx.cursor()
      query = 'SELECT COUNT(*) FROM condorjobs WHERE GlobalJobId = "' + data['GlobalJobId'] + '"'
      cursor1.execute(query)
      results = cursor1.fetchall()
      num = 0
      for result in results:
         num = result[0]
      cursor1.close()

      # Add the current job to the database if (1) it hasn't already been added, and (2) the number of
      # attributes found is correct
      if num == 0 and len(data) == 21:
         if data['ImageSize_RAW'] > 2147483647:
            data['ImageSize_RAW'] = 2147483647
         count = count + 1
         cursor = cnx.cursor()
         add_job = ("INSERT into condorjobs (ClusterId,ProcId,GlobalJobId,Owner,AcctGroup,LastRemoteHost,RequestCpus,RequestMemory,ExitStatus,QDate,JobCurrentStartDate,CompletionDate,RemoteUserCpu,RemoteSysCpu,RemoteWallClockTime,ResidentSetSize_RAW,ImageSize_RAW,DiskUsage_RAW,NumJobStarts,NumShadowStarts,RalScaling) "
                    "VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)")
         data_job = (data['ClusterId'],
                     data['ProcId'],
                     data['GlobalJobId'],
                     data['Owner'],
                     data['AcctGroup'],
                     data['LastRemoteHost'],
                     data['RequestCpus'],
                     data['RequestMemory'],
                     data['ExitStatus'],
                     data['QDate'],
                     data['JobCurrentStartDate'],
                     data['CompletionDate'],
                     data['RemoteUserCpu'],
                     data['RemoteSysCpu'],
                     data['RemoteWallClockTime'],
                     data['ResidentSetSize_RAW'],
                     data['ImageSize_RAW'],
                     data['DiskUsage_RAW'],
                     data['NumJobStarts'],
                     data['NumShadowStarts'],
                     data['MATCH_EXP_MachineRalScaling'])
         cursor.execute(add_job, data_job)
         cursor.close()
      elif num != 0:
         countA = countA + 1
      else:
         countW = countW + 1

   countF = countA + countW
   print 'Added',count,'records to the database from file',file,'and skipped',countF,'records (',countA,'already added and',countW,'invalid)'

cnx.close()
