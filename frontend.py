"""
Defines a frontend that displays a fluid simulation in an animated
window, plotting rho[x][y].
"""


import matplotlib.pyplot as plt
import numpy as np

from backend import LBMsolver, PythonBackend


if __name__ == "__main__":
    # Constants
    time_steps : int = 50
    nu_f = 0.1
    nx = 101
    nz = 51

    # Plot
    plt.axis([0, nx, 0, nz])
    plt.ion()
    plt.show()

    solver : LBMsolver = PythonBackend(nt = time_steps,
                                       nu_f = nu_f,
                                       nx = nx,
                                       nz = nz)

    rho_steps = solver.run_simulation()

    for rho, solid, solid_op in rho_steps:
        rho_obs = np.copy(rho)

        for i in range(len(solid)):
            for j in range(len(solid[0])):
                if solid[i][j] or solid_op[nz * i + j]:
                    rho_obs[i][j] = 1.001
        
        plt.clf() # Clear figure
        plt.imshow(rho_obs, cmap='viridis')
        plt.colorbar()
        plt.draw()
        plt.pause(0.0001)

    pass

