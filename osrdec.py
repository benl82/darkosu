# Decompresses .osr files
# Adapted https://github.com/kszlim/osu-replay-parser, modified for mania purposes
import lzma
import os
import struct
# from osrparse import Replay, parse_replay_data
from datetime import datetime, timezone, timedelta
os.chdir(os.getcwd())
pathf = "_hashinshin - Camellia - Shun no Shifudo o Ikashita Kare Fumi Paeria [Giant Pacific Octopus] (2020-05-13) OsuMania.osr"
pathg = "replay-mania_1443309_419638875.osr"
def uf(x, d, i):
    # x = format, d = data, i = the offset
    return struct.unpack_from(x, d, i)[0]
def sl(bs, i):
    # returns tuple of (s_l, new offset)
    res = 0
    while True:
        byte = bs[i]
        i += 1
        # res = res |((byte & 0b01111111) << shift) # <- wtf? lol
        res = int(byte)
        if (byte & 0b10000000) == 0x00:
            break
    return (res, i)
def prd(d):
    d = d[:-1] # last char should be comma, throw it away
    arr = [i.split('|') for i in d.split(',')]
    rng = None # might be relevant, idk?
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
    return (arrdelta, arrx, rng)
def us(d, i):
    if d[i] == 0x00:
        i += 1
    elif d[i] == 0x0b:
        i += 1
        (s_l, k) = sl(d, i)
        i = k
        str = d[i:(i+s_l)].decode("utf-8")
        return (str, i+s_l)
    else:
        raise ValueError("Bad string start character (should be 0x0b or 0x00)")
def upd(d, i):
    rl = uf("i", d, i)
    data = d[(i+4):(i+4+rl)]
    data = lzma.decompress(data, format=lzma.FORMAT_AUTO).decode("ascii")
    return (prd(data)[0], prd(data)[1], prd(data)[2], i+4+rl) # new offset is [3]
def uri(d, i):
    # see osr parse
    try:
        rid = uf("q", d, i)
    except struct.error:
        rid = uf("l", d, i)
    return rid
def frd(path):
    # everything besides the play data + rng seed
    k = 5 # offset, skips mode and gamever since I don't care
    with open(path, "rb") as f:
        data = f.read()
        bmhash = us(data, k)[0]
        k = us(data, k)[1]
        usr = us(data, k)[0]
        k = us(data, k)[1]
        rphash = us(data, k)[0]
        k = us(data, k)[1]
        n300 = uf("H", data, k)
        n100 = uf("H", data, k + 2)
        n50 = uf("H", data, k + 4)
        n320 = uf("H", data, k + 6)
        n200 = uf("H", data, k + 8)
        n0 = uf("H", data, k + 10)
        score = uf("i", data, k + 12)
        combo = uf("H", data, k + 16)
        perf = uf("?", data, k + 18)
        mods = uf("i", data, k + 19)
        k += 23
        k = us(data, k)[1] # life bar skip
        times = uf("q", data, k)
        print(hex(times))
        time = datetime.min + timedelta(microseconds=times/10)
        time = time.replace(tzinfo=timezone.utc)
        k += 8
        return (k, score, combo, n320, n300, n200, n100, n50, n0, mods, perf, usr, time, bmhash, rphash)
def srd(path):
    # take k from frd
    k = frd(path)[0]
    with open(path, "rb") as f:
        data = f.read()
        (arrdelta, arrx, rng, newk) = upd(data, k)
        k = newk
        rid = uri(data, k)
        return (arrdelta, arrx, rng, rid)

# r = Replay.from_path(pathg)
kk = srd(pathf)
print(kk[0])