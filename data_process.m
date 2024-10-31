function [label, feature, ub, lb, POPULATION] = data_process(end_gen, percentage, Pop2)

    % This is a data_process function by Y. Xu (Dec. 18, 2023)
    % It reads data into arrays and adapts selection and rearrangement
    
    % Initialize empty arrays to store all data
    all_Score_gen = [];
    all_Population_gen = [];
    all_Generation_gen = [];
    
    % Read and append data from all files 
    for gen_num = 1:end_gen
        % Build file path
        file_path = ['result/gen_' num2str(gen_num, '%.4d') '.mat'];
    
        % Load data from .mat file using the load function
        loaded_data = load(file_path);
    
        % Extract the required variables from the loaded data structure
        Score_gen = loaded_data.Score_gen;
        Population_gen = loaded_data.Population_gen;
        Generation_gen = loaded_data.Generation_gen;
    
        % Append to the overall arrays
        all_Score_gen = [all_Score_gen; Score_gen];
        all_Population_gen = [all_Population_gen; Population_gen];
        all_Generation_gen = [all_Generation_gen; Generation_gen];
    end

    % Sort the vector of scores
    [sorted_scores, sorted_indices] = sort(all_Score_gen);
    sorted_population = all_Population_gen(sorted_indices, :);

    %% Data cleaning
    % Find unique rows in the sorted population
    [population, ~, ic] = unique(sorted_population, 'rows');
    scores = zeros(size(population, 1), 1);
    scores(ic) = sorted_scores(:);

    %% Find new boundary
    % Calculate the index corresponding to the top percentage (e.g., 30%)
    index = round(percentage * numel(sorted_scores));
    
    % Extract scores, population, and generation for the top percentage
    population_top = all_Population_gen(sorted_indices(1:index), :);
    
    % Find the maximum and minimum values in population_top
    ub = max(population_top);
    lb = min(population_top);
    
    % Sort scores and rearrange population based on the sorted scores
    [~, temp_indices] = sort(scores);
    POPULATION = population(temp_indices(1:Pop2), :);
    
    %% Re order for training
    % Generate a random index order
    rng('shuffle'); % Use the current time as the random seed
    randomOrder = randperm(length(population));
    
    % Rearrange data based on the random index order
    label = scores(randomOrder);
    feature = population(randomOrder, :);

end
