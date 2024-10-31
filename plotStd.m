function state = plotStd(options,state,flag)

switch flag
    case 'init'
        hold on;
        set(gca,'xlim',[0,options.MaxGenerations]);
        xlabel('Generation','interp','none');
        ylabel('Standard deviation','interp','none');
        plotstd = plot(state.Generation,std(state.Score),'.b');
        set(plotstd,'Tag','gaplotbestf');
        title('Best: ','interp','none')
    case 'iter'
        STD = std(state.Score);
        plotstd = findobj(get(gca,'Children'),'Tag','gaplotbestf');
        newX = [get(plotstd,'Xdata') state.Generation];
        newY = [get(plotstd,'Ydata') STD];
        set(plotstd,'Xdata',newX, 'Ydata',newY);
        set(get(gca,'Title'),'String',sprintf('Fitness std: %g',STD));
    case 'done'
        LegnD = legend('Fitness std');
        set(LegnD,'FontSize',8);
        hold off;
end

end

