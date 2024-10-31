function F = pre_obj(x, model, TSps, TSXps, StdRes, StdTherm_Val, StdTherm_Beta, Tdata, Vdata, Pop2, GEN2, run)

    % This is a pre_obj function by Y. Xu (Dec. 18, 2023)
    % It is an objective function for Phase 2

    persistent gen pop;
    
    current_run = evalin('base', 'run');
    if isempty(pop) || current_run ~= run
        pop = 1;
        gen = 1;
    end 
     
    if mod(gen, GEN2) > 1 && mod(pop, 2) == 0
        [TSX, TSXps] = mapminmax(x, TSXps);
        F = abs(mapminmax('reverse', svmpredict(0, TSX, model), TSps));
    else
        F = objectiveFunction(x, StdRes, StdTherm_Val, StdTherm_Beta, Tdata, Vdata);
    end
    
    pop = pop + 1;
    if pop == Pop2 + 1
        gen = mod(gen + 1, GEN2);
        pop = 1;
    end

end