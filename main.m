% UESTC3036: Machine Learning and AI (2023-2024) Course Project
% Author: Yihe Xu, Glasgow College, UESTC
% GUID: 2720719x
% Date: Dec. 18, 2023

% This is the main file to run the program. For proper applicaiton

% Date preparation
%  | 'data_process.m'      (data preparation),
%  | 'ga_save_each_gem.m'  (data saving),
% SVM training
%  | 'SVM.m'               (top file),
%  | 'svmregression.m'     (regression function),
% Objective function
%  | 'objectiveFunction.m' (Phase 1),
%  | 'pre_obj.m'           (Phase 2),
%    | 'tempCompCurve.m'
%    | 'voltageCurve.m'
% Plotting
%  | 'plotBestOnly.m'
%  | 'plotPosStd.m'
%  | 'plotStd.m'
%  | 'plot.m'
%  as well as 'StandardComponentValues.mat' 
% should be included in path.

%% Clear the workspace and command window
clc
close all

%% Temperature and Voltage Data
Tdata = -40:5:85;
Vdata = 1.026E-1 + -1.125E-4 * Tdata + 1.125E-5 * Tdata.^2;

%% Load in Standard Component Values
load('StandardComponentValues.mat')

%% Optimization by GA

% Parameters
GEN = 50;           % generation
Pop = 20;           % population
Cro = 0.7;          % cross over rate
GEN2 = 30;          % generation 2
Pop2 = 10;          % population 2
Cro2 = 0.5;         % cross over rate 2
MAXRUN = 10;        % Run times
p = 0.3;            % Top select
% Constrain All 6 Variables to be Integers
intCon = 1:6;


for run = 1:MAXRUN
    
    folder = 'result';
    if ~exist(folder, 'dir')
        mkdir(folder);
    else
        rmdir(folder, 's');
        mkdir(folder);
    end
    
    %% GA Phase 1
    % Bounds on our Vector of Indices
    lb = [1 1 1 1 1 1];
    ub = [70 70 70 70 9 9];

    options = gaoptimset('PlotFcn',{@plotBestfOnly,@plotStd,@plotPosStd}, ...
        'CrossoverFrac', Cro,'PopulationSize', Pop,'Generations', GEN,'OutputFcns', @ga_save_each_gen);

    [xOpt,fVal, ~, output] = ga(@(x)objectiveFunction(x,Res,ThVal,ThBeta,Tdata,Vdata),...
        6,[],[],[],[],lb,ub,[],intCon,options);

    % store the results
    result1(run) = fVal;                
    fitness1(:, run) = polt(GEN);
    
    %% data process
    [label, feature, ub, lb, POPULATION] = data_process(output.generations, p, Pop2);

    %% SVM
    [model, TSps, TSXps] = SVM(label, feature);    

    %% GA Phase 2
    options = gaoptimset('PlotFcn',{@plotBestfOnly,@plotStd,@plotPosStd}, ...
        'InitialPopulation', POPULATION, 'CrossoverFrac', Cro2,'PopulationSize', ...
        Pop2,'Generations', GEN2, 'OutputFcns', @ga_save_each_gen);

    [x, fval, exitFlag, output] = ga(@(x)pre_obj(x, model, TSps, TSXps,Res, ...
        ThVal, ThBeta,Tdata,Vdata, Pop2, GEN2, run),6,[],[],[],[],lb,ub,[],intCon,options);

     % store the results
    result2(run) = fVal;               
    fitness2(:, run) = polt(GEN2);

    %% whole fitness store
    fitness(:, run) = [fitness1(:, run); fitness2(:, run)];
    fitness = mean(fitness, 2);
end

%% Results
averesult1 = mean(result1);

max_value = max(result2);
min_value = min(result2);
mean_value = mean(result2);
variance_value = std(result2);

% Print the results
fprintf('Maximum value: %f\n', max_value);
fprintf('Minimum value: %f\n', min_value);
fprintf('Average value: %f\n', mean_value);
fprintf('Standard deviation：%f\n', variance_value);


%% average convergence curve
figure;

generation = 1:length(fitness);
x_values = zeros(size(generation));

for i = 1:length(generation)
    if generation(i) < GEN+1
        x_values(i) = generation(i) * Pop ;
    else
        x_values(i) = GEN * Pop + (generation(i)-GEN) * Pop2;
    end
end

plot(x_values, fitness, 'LineWidth', 2);
title('Average Convergence Plot');
xlabel('Evaluation');
ylabel('Best Objective Function Value');
grid on;




