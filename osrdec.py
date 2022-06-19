# Decompresses .osr files
# Uses https://github.com/kszlim/osu-replay-parser, modified for mania purposes
# Type pip install osrparse to start
import lzma
import os
import numpy as np
import pandas as pd
import struct
from osrparse import Replay, parse_replay_data
from datetime import datetime, timezone, timedelta
os.chdir(os.getcwd())
pathf = "_hashinshin - Camellia - Shun no Shifudo o Ikashita Kare Fumi Paeria [Giant Pacific Octopus] (2020-05-13) OsuMania.osr"
pathg = "replay-mania_1443309_419638875.osr"

def uf(x, d, i):
    # x = format, d = data i = k
    return struct.unpack_from(x, d, i)

def frd(path):
    k = 0 # offset
    with open(path, "rb") as f:
        data = f.read()
        mode = uf("b", data, k)[0] # should always be 3
        k += 1
        gamever = uf("i", data, k)[0] # YYYYMMDD
        k += 4
        k = 121 + 253643
        # 1146, 16934
        data2 = lzma.decompress(data[121:k], format=lzma.FORMAT_AUTO)
        print("decomp")
        data2 = data2.decode("ascii")
        print("decoded")
        arr = [i.split('|') for i in data2.split(',')]
        print("split")
        xd = [-1] * len(arr)
        for i in np.arange(len(arr)):
            if len(arr[i]) > 1:
                xd[i] = int(arr[i][0])
            # print(i[1])
        print("appended")
        return xd



'''
with open(pathf, "rb") as f:
    data = f.read()
    mode = struct.unpack_from("b", data, 0)[0] # should always be 3
    gamever = struct.unpack_from("i", data, 1)[0] # YYYYMMDD
    print(gamever)
    '''

# r = Replay.from_path(pathg)
# print(r.replay_data)
# print(r.replay_data[100])
# print(uf("h", "%".encode(), 0))
kk = frd(pathg)
print(kk)