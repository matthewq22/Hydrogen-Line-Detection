function accumulationLoop(app)
    resetplotview(app.UIAxes);
    updateVelocityScale(app);
    
    elapsedTime = tic;

    [ready, sdr] = config(app);

    if ready
        while app.isAccumulating
            % Check if the RTL-SDR is still connected every 100ms
            if toc(elapsedTime) >= 0.1
                doCheck = true;
                elapsedTime = tic;
            else
                doCheck = false;
            end
            
            % Add new data to existing vector
            newData = dataAnalysis(app, sdr, doCheck);
            app.accumData = app.accumData + newData;
            app.accumCount = app.accumCount + 1;
            toPlot = app.accumData / app.accumCount;
            
            plotting(app, toPlot);
        end
        release(sdr);
    else
        rtlNotConnected(app);
    end
end
