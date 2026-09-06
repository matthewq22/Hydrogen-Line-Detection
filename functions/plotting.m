function plotting(app, toPlot, lineHandle, hydrogenLine, ax1, ax2)
     % 1. Apply Savitzky-Golay filtering if enabled
     if app.applySmoothing
         toPlot = sgolayfilt(toPlot, app.smoothingOrder, app.smoothingFrame);
     end
     
     lineHandle.YData = toPlot;
     
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
         uistack(ax2, 'top');
     end

     drawnow limitrate
end
