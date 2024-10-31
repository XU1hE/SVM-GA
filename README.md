# SVM-GA: A Machine Learning Hybrided Optimisation Algorithm and Its Application in Circuit Design Problems


## Files and Structure
This project focuses on applying machine learning techniques, particularly Support Vector Machine (SVM) regression, to data processing and analysis tasks. It is organized into several phases, from data preparation and SVM training to objective function application and visualization. This project is a 99-grade assignment for the UESTC3036: Machine Learning and AI course (2023-2024).

### Data Preparation
- **`data_process.m`**: Script for data preprocessing.
- **`ga_save_each_gem.m`**: Handles data saving.

### SVM Training
- **`SVM.m`**: Main file for running the SVM training process.
- **`svmregression.m`**: Contains the SVM regression function used in training.

### Objective Function
- **`objectiveFunction.m`**: Implements the objective function for Phase 1.
- **`pre_obj.m`**: Implements the objective function for Phase 2.
  - **`tempCompCurve.m`**: Temperature compensation curve function.
  - **`voltageCurve.m`**: Voltage curve function.

### Plotting
- **`plotBestOnly.m`**: Plots only the best-performing data.
- **`plotPosStd.m`**: Plots positional standard deviations.
- **`plotStd.m`**: General standard deviation plot.
- **`plot.m`**: Main plotting script.

### Additional Files
- **`StandardComponentValues.mat`**: Required for component value standardization.

## Usage
1. Clone this repository and add all files to your MATLAB path.
2. Run **`main.m`** as the main file for executing the program.
