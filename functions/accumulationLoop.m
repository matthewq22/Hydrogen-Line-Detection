function accumulationLoop(app)
    % To be run when in accumulation phase
    app.StartCalibrationButton.Enable = 'off';
    count = 0;

    % Create plots
    toPlot = plot(app.UIAxes, app.freq, zeros(app.fftSize, 1));
    hold(app.UIAxes, 'on');
    targetLine = xline(app.UIAxes, app.targetFreq, 'Color', 'r', 'LineWidth', 1.5);
    if app.plotLine
        targetLine.Visible = 'on';
    else
        targetLine.Visible = 'off';
    end
    hold(app.UIAxes, 'off');

    elapsedTime = tic;

    while app.isAccumulating
        % Check if the RTL-SDR is still connected, every few cycles
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
        toplot = app.accumData / count;
        
        plotting(app, toplot, toPlot, targetLine);

    end
    if isvalid(app)
        % Allow calibration only once everything is stopped
        app.StartCalibrationButton.Enable = 'on';
    end
end