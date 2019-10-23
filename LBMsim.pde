final int ROWS = 80;
final int COLS = 80;
final int SCALE = 10;
final float OMEGA = 0.05; //1 / (3 * 0.005 + 0.5);

final int INIT_EAST = 100;

final int[] X_OFFSETS = new int[] { 0, 1, 0, -1, 0, 1, -1, -1, 1 };
final int[] Y_OFFSETS = new int[] { 0, 0, 1, 0, -1, 1, 1, -1, -1 };

final float W_CENTER = 4.0 / 9;
final float W_CARDINALS = 1.0 / 9;
final float W_DIAGONALS = 1.0 / 36;

long NUM_STEP = 0;

final float[] W_LIST = new float[] {
    W_CENTER,
    W_CARDINALS,
    W_CARDINALS,
    W_CARDINALS,
    W_CARDINALS,
    W_DIAGONALS,
    W_DIAGONALS,
    W_DIAGONALS,
    W_DIAGONALS
};

Lattice lattice;

long NUM_ERRORS = 0;

static class Direction {
    public static int CENTER = 0;
    public static int EAST = 1;
    public static int NORTH = 2;
    public static int WEST = 3;
    public static int SOUTH = 4;
    public static int NORTHEAST = 5;
    public static int NORTHWEST = 6;
    public static int SOUTHWEST = 7;
    public static int SOUTHEAST = 8;

    public static int opposite(int given) {
        switch(given) {
            case 0: return 0;
            case 1: return 3;
            case 2: return 4;
            case 3: return 1;
            case 4: return 2;
            case 5: return 7;
            case 6: return 8;
            case 7: return 5;
            case 8: return 6;
            default: return 0;
        }
    }
}

public class Cell {
    // One velocity for each direction (9 for 2 dimensions)
    public float[] densities;
    //public float[] microVels;

    public float speed;

    public Cell() {
        // --- Initialize probabilities based on Boltzmann distribution:
        // this.microVels = new float[9];
        // arrayCopy(W_LIST, this.microVels, 9);

        this.densities = new float[9];

        for (int i = 0; i < 9; i++) {
            this.densities[i] = 0.0;
        }
    }

    // Total density of the cell is the sum of the number densities
    public float getDensity() {
        float sum = 0.0;

        for (float d : densities) {
            sum += d;
        }

        return sum;
    }

    public PVector getMacroVelocity() {
        PVector result = new PVector(0, 0);

        for (int i = 0; i < 9; i++) {
            result.add(new PVector(X_OFFSETS[i], Y_OFFSETS[i]).mult(densities[i] * 2));
        }

        return result;

        // float d = getDensity();
        // float x = (densities[1] + densities[5] + densities[8] - densities[3] - densities[6] - densities[7]) * d;
        // float y = (densities[2] + densities[5] + densities[6] - densities[4] - densities[7] - densities[8]) * d;

        // return new PVector(x, y);
    }

    // Equation 8
    public float[] getEqDensities(float density, PVector macroVel) {
        float[] equilibriumDen = new float[9];
        PVector[] directionVectors = getDirectionVectors();
        float velocity = getMacroVelocity().mag();
        for (int i = 0; i < 9; i++) {
            equilibriumDen[i] = getDensity() * W_LIST[i] *
                                (1.0 + directionVectors[i].mag() * 3.0 * velocity
                                + 9.0 * (float) Math.pow(directionVectors[i].mag() * velocity, 2)/2.0
                                - 3.0 * (float) Math.pow(velocity, 2))/2.0;
        }

        return equilibriumDen;
    }

    public PVector[] getDirectionVectors(){
        PVector[] ret = new PVector[9];
        for(int i=0; i<9; i++) {
            ret[i] = new PVector(X_OFFSETS[i], Y_OFFSETS[i]);
        }
        return ret;
    }

    // Equation 9
    public float[] getScaledEqDensities(float[] eqDensities, float omega) {
        float[] result = new float[9];

        for (int i = 0; i < 9; i++) {
            result[i] = densities[i] + omega * (eqDensities[i] - densities[i]);
        }

        return result;
    }
}

class Lattice {
    public Cell[][] cells;
    public int rows;
    public int cols;

    public float omega;

    public boolean[][] obstacles;

