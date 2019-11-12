"""
Uses some code adapted from:

    A concise Python implementation of the Lattice
    Boltzmann Method on HPC for geo-fluid flow

    by Peter Mora, Gabriele Morra, David A. Yuen
"""

import numpy as np


class LBMsolver:      
    def tick_time(self):
        pass

    def run_simulation(self):
        pass



# Pointers to opposite directions
ai = np.array([0, 2, 1, 4, 3, 6, 5, 8, 7])


class PythonBackend(LBMsolver):

    def run_simulation(self):
        for x in range(self.nt):
            self.tick_time()
            yield self.rho, self.solid, self.solid_op


    def __init__(self, nu_f=0.1, nt=100, nx=201, nz=101):
        """
        Constructor, initializes the simulation.
        """

        # c[] is the lattice velicities
        self.c = np.array([[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1],
                           [1, 1], [-1, -1], [1, -1], [-1, 1]])  # Right to left

        self.na = 9  # Number of lattice velocities
        self.D = 2  # Dimension of the simulation

        self.w0 = 4.0 / 9.0
        self.w1 = 1.0 / 9.0
        self.w2 = 1.0 / 36.0
        self.w = np.array([self.w0, self.w1, self.w1, self.w1, self.w1,
                           self.w2, self.w2, self.w2, self.w2])

        # Physical auantities associated with relaxation time
        self.dt = 1
        self.dx = 1
        self.S = self.dx/self.dt
        self.c1 = 1.0
        self.c2 = 3.0/(self.S**2)
        self.c3 = 9.0/(2.0*self.S**4)
        self.c4 = -3.0/(2.0*self.S**2)

        # Initialize the relaxation time
        self.nu_f = nu_f  # Viscosity
        self.tau_f = self.nu_f * 3./(self.S*self.dt) + 0.5

        self.nt = nt  # Number of time steps
        self.nx = nx  # X-axis size
        self.nz = nz  # Z-axis size

        # Initialize arrays
        self.f = np.zeros((self.na, nz, nx), dtype=float)
        self.f_stream = np.zeros((self.na, nz, nx), dtype=float)
        self.f_eq = np.zeros((self.na, nz, nx), dtype=float)
        self.Delta_f = np.zeros((self.na, nz, nx), dtype=float)
        self.rho = np.ones((nz, nx), dtype=float)   # Density array
        self.u = np.zeros((self.D, nz, nx), dtype=float)
        self.Pi = np.zeros((self.D, nz, nx), dtype=float)
        self.u2 = np.zeros((nz, nx), dtype=float)
        self.cu = np.zeros((nz, nx), dtype=float)

        # Obstacles
        # self.solid = np.full((self.na, nz, nx), False, dtype=bool)
        self.solid = [[0] * nx] * nz
        self.solid_op = [0] * (nx * nz)

        # for i in range(0,10):
        #     for j in range(95, 105):
        #         self.solid[i][j] = 1
        #         #self.solid_op[nz * i + j] = 1

        # Initialize the density
        self.rho_0 = 1.0  # density
        self.rho *= self.rho_0
        self.rho[nz//2, 3*nx//4] = 2 * self.rho_0
        self.rho[nz//3, 3*nx//8] = 2.5 * self.rho_0

        # Assume that there are no obstacles. Density is in rho and the initial
        # speed u is zero, f depends on density only, with appropriate weights.
        for a in np.arange(self.na):
            self.f[a] = self.rho * self.w[a]

        # Runs vectorized simulation to speed up calculations
        self.indexes = np.zeros((self.na, nx*nz), dtype=int)

        for a in range(self.na):
            xArr = (np.arange(nx) - self.c[a][0] + nx) % nx
            zArr = (np.arange(nz) - self.c[a][1] + nz) % nz
            xInd, zInd = np.meshgrid(xArr, zArr)
            indTotal = zInd*nx + xInd
            self.indexes[a] = indTotal.reshape(nx*nz)

    
    def streaming_unop(self): 
        # === Unoptimized Streaming step ===
        for a in range(self.na):
            for x in range(1, self.nx-1):
                x_xa = (x - self.c[a][0] + self.nx) % self.nx
                for z in range(self.nz):
                    z_za = (z - self.c[a][1] + self.nz) % self.nz
                    if self.solid[z_za][x_xa]:
                        self.f_stream[a][z][x] = self.f[ai[a]][z][x]  # Bounce-back BC
                    else:
                        self.f_stream[a][z][x] = self.f[a][z_za][x_xa]  # Streaming step


    def streaming_op(self):
        # === Optimized Streaming Step ===
        for a in np.arange(self.na):
            f_new = self.f[a].reshape(self.nx*self.nz)[self.indexes[a]]
            f_bounce = self.f[ai[a]] # bounce back
            self.f_stream[a] = self.solid_op[a]*f_bounce + (1-self.solid_op[a])*f_new.reshape(self.nz, self.nx)


    def tick_time(self):
        # Time loop
        for t in np.arange(self.nt+1):
            # (1) periodic boundary conditions
            self.f[0:self.na, 0:self.nz, 0] = self.f[0:self.na, 0:self.nz, -2]
            self.f[0:self.na, 0:self.nz, -1] = self.f[0:self.na, 0:self.nz, 1]

        # (2) calculate the streaming term for f
        for a in np.arange(self.na):
            f_new = self.f[a].reshape(self.nx*self.nz)[self.indexes[a]]
            self.f_stream[a] = f_new.reshape(self.nz, self.nx)
        self.f = self.f_stream.copy()

        # (3) macroscopic properties: new density rho and velocity term u
        self.rho = np.sum(self.f, axis=0)
        self.Pi = np.einsum('azx,ad->dzx', self.f, self.c)
        self.u[0:self.D] = self.Pi[0:self.D]/self.rho

        # (4) Equilibrium distribution
        u2 = self.u[0]*self.u[0]+self.u[1]*self.u[1]
        for a in np.arange(self.na):
            self.cu = self.c[a][0] * self.u[0] + self.c[a][1] * self.u[1]
            self.f_eq[a] = self.rho * self.w[a] * \
                (self.c1 + self.c2 * self.cu + self.c3 * self.cu**2 + self.c4*u2)

        # (5) Collision term
        self.Delta_f = (self.f_eq - self.f)/self.tau_f
        self.f += self.Delta_f

        self.streaming_unop()


    


        