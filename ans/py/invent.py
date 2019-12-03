#!/usr/bin/env python

# ansible "getcmdb" inventory script

import csv
import json
import urllib3
import sys
import re

#################################################
hostLists = {
              "_meta"         : { "hostvars": {} }, # See https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
              "all"           : { "children": ['ungrouped', 'solaris', 'linux'] }, # The all group is just a supergroup for all hosts
              "linux"         : { "children": ['redhat6', 'redhat7'] }, # A supergroup just for Linux hosts
              "ungrouped"     : [] # According to the doc, this should be a dict, but ansible thinks it's a host and throws a warning. As a list, it's fine.
}

for group in ['solaris', 'redhat6', 'redhat7']: hostLists[group] = [] # Initialize empty host lists for every host grouping we want.
################################################

# Linux
http = urllib3.PoolManager()
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=76')

# reformat my input as CSV
data = "".join(map(chr,r.data))
data = data.split('\n')
all_linux_csv = csv.DictReader(data, delimiter=';')
#for row in all_linux_csv:
#   print(row)

# Print Brutto
#print(r.data)

# Print Netto
#if sys.argv[1] == '--debug':
#    for row in all_linux_csv:
#        print(row)

# Solaris
#r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=26')


##########################################################
for hostObj in all_linux_csv:
  # if sys.argv[1] == '--debug': print(hostObj)
  # v = re.search("*.el6.*", (hostObj['OS KERNEL PATCH']))
  # if hostObj['OS KERNEL PATCH'] == v: print(hostObj['NAME']) #hostLists['redhat6'].append(hostObj['NAME']) 
  if re.search("*.el6.*", (hostObj['OS KERNEL PATCH'])): print(hostObj['NAME'])


#############################################################
#   Arguments Manadatory for Ansible Compliance
#############################################################
#if sys.argv[1] == '--list': # Mandatory return for ansible. Should return a list of all hosts
#   print json.dumps(hostLists)

#if sys.argv[1] == '--host': # Mandatory return for ansible. Should return an empty dict or vars for one host (vars not implemented)
#   print json.loads('{}')



