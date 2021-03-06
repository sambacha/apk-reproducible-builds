#!/usr/bin/python

from zipfile import ZipFile
import sys

"""
Canonicalize a zip/jar file.  Sets all the filestamps to a specific date.

    canon-zip YYYY-MM-DD INPUT OUTPUT

"""

(year, month, day) = sys.argv[1].split('-')
year = int(year)
month = int(month)
day = int(day)

with ZipFile(sys.argv[3], 'w') as outzip:
    with ZipFile(sys.argv[2], 'r') as inzip:
        for info in inzip.infolist():
            info.date_time = (year, month, day, 0, 0, 0)
            content = inzip.read(info.filename)
            outzip.writestr(info, content)
