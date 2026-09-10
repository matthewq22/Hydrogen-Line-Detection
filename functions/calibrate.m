function calibrate(app)
    % To be run on calibrate being pressed: sets up everything needed
    app.ScanButton.Enable = 'off';
    app.AccumulateButton.Enable = 'off';
    app.StartCalibrationButton.Enable = 'off';
    app.ResetButton.Enable = 'off';
    cla(app.UIAxes);
    drawnow;

    % Stop all processes
    if app.isScanning
        toggleScan(app);
    end
    if app.isAccumulating
        toggleAccumulate(app);
    end
    
    % Configure the RTL-SDR
    ready = config(app);

    disp(ready);

    if ready
        integrationTime = app.CalibrationtimeEditField.Value;
        drawnow;

        % Get the baseline vector
        success = baseCal(app, integrationTime);

        if success
            % Plotting
            createPlots(app);
            plotting(app, app.avgBg);
            app.ScanButton.Enable = 'on';
            app.AccumulateButton.Enable = 'on';
            app.StartCalibrationButton.Enable = 'on';
            app.ResetButton.Enable = 'on';
        else
            app.StartCalibrationButton.Enable = 'on';
        end
    else
        app.StartCalibrationButton.Enable = 'on';
    end
    app.WarningsLabel.Visible = 'off';
end

