function plotting(app, toPlot)
    % 1. Apply Savitzky-Golay filtering if enabled
    hydrogenLine = app.HydrogenLineHandle;
    ax1 = app.UIAxes;
    ax2 = app.VelocityAxes;

     if app.applySmoothing
         toPlot = sgolayfilt(toPlot, app.smoothingOrder, app.smoothingFrame);
     end
     
     % Update data
     app.PlotLineHandle.YData = toPlot;
     
     % Show hydrogen line
     if app.plotLine
         hydrogenLine.Visible = 'on';
         hydrogenLine.Value = app.targetFreq;
     else
         hydrogenLine.Visible = 'off';
     end

     % Scale axes
     if isvalid(ax2)
         ax2.YLim = ax1.YLim;
     end

     drawnow limitrate
end
