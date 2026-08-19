function calibrate(app)
    % To be run on calibrate being pressed: sets up everything needed
    app.ScanButton.Enable = 'off';
    app.AccumulateButton.Enable = 'off';
    app.StartCalibrationButton.Enable = 'off';
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

    if ready
        integrationTime = app.CalibrationtimeEditField.Value;
        drawnow;

        % Get the baseline vector
        success = baseCal(app, integrationTime);

        if success
            % Plotting
            plot(app.UIAxes, app.freq, 10*log10(app.avgBg));
            if app.plotLine
                xline(app.UIAxes, app.targetFreq, Color='r', LineWidth=1.5);
            end
            xlim(app.UIAxes, [min(app.freq) max(app.freq)]);
            
            app.ScanButton.Enable = 'on';
            app.AccumulateButton.Enable = 'on';
            app.StartCalibrationButton.Enable = 'on';
        else
            app.StartCalibrationButton.Enable = 'on';
        end
    else
        app.StartCalibrationButton.Enable = 'on';
    end
    app.WarningsLabel.Visible = 'off';
end

