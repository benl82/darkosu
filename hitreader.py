from osuin import Map
import osrin2 as osr
from osrin import Replay, parse_replay_data
import pandas as pd
import math

x = Map.from_select()
replay = Replay.from_select()

mapdf = x.hitdf
playdf = osr.adog(replay.replay_data)

# gonna transform the replay df since this is actual trash
pldf = pd.DataFrame(columns = ["col", "start", "end"])
c1a = False; c2a = False; c3a = False; c4a = False;
c1s = 0; c2s = 0; c3s = 0; c4s = 0;
for index, row in playdf.iterrows():
    if not c1a and row['c1'] == 3:
        c1a = True
        c1s = row['time_total']
    if not c2a and row['c2'] == 3:
        c2a = True
        c2s = row['time_total']
    if not c3a and row['c3'] == 3:
        c3a = True
        c3s = row['time_total']
    if not c4a and row['c4'] == 3:
        c4a = True
        c4s = row['time_total']
    if c1a and row['c1'] == 1:
        c1a = False
        pldf.loc[len(pldf.index)] = [1, c1s, row['time_total']]
    if c2a and row['c2'] == 1:
        c2a = False
        pldf.loc[len(pldf.index)] = [2, c2s, row['time_total']]
    if c3a and row['c3'] == 1:
        c3a = False
        pldf.loc[len(pldf.index)] = [3, c3s, row['time_total']]
    if c4a and row['c4'] == 1:
        c4a = False
        pldf.loc[len(pldf.index)] = [4, c4s, row['time_total']]

def combobonus(ModMultiplier, TotalNotes, HitBonusValue, Bonus):
    return (1000000 * ModMultiplier * 0.5 * HitBonusValue * math.sqrt(Bonus)) / (TotalNotes * 320)

def basescore(ModMultiplier, TotalNotes, HitValue):
    return (1000000 *  ModMultiplier * 0.5 * HitValue) / (TotalNotes * 320)

# Two pointers implementation
def scorev1(mapdf, pldf, od, mod = 0, hr = 0, fl = 0):
    # some OD magic; mod = 0 for nomod, -1 for ht, +1 for dt; hr = 0 for nomod, -1 for ez, +1 for hr; fl = 0 for nomod, +1 if fadein, hidden, or flashlight are active
    judge = [[0 for x in range(5)] for y in range(6)]
    # judge[0][x] for timing window, judge[1][x] for score, judge[2][x] for hitbonusvalue, judge[3][x] for hitbonus, judge[4][x] for hitpunishment
    judge[0][0] = 16.5; judge[0][1] = 64 - (3 * od); judge[0][2] = 97 - (3 * od); judge[0][3] = 127 - (3 * od); judge[0][4] = 151 - (3 * od); judge[0][5] = 188 - (3 * od);
    judge[1][0] = 320; judge[1][1] = 300; judge[1][2] = 200; judge[1][3] = 100; judge[1][4] = 50; judge[1][5] = 0;
    judge[2][0] = 32; judge[2][1] = 16; judge[2][2] = 16; judge[2][3] = 8; judge[2][4] = 4;
    judge[3][0] = 2; judge[3][1] = 1;
    judge[4][2] = 8; judge[4][3] = 24; judge[4][4] = 44; judge[4][5] = 100;
    if hr < 0:
        for z in range(6):
            judge[0][z] = math.floor(judge[0][z] * 1.4)
    elif hr > 0:
        for z in range(6):
            judge[0][z] = math.floor(judge[0][z] / 1.4)
    ModMultiplier = 1; ModDivider = 1;
    if mod < 0 or hr < 0:
        ModMultiplier = 0.5
    if mod > 0:
        ModDivider = 1.08
    if hr > 0:
        ModDivider = 1.1
    if fl > 0:
        ModDivider = 1.06
    TotalNotes = len(mapdf.index)
    Bonus = 100

    pldf = pldf.sort_values(by=['col','start']).reset_index()
    mapdf = mapdf.sort_values(by=['col','start']).reset_index() # we go by col then start, then it's easier

    for index, row in pldf.iterrows():
        # we check each hit for the closest note according to the osu engine
        for i in range(math.ceil(row['start'] - judge[0][5]), math.floor(row['start'] + judge[0][5])): # by tick
            pass
    pass