    public Lattice(int rows, int cols, float omega, boolean[][] obstacles) {
        this.rows = rows;
        this.cols = cols;
        this.omega = omega;
        this.obstacles = obstacles;

        this.cells = new Cell[rows][cols];

        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < this.cols; j++) {
                cells[i][j] = new Cell();
            }
        }
    }

    public PVector[][] getMacroVelocities() {
        PVector[][] result = new PVector[rows][cols];

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                result[i][j] = cells[i][j].getMacroVelocity();
            }
        }

        return result;
    }

    public float[][] getDensities() {
        float[][] result = new float[rows][cols];
        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < this.cols; j++) {
                result[i][j] = cells[i][j].getDensity();
            }
        }
        return result;
    }

    public void doCollisions() {
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                // Calculate required macro-values
                float macroDensity = cells[i][j].getDensity();
                PVector macroVelocity = cells[i][j].getMacroVelocity();

                // Use equation 8 to calculate equilibrium densities
                float[] eqDensities = cells[i][j].getEqDensities(macroDensity, macroVelocity);

                // Use equation 9 to scale the eq densities
                float[] scaledEqDensities = cells[i][j].getScaledEqDensities(eqDensities, omega);

                for (int x = 0; x < 9; x++) {
                    cells[i][j].densities[x] = scaledEqDensities[x];
                }
            }
        }
    }

    public void doStreaming() {
        Cell[][] result = new Cell[rows][cols];

        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < this.cols; j++) {
                result[i][j] = new Cell();
            }
        }

        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                if (obstacles[i][j] == true) {
                    // Do nothing.
                    continue;
                }

                for (int dir = 0; dir < 9; dir++) { // For each direction
                    if (dir == Direction.CENTER) {
                        continue;
                    }

                    if (valid(i + X_OFFSETS[dir], j + Y_OFFSETS[dir])) {
                        result[i + X_OFFSETS[dir]][j + Y_OFFSETS[dir]].densities[dir] = cells[i][j].densities[dir];
                    } else {
                        result[i][j].densities[Direction.opposite(dir)] = result[i][j].densities[dir];
                    }
                }
            }
        }

        for (int i = 0; i < this.rows; i++) {
            for (int j = 0; j < this.cols; j++) {
                cells[i][j] = result[i][j];
            }
        }
    }

    private boolean valid(int i, int j) {
        if (i >= rows || i < 0) {
            return false;
        }

        if (j >= cols || j < 0) {
            return false;
        }

        if (obstacles[i][j] == true) {
            return false;
        }

        return true;
    }
}

void setup() {
    frameRate(5);

    boolean[][] obstacles = new boolean[ROWS][COLS];

    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            obstacles[i][j] = false;

            // Wind tunnel pattern -- top and bottom rows are obstacles.
            if (i == 0 || i == ROWS - 1) {
                obstacles[i][j] = true;
            }
        }
    }

    // 1/3 of the tunnel vertical obstacle

    // for (int i = 10; i < 20; i++) {
    //     int center = (i / 2) + 10;

    //     for (int j = center; j < center + (i - 9); j++) {
    //         obstacles[i + 10][j] = true;
    //     }
    // }

    for (int i = 20; i < 30; i++) {
        for (int j = 35; j < 36; j++) {
            obstacles[i][j] = true;
        }
    }

    lattice = new Lattice(ROWS, COLS, OMEGA, obstacles);

    for (int x = 0; x < ROWS; x++) {
        for (int y = 0; y < COLS; y++) {
            for (int i = 0; i < 9; i++) {
                lattice.cells[x][y].densities[i] = 1; //random(0, INIT_EAST / 20.0);
            }
        }
    }

    stroke(255, 255, 255);
}

void draw() {
    tickSimulation();
}

void keyPressed() {
    //tickSimulation();
}

void settings() {
    size(ROWS * SCALE, COLS * SCALE);
}

void tickSimulation() {
    for (int i = 0; i < ROWS; i++) {
        lattice.cells[i][0].densities[Direction.EAST] = 10; //INIT_EAST;
        lattice.cells[i][0].densities[Direction.NORTHEAST] = 0; //INIT_EAST * (9.0 / 36.0);
        lattice.cells[i][0].densities[Direction.SOUTHEAST] = 0; //INIT_EAST * (9.0 / 36.0);
        
        lattice.cells[i][COLS-1].densities[Direction.WEST] = 0;
        lattice.cells[i][COLS-1].densities[Direction.NORTHWEST] = 0;
        lattice.cells[i][COLS-1].densities[Direction.SOUTHWEST] = 0;
        
        // lattice.cells[0][i].densities[Direction.SOUTH] = 2;
        // lattice.cells[COLS - 1][i].densities[Direction.EAST] = 0;
        // lattice.cells[COLS - 1][i].densities[Direction.NORTHEAST] = 0;
        // lattice.cells[COLS - 1][i].densities[Direction.SOUTHEAST] = 0;
    }

    NUM_STEP += 1;
    //if (NUM_STEP > 5) {
    //    noLoop();
    //}

    // System.out.println("\n\n\n================== Step number: " + NUM_STEP);

    lattice.doCollisions();
    lattice.doStreaming();

    PVector[][] velocities = lattice.getMacroVelocities();
    float[][] densities = lattice.getDensities();

    background(0);

    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            if (lattice.obstacles[i][j] == true) {
                fill(0, 0, 0);  // black
            } else {
                int densityMapped = (int) map(densities[i][j], 0, INIT_EAST, 10, 230);
                fill(densityMapped, 50, 255 - map(densities[i][j], 0, INIT_EAST, 10, 230));
            }

            noStroke();
            rect(j * SCALE, i * SCALE, SCALE, SCALE);

            float startX = j * SCALE + SCALE/2;
            float startY = i * SCALE + SCALE/2;

            stroke(255,255,255);
            line(startX, startY, startX + velocities[i][j].x * 100, startY + velocities[i][j].y * 100);

            // System.out.println("  East Densities: " + lattice.cells[i][j].densities[Direction.EAST]);
            // System.out.println("  Equilibrium Densities: " + lattice.cells[i][j].getEqDensities(densities[i][j], velocities[i][j])[Direction.EAST]);
            // System.out.println("  Velocity: (" + velocities[i][j].x + ", " + velocities[i][j].y + ")");
        }
    }
}