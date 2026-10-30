---
title: "Kinematic Drivers of Hitting Performance: Sequencing, Plane, and Power"
format: html
editor: visual
author: "Taylor Lum"
---

## 1. Project Overview

This project evaluates the biomechanical efficiency of four swings against incoming pitches using motion-capture time-series data. The analysis investigates how kinematic chain sequencing and attack angle matching can relate to bat speed and collision efficiency (exit velocity).

## 2. Project Structure & Main Files

```         
├── data/
│ ├── batter1.csv 
│ ├── batter2.csv 
│ ├── batter3.csv 
│ ├── batter4.csv 
│ └── batter5.csv 
├── 1_data_processing.R 
├── 2_swing_performance.R  
├── 3_kinematic_sequence_visualization.R
├── outputs/ 
│ ├── batter1_sequence.png 
│ ├── batter2_sequence.png 
│ ├── batter4_sequence.png 
│ └── batter5_sequence.png  
│ ├── performance_summary.csv 
└── README.qmd 
```

## 3. Required Software and R Packages

### Software Requirements

- R

- RStudio

### Required R Packages

- readr

- dplyr

- signal

- ggplot2

- tidyr

All necessary packages can be installed by running the following command in your R console:

```         
install.packages(c("readr", "dplyr", "signal", "ggplot2", "tidyr"))
```

## 4. Execution & Reproduction

To reproduce this analysis, execute the scripts in this project in the following order:

### 1_data_processing.R

- Load CSV files in from the `data` folder
- Apply a 4th order low-pass Butterworth filter to smooth the high frequency noise

### 2_swing_performance.R

- Detects contact time for contact swings, or defaults to the last available approach angle for missed swings

- Extracts peak angular velocity magnitudes for the pelvis, torso, and lead hand

- Calculates timing lags (pelvis ➔ torso, pelvis ➔ lead hand) in milliseconds

- Calculates deltas for vertical attack and approach planes at contact

- Extracts peak bat speed and initial exit speed in miles per hour

- Exports consolidated results to `outputs/performance_summary.csv`

### 3_kinematic_sequence_visualization.R

- Generates segmented kinematic sequence angular velocity vs. time curves with contact markers to visualize segment lags

- Exports the visualizations to the `outputs` folder

### 
