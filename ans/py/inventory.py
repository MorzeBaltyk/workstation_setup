#!/usr/bin/env python

# ansible united inventory script 
# Created and Maintained by Konstantinos Thoukydidis

import json
import urllib2
import sys

hostLists = {
              "_meta"         : { "hostvars": {} }, # See https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
              "all"           : { "children": ['ungrouped', 'solaris', 'linux'] }, # The all group is just a supergroup for all hosts
              "linux"         : { "children": ['redhat5', 'redhat6', 'redhat7'] }, # A supergroup just for Linux hosts
              "restrictedNET" : {"children": ['SHS', 'DMZ'] }, # A supergroup for SHS and DMZ hosts
              "ungrouped"     : [] # According to the doc, this should be a dict, but ansible thinks it's a host and throws a warning. As a list, it's fine.
}
for group in ['solaris', 'redhat5', 'redhat6', 'redhat7', 'SHS', 'DMZ', 'LAN']: hostLists[group] = [] # Initialize empty host lists for every host grouping we want.

req = urllib2.Request('http://united-ws.cc.cec.eu.int/serverdb/views/json/ws_listallhosts11/')
allHosts_Json = json.loads(urllib2.urlopen(req).read())
req = urllib2.Request('http://united-ws.cc.cec.eu.int/serverdb/views/json/ws_AllClustersNames1/')
allClusters_Json = json.loads(urllib2.urlopen(req).read())

for hostObj in allHosts_Json: # We add each hosts to its OS/LAN-type group.
   if (hostObj['hstatus'] == 'decommissioned' or 
       hostObj['hstatus'] == 'decomm candidate' or 
       hostObj['hstatus'] == 'under installation' or
       hostObj['osmaj'] == 'unknown'): continue # We don't care about decommissioned or under install hosts
   if hostObj['osfam'] == 'SunOS': hostLists['solaris'].append(hostObj['hname']) # Create a list for solaris hosts
   if hostObj['osfam'] == 'Linux': hostLists['redhat{}'.format(hostObj['osmaj'])].append(hostObj['hname']) # Create a list for each major RHEL RC. The 'osmaj' entry in UNITED contains the RC number (i.e. 5 for RHEL5.x)
   if hostObj['shsgroup'] != 'no': hostLists['SHS'].append(hostObj['hname']) # Create a list for SHS hosts
   elif hostObj['dmz'] != '0': hostLists['DMZ'].append(hostObj['hname']) # Create a list for DMZ hosts
   else: hostLists['LAN'].append(hostObj['hname']) # Create a list for Non-restricted hosts
   
for hostObj in allClusters_Json: # We add each host to its cluster group, if any.
   if sys.argv[1] == '--debug': print(hostObj)
   if hostObj['cname'] not in hostLists.keys(): # We create lists dynamically for each cluster group name that exists in UNITED.
      hostLists[hostObj['cname']] = []
      hostLists[hostObj['racname']] = []
   if sys.argv[1] == '--debug': print("adding {} to {}".format(hostObj['hname'], hostLists[hostObj['cname']]))
   hostLists[hostObj['racname']].append(hostObj['hname']) # We add the host to its RAC name (oracle SID)
   if hostObj['hname'] not in hostLists[hostObj['cname']]: # We check that it's not already in the list to avoid double entries on buffer rac hosts where their canonical name == RAC name.
      hostLists[hostObj['cname']].append(hostObj['hname']) # We add the host to its canonical cluster name.
  
if sys.argv[1] == '--list': # Mandatory return for ansible. Should return a list of all hosts
   print json.dumps(hostLists)

if sys.argv[1] == '--host': # Mandatory return for ansible. Should return an empty dict or vars for one host (vars not implemented)
   print json.loads('{}')

