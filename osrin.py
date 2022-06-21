import lzma
import os
import struct
from datetime import datetime, timezone, timedelta
import sys
from subprocess import call
from io import StringIO
os.chdir(os.getcwd())
str = os.popen("osrin").read().split('\n') # please put osrin.py and osrin.c in the same directory and gcc from this directory
bmhash = str[2][14:]
playername = str[3][13:]
maphash = str[4][10:]
judges = (int(str[5][11:]), int(str[6][11:]), int(str[7][11:]), int(str[8][11:]), int(str[9][10:]), int(str[10][12:]))
score = int(str[11][7:])
combo = int(str[12][11:])
mods = int(str[14][6:])
tx = int(str[15][20:])
timestamp = datetime.min + timedelta(microseconds=tx/10)
timestamp = timestamp.replace(tzinfo=timezone.utc)
rdatabounds = list(map(int, str[16][13:].split(' ')))
rid = str[17][11:]

pathf = "replay-mania_3362200_497162661.osr";
with open(pathf, "rb") as f:
    data = f.read()
    data = data[rdatabounds[0]:rdatabounds[1]]
    data = lzma.decompress(data, format=lzma.FORMAT_AUTO).decode("ascii")
    data = data[:-1]
    arr = [i.split('|') for i in data.split(',')]
    rng = None 
    arrdelta = []
    arrx = []
    for i in arr:
        delta = int(i[0])
        x = i[1]
        if delta == -12345 and i == arr[-1]:
            rng = int(i[3])
            continue
        arrdelta.append(delta)
        arrx.append(x)

# come back to this