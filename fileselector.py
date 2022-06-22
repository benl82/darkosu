from osrin import Replay, parse_replay_data
import pandas as pd

x = Replay.from_select()

'''
These are my own functions for replay analysis
'''

def rdtodf(rd):
    # replay data to data frame
    for i in rd:
        print(i[0])
        print(i[1])

rdtodf(x.replay_data)