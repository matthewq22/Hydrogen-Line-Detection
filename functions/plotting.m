function plotting(app, toPlot, data, hydrogenLine)
     if app.applySmoothing
         toPlot = sgolayfilt(toPlot, app.smoothingOrder, app.smoothingFrame);
     end
     data.YData = toPlot;
     if app.plotLine
         hydrogenLine.Visible = 'on';
     else
         hydrogenLine.Visible = 'off';
     end

     drawnow limitrate
end