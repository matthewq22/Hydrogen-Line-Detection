function accumulationLoop(app)
    % Disable calibration button during the active phase
    app.StartCalibrationButton.Enable = 'off';
    count = 0;

    % Create plots
    [targetLine, ax1, ax2] = createPlots(app);
    
    elapsedTime = tic;

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
        count = count + 1;
        toPlot = app.accumData / count;
        
        plotting(app, toPlot, targetLine, ax1, ax2);
    end
    
    if isvalid(app)
        % Re-enable calibration
        app.StartCalibrationButton.Enable = 'on';
    end
end
