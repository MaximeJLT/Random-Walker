# 2D Brownian Motion — Statistical Study via Random Walks

## Overview
This project simulates 2D Brownian motion using a discrete random walk model, where each walker (e.g., a particle or atom) moves randomly on a two-dimensional lattice. The goal is to analyze the statistical properties of this motion, focusing on the mean square displacement (MSD) and estimating the diffusion coefficient $$D$$.

Two approaches are used:
1. **Multi-simulation approach:** Estimating $$D$$ by averaging over a large number of independent simulations.
2. **Single long trajectory approach:** Estimating $$D$$ from the time-averaged MSD of a single particle over a large number of steps.

## Theoretical Background
Brownian motion refers to the erratic motion of particles suspended in a fluid, caused by collisions with the fluid's molecules. In 1905, Einstein related this stochastic process to thermal agitation and introduced the diffusion equation to describe it. 

In 2D, Brownian motion can be modeled as a discrete-time random walk:
- At each time step, the walker moves with equal probability in one of four directions.
- The total displacement after $$T$$ steps is given by: 

  
  $$D(T) = \sqrt{X_T^2 + Y_T^2}$$
  

The theoretical mean square displacement (MSD) is:

$$
\langle D^2(T) \rangle = 2dDT
$$

where $$d = 2$$ is the spatial dimension and $$D$$ is the diffusion coefficient. Since the directions are symmetric, the expected first-order displacement is zero.

---

## Simulation 1: MSD over Many Walkers
We estimate $$D$$ by averaging the square displacement over multiple walkers for a fixed number of time steps $$T$$.

### Parameters
```matlab
N = 5000;  % Number of simulations
T = 3000;  % Number of steps per simulation
d = 2;     % Dimensions
```
Each walker's position is computed iteratively. Directions are randomly assigned using:
```matlab
directions = randi(4, T, N);
```
Each integer (1–4) maps to a move in ±X or ±Y. The script updates each walker's coordinates accordingly.

### Example Trajectories
![Example trajectories](figures/trajectoires_walkers_1_to_4.png)

---

## Diffusion Coefficient Estimation
We vary $$T$$ from 500 to 2500 and compute:

$$
\text{MSD}(T) = \left\langle D^2(T) \right\rangle = \left\langle X_T^2 + Y_T^2 \right\rangle
$$

By fitting the MSD as a function of $$T$$, the slope yields:

$$
D = \frac{\text{slope}}{2d}
$$

### Results: Diffusion vs. Number of Simulations $$N$$
- $$N = 10$$ → $$D \approx 1.1094$$ (low accuracy)
- $$N = 100$$ → $$D \approx 0.2388$$
- $$N = 1000$$ → $$D \approx 0.2407$$
- $$N = 3000$$ → $$D \approx 0.2538$$

#### MSD Curves and Histograms
- ![MSD N=10](figures/MSD_vs_T_N10.png)
- ![MSD N=100](figures/MSD_vs_T_N100.png)
- ![MSD N=1000](figures/MSD_vs_T_N1000.png)
- ![MSD N=3000](figures/MSD_vs_T_N3000.png)

- ![Histogram N=10](figures/hist_final_distance_N10.png)
- ![Histogram N=100](figures/hist_final_distance_N100.png)
- ![Histogram N=1000](figures/hist_final_distance_N1000.png)
- ![Histogram N=3000](figures/hist_final_distance_N3000.png)

As $$N$$ increases, results stabilize around the theoretical value $$D = 0.25$$. The histogram of final distances converges to a **Rayleigh distribution**, expected when both $$X$$ and $$Y$$ are normally distributed.

### Statistical Convergence
To quantify convergence, we plot $$D(N)$$ versus $$N$$:

![Diffusion vs N](figures/diffusion_vs_N.png)

Stabilization occurs around $$N \approx 2000$$.

---

## Simulation 2: MSD of a Single Long Trajectory
For a single walker over many steps, the MSD is computed using the lag-time average:

$$
\langle D^2(\tau) \rangle = \langle [X(t+\tau) - X(t)]^2 + [Y(t+\tau) - Y(t)]^2 \rangle_t
$$

This time-averaged MSD is computed for $$\tau = 1, 2, \ldots, T-1$$.

### Example Trajectory
![Single long trajectory](figures/trajectory_long_single_walker.png)

### MSD vs Lag Time
![MSD vs lag time](figures/MSD_vs_tau_single_walker.png)

In the linear regime, a fit provides the diffusion coefficient.

### Result Table
| Trial | Diffusion Coefficient $$D$$ |
|-------|-----------------------------|
| 1     | 0.2205                      |
| 2     | 0.2509                      |
| 3     | 0.2542                      |
| 4     | 0.2427                      |
| 5     | 0.2594                      |

Values are statistically close to the expected $$D = 0.25$$.

---

## Constrained Walks
We introduce a constraint: the walker cannot move in the same direction twice in a row. This alters the direction selection logic. The result is a reduced diffusion coefficient:

- $$D \approx 0.125$$ (half of unconstrained case)

### Constraint Check
Each step is verified to ensure the constraint is respected. If not, the script throws an error.

### Comparison Plot
![Constrained vs Unconstrained Diffusion](figures/constrained_vs_unconstrained_diffusion.png)
![Example Constrained Path](figures/example_constrained_path.png)

---

## Conclusion
This project demonstrates two core stochastic methods for estimating diffusion in 2D:
- **Ensemble averaging** over many independent walkers.
- **Time-averaging** over a long individual trajectory.

Both approaches recover the theoretical diffusion coefficient $$D \approx 0.25$$ under unconstrained dynamics, validating the method.

### Why This Matters
Stochastic simulations like these are crucial tools in various fields:
- **Finance**: Brownian motion is the core model behind stock price evolution and options pricing (Black-Scholes model).
- **New Space**: In satellite systems, noise in signal propagation, sensor drift, and radiation effects can be modeled using constrained or unconstrained random walks.

The techniques demonstrated here, based on probabilistic reasoning and statistical convergence, form the backbone of modern risk modeling, predictive analytics, and noise analysis in both finance and aerospace engineering.
