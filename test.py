# Testing integrating R with python

import rpy2
from rpy2.robjects.packages import importr
base = importr('base')
import rpy2.robjects.packages as rpackages
utils = rpackages.importr('utils')
utils.chooseCRANmirror(ind=1)
packnames = ('tidyverse', 'leaps')
from rpy2.robjects.vectors import StrVector
names_to_install = [x for x in packnames if not rpackages.isinstalled(x)]
if len(names_to_install) > 0:
    utils.install_packages(StrVector(names_to_install))
import rpy2.robjects as robjects
rx = robjects.r
rx.source('speedgen.R')

def test():
    # print(rx('jackdensity')(rx('rpt')))
    print("hi from the python console")

test()