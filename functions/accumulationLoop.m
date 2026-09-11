function accumulationLoop(app)
    resetplotview(app.UIAxes);
    updateVelocityScale(app);
    
    elapsedTime = tic;

    ready = config(app);

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
            newData = dataAnalysis(app, doCheck);
            app.accumData = app.accumData + newData;
            app.accumCount = app.accumCount + 1;
            toPlot = app.accumData / app.accumCount;
            
            plotting(app, toPlot);
        end
        release(app.sdr);
        app.sdr = [];
    else
        rtlNotConnected(app);
    end
end
