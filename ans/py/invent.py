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
import pandas

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
              "all"           : { "children": ['ungrouped', 'solaris', 'linux', 'linuxvm'] }, # The all group is just a supergroup for all hosts
              "linux"         : { "children": ['redhat6', 'redhat7'] }, # A supergroup just for Linux Physical hosts
              "linuxvm"         : { "children": ['redhat6vm', 'redhat7vm'] }, # A supergroup just for Linux VM's
              "solaris"         : { "children": ['zone', 'primary', 'secondary'] }, # A supergroup just for Linux VM's
              "ungrouped"     : [] # According to the doc, this should be a dict, but ansible thinks it's a host and throws a warning. As a list, it's fine.
}

for group in ['zone', 'primary', 'secondary', 'redhat6', 'redhat7', 'redhat6vm', 'redhat7vm']: hostLists[group] = [] # Initialize empty host lists for every host grouping we want.

durtyList = {}
durtyList['redhat6vm'] = []
durtyList['redhat7vm'] = []
durtyList['redhat6'] = []
durtyList['redhat7'] = []

##################################################

# Linuxvm
http = urllib3.PoolManager()
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=76')
data = "".join(map(chr,r.data)) # reformat my input as CSV
data = data.split('\n')
all_linuxvm_csv = csv.DictReader(data, delimiter=';')

# Linux Physical
http = urllib3.PoolManager()
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=65')
data = "".join(map(chr,r.data)) # reformat my input as CSV
data = data.split('\n')
all_linux_csv = csv.DictReader(data, delimiter=';')

# Solaris Host
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=35')
data = "".join(map(chr,r.data)) # reformat my input as CSV
data = data.split('\n')
all_host_csv = csv.DictReader(data, delimiter=';')

# Solaris Zone
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=26')
data = "".join(map(chr,r.data)) # reformat my input as CSV
data = data.split('\n')
all_zone_csv = csv.DictReader(data, delimiter=';')



##########################################################

for hostObj in all_linuxvm_csv:
  if re.search(r".*el6.*", (hostObj['OS KERNEL PATCH'])): durtyList['redhat6vm'].append(hostObj['NAME']) 
  if re.search(r".*el7.*", (hostObj['OS KERNEL PATCH'])): durtyList['redhat7vm'].append(hostObj['NAME']) 

rh6vm = list(set(durtyList['redhat6vm'])) #Sort uniq
rh7vm = list(set(durtyList['redhat7vm'])) 

for hostObj in rh6vm:
    ping_test=subprocess.Popen(["fping", "-c", "1", hostObj], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = ping_test.communicate()
    if (ping_test.returncode == 0): hostLists['redhat6vm'].append(hostObj)

for hostObj in rh7vm:
    ping_test=subprocess.Popen(["fping", "-c", "1", hostObj], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = ping_test.communicate()
    if (ping_test.returncode == 0): hostLists['redhat7vm'].append(hostObj)


for hostObj in all_linux_csv:
  if re.search(r".*el6.*", (hostObj['KERNEL PATCH'])): durtyList['redhat6'].append(hostObj['HOST NAME']) 
  if re.search(r".*el7.*", (hostObj['KERNEL PATCH'])): durtyList['redhat7'].append(hostObj['HOST NAME']) 

rh6 = list(set(durtyList['redhat6'])) #Sort uniq
rh7 = list(set(durtyList['redhat7'])) 

for hostObj in rh6:
    ping_test=subprocess.Popen(["fping", "-c", "1", hostObj], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = ping_test.communicate()
    if (ping_test.returncode == 0): hostLists['redhat6'].append(hostObj)

for hostObj in rh7:
    ping_test=subprocess.Popen(["fping", "-c", "1", hostObj], stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    stdout, stderr = ping_test.communicate()
    if (ping_test.returncode == 0): hostLists['redhat7'].append(hostObj)


for hostObj in all_host_csv:
  if hostObj['DOMAIN'] == 'Domain 0': hostLists['primary'].append(hostObj['HOST NAME']) #print(hostObj['NAME'])
  if hostObj['DOMAIN'] == 'Domain 1': hostLists['secondary'].append(hostObj['HOST NAME']) #print(hostObj['NAME'])

for hostObj in all_zone_csv:
  if hostObj['ZONE NAME'] not in hostLists['zone']: hostLists['zone'].append(hostObj['ZONE NAME']) 


#############################################################
#     Arguments Manadatory for Ansible Compliance
#############################################################
if args.debug:
    for row in all_linuxvm_csv:
        print(row)
      #for row1 in all_linux_csv:
      #    print(row1)
      #for row2 in all_host_csv:
      #    print(row2)
      #for row3 in all_zone_csv:
      #    print(row3)

if args.list:
    print(json.dumps(hostLists))

#if args.host:
    #print(args.host)
    #print(json.loads('{}')

#if sys.argv[1] == '--host': # Mandatory return for ansible. Should return an empty dict or vars for one host (vars not implemented)
#   print json.loads('{}')



