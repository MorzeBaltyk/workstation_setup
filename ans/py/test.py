#!/usr/bin/env python

import requests
from contextlib import closing
import csv

url = "http://infra1-pk:8181/modules/mpirequester/lists.php?id=76" 

with closing(requests.get(url, stream=True)) as r:
    f = (line.decode('utf-8') for line in r.iter_lines())
    reader = csv.reader(f, delimiter=';', quotechar='"')
    for row in reader:
        print(row)

