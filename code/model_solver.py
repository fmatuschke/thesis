import fastpli.model.solver
import fastpli.model.sandbox
import fastpli.io

import numpy as np

### create fiber_bundle(s) ###
fiber_bundle_trj = []
for phi in range(0, 91, 5):
    fiber_bundle_trj.append(
        [200 * np.sin(np.deg2rad(phi)),
         200 * np.cos(np.deg2rad(phi)), 0, 1])
fiber_bundle_trj = np.array(fiber_bundle_trj)

population = fastpli.model.sandbox.fill.circle(20, 5)

fiber_radii = np.random.uniform(2.0, 5.0, population.shape[0])
fiber_bundle = fastpli.model.sandbox.fill.bundle(fiber_bundle_trj,
                                                 population,
                                                 fiber_radii)

### setup solver ###
solver = fastpli.model.solver.Solver()
solver.fiber_bundles = [fiber_bundle]
solver.drag = 0
solver.obj_min_radius = 0
solver.obj_mean_length = 15
solver.omp_num_threads = 1

fastpli.io.fiber.save('fiber_model.init.dat', solver.fiber_bundles)

### run solver ###
solver.draw_scene()
for i in range(1000):
    solved = solver.step()
    print("step:", i, solver.num_obj, solver.num_col_obj)
    solver.draw_scene()

    if solved:
        break

fastpli.io.fiber.save('fiber_model.solved.dat',
                      solver.fiber_bundles)
