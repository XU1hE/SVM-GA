function [model, TSps, TSXps] = SVM(Score, Population)

    % This is used for performing a 2nd stage SVM by Y. Xu (Dec. 18, 2023)

    %% Data preparation
    
    % extract data
    ts = Score;
    tsx = Population;
    original = ts(length(Score)*0.7+1:end,:);
    % data preprocessing
    ts = ts';
    tsx = tsx';
    % mapminmax is an mapping function in matlab
    % Use mapminmax to do mapping
    [TS,TSps] = mapminmax(ts);
    % The scale of the data from 1 to 2
    TSps.ymin = 1;
    TSps.ymax = 2;
    %normalization
    [TS,TSps] = mapminmax(ts,TSps);
    
    % plot the graphic of the fitness after mapping
    % figure;
    % histogram(TS, 'Normalization', 'probability', 'EdgeColor', 'none');
    % title('Probability Distribution of Fitness','FontSize',12);
    % xlabel('Fitness','FontSize',10);
    % ylabel('Probability','FontSize',10);
    % grid on;
    % pause;
    
    TS = TS';
    
    [TSX,TSXps] = mapminmax(tsx);
    TSXps.ymin = 1;
    TSXps.ymax = 2;
    [TSX,TSXps] = mapminmax(tsx,TSXps);
    TSX = TSX';
    
    %% split the data into training and testing
    n1 = length(TS)*0.7;
    train_label = TS(1:n1,:);
    train_data = TSX(1:n1,:);
    test_label = TS(n1+1:end,:);
    test_data = TSX(n1+1:end,:);
    
    % Find the optimize value of c,g paramter
    % Approximately choose the parameters:
    % the scale of c is 2^(-5),2^(-4),...,2^(10)
    % the scale of g is 2^(-5),2^(-4),...,2^(5)
    [bestmse,bestc,bestg] = svmregress(train_label,train_data,-5,10,-5,5,3,1,1,0.0005);
    
    % Display the approximate result
    disp('THIS IS THE 1st ROUND>>>');
    disp('Display the approximate result');
    str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g.\n',bestmse,bestc,bestg);
    disp(str);
    
    
    % Choose more precise parameter according to the graphic of previous step:
    % the scale of c is 2^(0),2^(0.3),...,2^(10)
    % the scale of g is 2^(-2),2^(-1.7),...,2^(3)
    [bestmse,bestc,bestg] = svmregress(train_label,train_data,0,10,-2,3,3,0.3,0.3,0.0002);
    
    disp('THIS IS THE 2nd ROUND>>>');
    disp('Display the final parameter result');
    str = sprintf( 'Best Cross Validation MSE = %g Best c = %g Best g = %g.\n',bestmse,bestc,bestg);
    disp(str);
    
    %% Do training by using svmtrain of libsvm
    cmd = ['-c ', num2str(bestc), ' -g ', num2str(bestg) , ' -s 3 -p 0.01'];
    model = svmtrain(train_label,train_data,cmd);
    
    %% Do predicting by using svmpredict of libsvm
    predict= svmpredict(test_label, test_data, model);
    predict = mapminmax('reverse', predict, TSps);
    
    %% Display the result of SVM Regression
    str = sprintf( 'MSE = %g R = %g%%',mse(2),mse(3)*100);
    disp(str);
    

    figure;
    hold on;
    plot(original,'LineWidth',1);
    plot(predict,'r','LineWidth',1);
    legend('Original Fitness','Predict Fitness','FontSize',10);
    hold off;
    grid on;
    snapnow;
end