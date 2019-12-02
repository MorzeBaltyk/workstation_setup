#!/usr/bin/env python

# ansible "getcmdb" inventory script

import json
import csv
import urllib3
import io
import sys

#hostLists = {
#    "_meta": {
#        "hostvars": {}
#    },  # See https://docs.ansible.com/ansible/latest/dev_guide/developing_inventory.html#tuning-the-external-inventory-script
#    "all": {
#        "children": ["ungrouped", "solaris", "linux"]
#    },  # The all group is just a supergroup for all hosts
#    "linux": {
#        "children": ["redhat5", "redhat6", "redhat7"]
#    },  # A supergroup just for Linux hosts
#    "restrictedNET": {"children": ["SHS", "DMZ"]},  # A supergroup for SHS and DMZ hosts
#    "ungrouped": [],  # According to the doc, this should be a dict, but ansible thinks it's a host and throws a warning. As a list, it's fine.
#}

#for group in ["solaris", "redhat5", "redhat6", "redhat7", "SHS", "DMZ", "LAN"]: hostLists[group] = []  # Initialize empty host lists for every host grouping we want.

# Linux
http = urllib3.PoolManager()
r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=76')
data = "".join(map(chr,r.data))
data = data.split('\n')



# Print Brutto
#print(r.data)

# Print Netto
#data = "".join(map(chr,r.data))
#data = data.split('\n')
#for row in data:
#    print(row)



#csv_read = csv.reader(r)
#for line in csv_read:
#  print(line)

# Solaris
#r = http.request('GET', 'http://infra1-pk:8181/modules/mpirequester/lists.php?id=26')
#r.data
