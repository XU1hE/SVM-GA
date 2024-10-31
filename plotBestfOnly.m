function state = plotBestfOnly(options,state,flag)

if size(state.Score,2) > 1
    msg = getString(message('globaloptim:gaplotcommon:PlotFcnUnavailable' ...
        ,'gaplotBestfOnly'));
    title(msg,'interp','none');
    return;
end

switch flag
    case 'init'
        hold on;
        set(gca,'xlim',[0,options.MaxGenerations]);
        xlabel('Generation','interp','none');
        ylabel('Fitness value','interp','none');
        plotBest = plot(state.Generation,min(state.Score),'.k');
        set(plotBest,'Tag','gaplotbestf');
        title('Best: ','interp','none')
    case 'iter'
        best = min(state.Score);
        plotBest = findobj(get(gca,'Children'),'Tag','gaplotbestf');
        newX = [get(plotBest,'Xdata') state.Generation];
        newY = [get(plotBest,'Ydata') best];
        set(plotBest,'Xdata',newX, 'Ydata',newY);
        set(get(gca,'Title'),'String',sprintf('Best: %g',best));
    case 'done'
        LegnD = legend('Current best fitness');
        set(LegnD,'FontSize',8);
        hold off;
end
end




