function state = plotPosStd(options,state,flag)

switch flag
    case 'init'
        hold on;
        population=state.Population;
        [samples,~]=size(state.Population);
        distance=0;averagePoint=mean(state.Population);
        for i=1:samples
            d = population(i,:)-averagePoint;
            distance= distance + sqrt(sum(d.*d));
        end
        diversity=distance/samples;
        set(gca,'xlim',[0,options.MaxGenerations]);
        xlabel('Generation','interp','none');
        ylabel('Standard deviation','interp','none');
        plotstd = plot(state.Generation,diversity,'.b');
        set(plotstd,'Tag','gaplotbestf');
        title('Best: ','interp','none')
    case 'iter'
        population=state.Population;
        [samples,~]=size(state.Population);
        distance=0;averagePoint=mean(state.Population);
        for i=1:samples
            d = population(i,:)-averagePoint;
            distance= distance + sqrt(sum(d.*d));
        end
        diversity=distance/samples;
        plotstd = findobj(get(gca,'Children'),'Tag','gaplotbestf');
        newX = [get(plotstd,'Xdata') state.Generation];
        newY = [get(plotstd,'Ydata') diversity];
        set(plotstd,'Xdata',newX, 'Ydata',newY);
        set(get(gca,'Title'),'String',...
            sprintf('Position std: %g',diversity));
    case 'done'
        LegnD = legend('Position Std');
        set(LegnD,'FontSize',8);
        hold off;
end
end

