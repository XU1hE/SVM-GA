function [state, options, optchanged] = ga_save_each_gen(options, state, flag)
    
    % This is a ga_save_each_gen function by Y. Xu (Dec. 18, 2023)
    % It saves the individual position in each generation as file

    % Extract relevant information from the current genetic algorithm state
    Score_gen = state.Score;
    Population_gen = state.Population;
    Generation_gen = state.Generation;
    
    % Initialize optchanged variable
    optchanged = [];
    
    % Specify the folder to store the results and create it if it doesn't exist
    folder = 'result';

    % Define the filename based on the current generation number
    filename = fullfile(folder, ['gen_' num2str(Generation_gen, '%.4d') '.mat']);
    
    % Save the current generation data to a MAT file
    save(filename, 'Score_gen', 'Population_gen', 'Generation_gen');
end
