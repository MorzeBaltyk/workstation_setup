#!/usr/bin/env python

# ansible "getcmdb" inventory script

import json
import csv
import urllib3
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
req = urllib3.request("http://infra1-pk:8181/modules/mpirequester/lists.php?id=76")
# allHosts_Json = json.loads(urllib2.urlopen(req).read())
# allLinux_csv = csv.reader(req)
print(req.read())

# Solaris
# req = urllib.request("http://infra1-pk:8181/modules/mpirequester/lists.php?id=26")
# allClusters_Json = json.loads(urllib2.urlopen(req).read())
# allSolaris_csv = csv.reader(req)

# data = []
# for row in datareader:
#    data.append(row)

#print(data)
