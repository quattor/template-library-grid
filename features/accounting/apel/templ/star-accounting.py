#!/usr/bin/env python



###########################################################################
#
# star-accounting
#
# A script that produces an accounting record following the EMI StAR specs
# in the version 1.2
#
# Syntax:
#
# star-accounting [-h] [--help]
# .. to get the help screen
#
#
#  v1.0.0 initial release
#  v1.0.2 removed site debug printouts that were screwing up the output
#  v1.0.3 avoid summing the size fields for directories. Fixes EGI doublecounting
#  v1.0.4 marks the report as regarding the past period, not the next one; parse
#         the DPM group names into VO and role
#

__version__ = "1.2.4"
__author__  = "Fabrizio Furano"



import sys
import os
import os.path
import socket
import re
from optparse import OptionParser
import MySQLdb
import lxml.builder as lb
from lxml import etree
import uuid
import platform 
import datetime













# yum install MySQL-python python-lxml python-uuid

def addrecord(xmlroot, hostname, group, user, site, filecount, resourcecapacityused, logicalcapacityused, validduration, recordid = None):
  # update XML 
  rec = etree.SubElement(xmlroot, SR+'StorageUsageRecord')
  rid = etree.SubElement(rec, SR+'RecordIdentity')
  rid.set(SR+"createTime", datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ"))

  if hostname:
    ssys = etree.SubElement(rec, SR+"StorageSystem")
    ssys.text = hostname

  recid = recordid  
  if not recid:
    recid = hostname+"-"+str(uuid.uuid1())
  rid.set(SR+"recordId", recid)

  subjid = etree.SubElement(rec, SR+'SubjectIdentity')

  if group:
    grouproles = group.split('/')

    # If the last token is Role=... then we fetch the role and add it to the record
    tmprl = grouproles[-1]
    if tmprl.find('Role=') != -1:
      splitroles = tmprl.split('=')
      if (len(splitroles) > 1):
        role = splitroles[1]
        grp = etree.SubElement(subjid, SR+"GroupAttribute" )
        grp.set( SR+"attributeType", "role" )
        grp.text = role
      # Now drop this last token, what remains is the vo identifier
      grouproles.pop()


    # The voname is the first token
    voname = grouproles.pop(0)
    grp = etree.SubElement(subjid, SR+"Group")
    grp.text = voname

    # If there are other tokens, they are a subgroup
    if len(grouproles) > 0:
      subgrp = '/'.join(grouproles)
      grp = etree.SubElement(subjid, SR+"GroupAttribute" )
      grp.set( SR+"attributeType", "subgroup" )
      grp.text = subgrp

  if user:
    usr = etree.SubElement(subjid, SR+"User")
    usr.text = user

  if site:
    st = etree.SubElement(subjid, SR+"Site")
    st.text = site

  e = etree.SubElement(rec, SR+"StorageMedia")
  e.text = "disk"

  if validduration:
    e = etree.SubElement(rec, SR+"StartTime")
    d = datetime.datetime.utcnow() - datetime.timedelta(seconds=validduration)
    e.text = d.strftime("%Y-%m-%dT%H:%M:%SZ")

  e = etree.SubElement(rec, SR+"EndTime")
  e.text = datetime.datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")


  if filecount:
    e = etree.SubElement(rec, SR+"FileCount")
    e.text = str(filecount)











  if not resourcecapacityused:
    resourcecapacityused = 0

  e1 = etree.SubElement(rec, SR+"ResourceCapacityUsed")
  e1.text = str(resourcecapacityused)

  e3 = etree.SubElement(rec, SR+"ResourceCapacityAllocated")
  e3.text = str(resourcecapacityused)

  if not logicalcapacityused:
    logicalcapacityused = 0

  e2 = etree.SubElement(rec, SR+"LogicalCapacityUsed")
  e2.text = str(logicalcapacityused)



#
# Get how much space was reserved for the given gid
#
def getreservedspacebygid(dbconn, gid):
  if not gid:
    return 0

  i = int(gid)
  cursor = dbconn.cursor ()
  select_stmt = "select sum(t_space) from dpm_space_reserv where s_gid = %(gid)s"
  cursor.execute (select_stmt, { 'gid': i})

  row = cursor.fetchone ()
  if row == None:
    return 0

  return row[0]
  


#
# Get how much space was reserved for the given uid
#
def getreservedspacebyuid(dbconn, uid):
  if not uid:
    return 0

  i = int(uid)

  cursor = dbconn.cursor ()
  select_stmt = "select sum(t_space) from dpm_space_reserv where s_uid = %(uid)s"
  cursor.execute (select_stmt, { 'uid': i})

  row = cursor.fetchone ()
  if row == None:
    return 0

  return row[0]







def getdnsnames(name): 
  d = socket.gethostbyaddr(name) 
  names = [ d[0] ] + d[1] + d[2] 
  return names 

def resolve(name): 
  names = getdnsnames(name) 
  for dnsname in names: 
    if '.' in dnsname: 
      fullname = dnsname 
      break 
    else: 
      fullname = name 
  return fullname 

def gethostname(): 
  fullname = socket.gethostname() 
  if '.' not in fullname: 
    fullname = resolve(fullname) 
  return fullname

#############
# Main code #
#############


parser = OptionParser()
parser.add_option('--reportgroups', dest='reportgroups', action='store_true', default=False, help="Report about all groups")
parser.add_option('--reportusers', dest='reportusers', action='store_true', default=False, help="Report about all users")
parser.add_option('-v', '--debug', dest='verbose', action='count', help='Increase verbosity level for debugging (on stderr)')
parser.add_option('--hostname', dest='hostname', default=gethostname(), help="The hostname string to use in the record. Default: this host.")
parser.add_option('--site', dest='site', default="", help="The site string to use in the record. Default: none.")
parser.add_option('--recordid', dest='recordid', default=None, help="The recordid string to use in the record. Default: a newly computed unique string.")
parser.add_option('--nsconfig', dest='nsconfig', default=None, help="Path to the NSCONFIG file where to take the db login info")
parser.add_option('--dpmconfig', dest='dpmconfig', default=None, help="Path to the DPMCONFIG file where to take the db login info")
parser.add_option('--dbhost', dest='dbhost', default=None, help="Database host, if no NSCONFIG given")
parser.add_option('--dbuser', dest='dbuser', default=None, help="Database user, if no NSCONFIG given")
parser.add_option('--dbpwd', dest='dbpwd', default=None, help="Database password, if no NSCONFIG given")
parser.add_option('--nsdbname', dest='nsdbname', default='cns_db', help="NS Database name, if no NSCONFIG given")
parser.add_option('--dpmdbname', dest='dpmdbname', default='dpm_db', help="DPM Database name, if no DPMCONFIG given")
parser.add_option('--validduration', dest='validduration', default=86400, help="Valid duration of this record, in seconds (default: 1 day)")
options, args = parser.parse_args()

record_id = options.recordid
site = options.site
dbhost = options.dbhost
dbuser = options.dbuser
dbpwd = options.dbpwd
nsdbname = options.nsdbname
dpmdbname = options.dpmdbname

if options.nsconfig:
  # Parse the NSCONFIG line, extract the db login info from it
  try:
    f = open(options.nsconfig, 'r')
    s = f.read()
    s = s.strip()

    dbuser,next=re.split("/",s,1)
    dbpwd,next=re.split("@",next,1)
    try:
      dbhost,next=re.split("/",next,1)
      nsdbname=next
    except:
      dbhost=next
    
    dbuser = dbuser.strip()
    dbpwd = dbpwd.strip()
    dbhost = dbhost.strip()
    nsdbname = nsdbname.strip()
  except Exception, e:
    print "Error while accessing NSCONFIG. " + str(e)
    sys.exit(1);

if options.dpmconfig:
  # Parse the DPMCONFIG line, extract the db login info from it
  try:
    f = open(options.dpmconfig, 'r')
    s = f.read()
    s = s.strip()

    dbuser,next=re.split("/",s,1)
    dbpwd,next=re.split("@",next,1)
    try:
      dbhost,next=re.split("/",next,1)
      dpmdbname=next
    except:
      dbhost=next

    dbuser = dbuser.strip()
    dbpwd = dbpwd.strip()
    dbhost = dbhost.strip()
    dpmdbname = dpmdbname.strip()
  except Exception, e:
    print "Error while accessing DPMCONFIG. " + str(e)
    sys.exit(1);




#
# Connect to the db
#

if options.verbose:
    print dbuser
    print dbpwd
    print dbhost
    print nsdbname
    print dpmdbname
try:
  nsconn = MySQLdb.connect (str(dbhost), str(dbuser), str(dbpwd), str(nsdbname))
except MySQLdb.Error, e:
  print "Error Connecting to mysql. %d: %s" % (e.args[0], e.args[1])
  sys.exit (1)


try:
  dpmconn = MySQLdb.connect (str(dbhost), str(dbuser), str(dbpwd), str(dpmdbname))
except MySQLdb.Error, e:
  print "Error Connecting to mysql. %d: %s" % (e.args[0], e.args[1])
  sys.exit (1)



#
# Init the xml generator
#
SR_NAMESPACE = "http://eu-emi.eu/namespaces/2011/02/storagerecord"
SR = "{%s}" % SR_NAMESPACE
NSMAP = {"sr": SR_NAMESPACE}
xmlroot = etree.Element(SR+"StorageUsageRecords", nsmap=NSMAP)










if options.reportgroups:
  #
  # Report about groups
  #

  if options.verbose:
    print "Groups reporting: starting"

  cursor = nsconn.cursor ()
  cursor.execute ("select m.gid, g.groupname, count(*), sum(m.filesize) from Cns_file_metadata m, Cns_groupinfo g where m.gid=g.gid AND filemode&16384=0 group by m.gid;")

  while (1):
    row = cursor.fetchone ()
    if row == None:
      break
    if options.verbose:
      print row
  
    # update XML 
    addrecord(xmlroot, options.hostname, row[1], None, site, row[2], getreservedspacebygid(dpmconn, row[0]), row[3], options.validduration, record_id)
    

  if options.verbose:
    print "Groups reporting: number of rows returned: %d" % cursor.rowcount

  cursor.close()






if options.reportusers:
  #
  # Report about users
  #

  if options.verbose:
    print "Users reporting: starting"

  cursor = nsconn.cursor ()
  cursor.execute ("select m.owner_uid, u.username, count(*), sum(m.filesize) from Cns_file_metadata m, Cns_userinfo u where m.owner_uid=u.userid AND filemode & 16384=0 group by m.owner_uid;")
  
  while (1):
    row = cursor.fetchone ()
    if row == None:
      break
    if options.verbose:
      print row
    # update XML 
    addrecord(xmlroot, options.hostname, None, row[1], site, row[2], getreservedspacebyuid(dpmconn, row[0]), row[3], options.validduration, record_id)

  if options.verbose:
    print "Users reporting: number of rows returned: %d" % cursor.rowcount

  cursor.close()


nsconn.close()
dpmconn.close()

# pretty string
s = etree.tostring(xmlroot, pretty_print=True)
print
print s
print
