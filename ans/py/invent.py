#!/usr/bin/env python

# ansible "getcmdb" inventory script

import csv
import json
import urllib3
import sys
import re
import os
import subprocess
import socket
import argparse


def parseArgs(): # Function which parses the command-line arguments we expect.
   parser = argparse.ArgumentParser() # We uses the argparse library (https://docs.python.org/3/library/argparse.html)
   parser.add_argument('--debug','-d', action='store_true', help='Show debug stuff')
   parser.add_argument('--list','-l', action='store_true', help='Mandatory return for ansible. Should return a list of all hosts')
   #parser.add_argument('--host','-o', type=str, help='Mandatory return for ansible. Should return an empty dict or vars for one host (vars not implemented)')
   return parser.parse_args()

if __name__ == "__main__":
   args = parseArgs()

#################################################
hostLists = {
              "_meta"         : { "hostvars": {} }, # See https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
              "all"           : { "children": ['ungrouped', 'solaris', 'linux'] }, # The all group is just a supergroup for all hosts
              "linux"         : { "children": ['redhat6', 'redhat7'] }, # A supergroup just for Linux hosts
              "ungrouped"     : [] # According to the doc, this should be a dict, but ansible thinks it's a host and throws a warning. As a list, it's fine.
}

for group in ['solaris', 'redhat6', 'redhat7']: hostLists[group] = [] # Initialize empty host lists for every host grouping we want.

##################################################

# Linux
http = urllib3.PoolManager()
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=76')
data = "".join(map(chr,r.data)) # reformat my input as CSV
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
  if args.debug: 
      for row in all_linux_csv: 
          print(row)

  if re.search(r".*el6.*", (hostObj['OS KERNEL PATCH'])): hostLists['redhat6'].append(hostObj['NAME']) #print(hostObj['NAME'])
  if re.search(r".*el7.*", (hostObj['OS KERNEL PATCH'])): hostLists['redhat7'].append(hostObj['NAME']) #print(hostObj['NAME'])


#############################################################
#   Arguments Manadatory for Ansible Compliance
#############################################################
if args.list:
    print(json.dumps(hostLists))

#if args.host:
    #print(args.host)
    #print(json.loads('{}')

#if sys.argv[1] == '--host': # Mandatory return for ansible. Should return an empty dict or vars for one host (vars not implemented)
#   print json.loads('{}')



