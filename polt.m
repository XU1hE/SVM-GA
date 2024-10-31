function fitness = polt(end_gen)

    % This is a polt function by Y. Xu (Dec. 18, 2023)
    % It saves the score in each generation as array

    Score = [];
    fitness = [];
    for gen_num = 1:end_gen
        % Build file path
        file_path = ['result/gen_' num2str(gen_num, '%.4d') '.mat'];
    
        % Load data from .mat file using the load function
        loaded_data = load(file_path);
    
        % Extract the required variables from the loaded data structure
        Score = loaded_data.Score_gen;
        select = min(Score);
        fitness = [fitness, select];
    end
    for i = 2:end_gen
        if fitness(i) > fitness(i-1)
            fitness(i) = fitness(i-1);
        end
    end
end