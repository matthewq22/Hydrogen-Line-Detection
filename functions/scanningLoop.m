function scanningLoop(app)
    % To be run when entering scanning mode
    time = app.ScanLengthSlider.Value;
    
    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    
    numSamples = int32(time / frameLength);
    
    app.lastSamples = zeros(app.fftSize, numSamples);

    count = 0.;
    numNonZeroFrames = 0.; % Number of non zeros frames in the array



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

        count = count + 1;
        numNonZeroFrames = numNonZeroFrames + 1;

        % Average last n number of samples
        toplot = sum(app.lastSamples, 2) / double(min(numNonZeroFrames, numSamples));

        plotting(app, toplot);

        
        
        if app.closeReq
            onClose(app);
            break
        end
    end
    if isvalid(app)
        app.StartCalibrationButton.Enable = 'on';
    end
end