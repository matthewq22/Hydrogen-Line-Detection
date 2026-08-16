function scanningLoop(app)
    % To be run when entering scanning mode
    numSamples = int32(app.ScanLengthSlider.Value);
    app.lastSamples = zeros(app.fftSize, numSamples);

    count = 0;

    % Loop to run while in the scanning phase
    while app.isScanning
        if mod(count, 200) == 0
            % Check RTL-SDR is still running
            doCheck = true;
        else
            doCheck = false;
        end
        % Get latest fft vector
        newData = dataAnalysis(app, doCheck);
        app.StartCalibrationButton.Enable = 'off';

        % Append to previous vectors
        app.lastSamples(:, 1:end - 1) = app.lastSamples(:, 2:end);
        app.lastSamples(:, end) = newData;

        % Average last n number of samples
        toplot = mean(app.lastSamples, 2);

        plot(app.UIAxes, app.freq, toplot);
        drawnow limitrate; 
        if app.closeReq
            onClose(app);
            break
        end
    end
    if isvalid(app)
        app.StartCalibrationButton.Enable = 'on';
    end
end