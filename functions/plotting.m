function plotting(app, toPlot)
     if app.applySmoothing
         toPlot = sgolayfilt(toPlot, app.smoothingOrder, app.smoothingFrame);
     end
     plot(app.UIAxes, app.freq, toPlot)

     if app.plotLine
        xline(app.UIAxes, app.targetFreq, Color='r', LineWidth=1.5);
     end
     drawnow limitrate
end