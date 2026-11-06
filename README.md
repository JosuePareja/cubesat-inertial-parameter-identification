# CubeSat Inertial Parameter Identification — MATLAB Project

This repository contains the MATLAB implementation of the two-stage inertial-parameter identification method developed for a 3-DOF spherical air-bearing spacecraft simulator with moving masses and reaction wheels.

The code reproduces the numerical identification procedure used in the associated research article and includes validation cases based on InnoCube, TPA-1, SOURCE, and M3Sat mass-property distributions.

## How to reproduce the article results

To reproduce the numerical results, figures, and tables used in the article, place all `.m` files in the same MATLAB working directory and run:

```matlab
generate_final_article_results
```

This is the **main entry point of the project**.

The script automatically:

1. loads the air-bearing platform and actuator parameters;
2. runs the complete BASE identification campaign;
3. runs the BASE+CubeSat campaign for InnoCube, TPA-1, SOURCE, and M3Sat;
4. performs the differential extraction of the CubeSat mass properties;
5. generates the four main result figures;
6. exports the numerical result tables in CSV and LaTeX format;
7. creates the LaTeX result macros used by the manuscript; and
8. saves the complete MATLAB results for later analysis.

The generated files are stored in:

```text
article_results/
```

Typical outputs include:

```text
fig_results_01_campaigns.png
fig_results_02_vertical_compensation.png
fig_results_03_second_excitation.png
fig_results_04_innocube_final.png

table_innocube_final.csv
table_innocube_final.tex

table_friction.csv
table_friction.tex

table_multicubesat.csv
table_multicubesat.tex

results_macros.tex
complete_results.mat
```

## MATLAB files

| File | Purpose |
|---|---|
| `generate_final_article_results.m` | Main script for reproducing the numerical results reported in the article. It runs one BASE campaign and four BASE+CubeSat campaigns (InnoCube, TPA-1, SOURCE, and M3Sat), generates the article figures, exports the result tables, creates LaTeX macros, and saves the complete simulation results. |
| `run_identification_campaign.m` | Runs the complete two-stage identification campaign for a given platform configuration. It performs the initial balancing, first excitation, 10-parameter estimation, X/Y rebalancing, Z center-of-mass compensation, second excitation, and final inertia/friction estimation. |
| `platform_parameters.m` | Defines the physical parameters of the air-bearing platform, including gravity, viscous friction, reaction-wheel rotor inertia, platform mass, center-of-mass location, inertia tensor, moving masses, and their nominal positions. |
| `actuator_torque_parameters.m` | Defines control, actuator, excitation, timing, noise, filtering, and simulation parameters used by the identification sequence. |
| `cubesat_parameters.m` | Stores the reference mass properties used for the CubeSat validation cases (InnoCube, TPA-1, SOURCE, and M3Sat). |
| `add_cubesat_to_platform.m` | Combines the base air-bearing platform with a selected CubeSat model and computes the resulting total mass properties referred to the platform rotation center. |
| `extract_cubesat_parameters.m` | Recovers the estimated CubeSat mass properties by subtracting the BASE campaign estimates from the corresponding BASE+CubeSat estimates and performs the required reference-point transformations. |
| `simulate_platform.m` | Simulates one stage of the experiment using ode45 and reconstructs the state, attitude, gravity, moving-mass motion, reaction-wheel momentum, excitation torques, and noisy sensor signals. |
| `platform_dynamics_ode.m` | Implements the nonlinear rotational dynamics of the air-bearing platform, including time-varying inertia, moving-mass relative angular momentum, reaction-wheel angular momentum, gravity torque, and viscous friction. |
| `estimate_platform_parameters.m` | Performs the first-stage identification of the platform parameters using the first excitation dataset. It estimates the inertia tensor, first mass moment, center of mass, and viscous friction coefficient for ideal and noisy data. |
| `estimate_inertia_parameters.m` | Performs the second-stage identification after rebalancing and Z compensation. It estimates the final inertia tensor and viscous friction coefficient while accounting for the time-varying inertia and moving-mass dynamics. |
| `base_cubesat_experiment.m` | Runs the BASE and BASE+CubeSat identification sequence and computes the CubeSat parameters for a selected validation case. This is useful for testing an individual spacecraft case outside the full article-results workflow. |
| `base_cubesat_experiment_report.m` | Runs a BASE / BASE+CubeSat experiment and generates additional diagnostic figures, tables, and report-oriented outputs for detailed analysis of the identification campaign. |
| `platform_balancing_test.m` | Standalone test used to evaluate the platform balancing and moving-mass control behavior before running the complete identification campaign. |

## Recommended execution order

For normal use, you only need to execute:

```matlab
generate_final_article_results
```

The remaining files are called automatically by the main script.

A simplified dependency flow is:

```text
generate_final_article_results.m
        |
        +--> platform_parameters.m
        +--> actuator_torque_parameters.m
        |
        +--> run_identification_campaign.m
        |       |
        |       +--> simulate_platform.m
        |       |       |
        |       |       +--> platform_dynamics_ode.m
        |       |
        |       +--> estimate_platform_parameters.m
        |       +--> estimate_inertia_parameters.m
        |
        +--> cubesat_parameters.m
        +--> add_cubesat_to_platform.m
        +--> extract_cubesat_parameters.m
```

The files `base_cubesat_experiment.m`, `base_cubesat_experiment_report.m`, and `platform_balancing_test.m` are auxiliary scripts intended for individual tests and detailed diagnostics. They are **not required** to reproduce the main article results.

## Simulation and identification sequence

Each complete identification campaign follows the same general sequence:

```text
Initial X/Y balancing
        ↓
First excitation
        ↓
10-parameter estimation
        ↓
X/Y rebalancing
        ↓
Z center-of-mass compensation
        ↓
Second excitation
        ↓
Final inertia and friction estimation
```

The BASE campaign is first executed for the air-bearing platform alone. The same identification sequence is then repeated after adding each CubeSat model. The CubeSat parameters are obtained from the difference between the BASE+CubeSat and BASE estimates.

## Requirements

The project is written in MATLAB and uses `ode45` for numerical integration.

All source files should remain accessible from the same MATLAB path. The simplest option is to keep all `.m` files in the same folder and set that folder as the current MATLAB working directory before running the main script.

## Reproducibility

The main results script uses fixed random seeds for the noisy simulations so that the reported numerical results can be reproduced consistently.

The validation cases include third-party spacecraft mass-property parameters. Their public redistribution should follow the permissions granted by the corresponding spacecraft teams.

## Citation

If you use this code in academic work, please cite the associated article once its final bibliographic information is available.
