import numpy as np

import fastpli.model

solver = fastpli.model.Solver()

'''
a: input
b: output
'''
for i in range(N):
    # run solver i times
	solver.run(i)