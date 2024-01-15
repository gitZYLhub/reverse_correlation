import numpy as np
import scipy.io as io

loaddata = np.load('all_amplitude.npy', allow_pickle=True)
a = loaddata.array
# a = loaddata['imageindex_0']
