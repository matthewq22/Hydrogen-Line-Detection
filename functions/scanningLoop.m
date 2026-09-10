function scanningLoop(app)
    % To be run when entering scanning mode
    time = app.ScanLengthSlider.Value;
    
    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    
    numSamples = int32(time / frameLength);
    
    app.lastSamples = zeros(app.fftSize, numSamples);
    runningSum = zeros(app.fftSize, 1);

    bufferInd = 1;
    count = 0.;
    numNonZeroFrames = 0.; % Number of non zeros frames in the array

    app.StartCalibrationButton.Enable = 'off';
    app.ResetButton.Enable = 'off';

    % Create plots
    [targetLine, ax1, ax2] = createPlots(app);

    elapsedTime = tic;

    % Loop to run while in the scanning phase
    while app.isScanning
        if toc(elapsedTime) >= 0.1
            doCheck = true;
            elapsedTime = tic;
        else
            doCheck = false;
        end
        % Get latest fft vector
        newData = dataAnalysis(app, doCheck);
        oldData = app.lastSamples(:, bufferInd);

        runningSum = runningSum + newData - oldData;
        app.lastSamples(:, bufferInd) = newData;

        count = count + 1;
        numNonZeroFrames = numNonZeroFrames + 1;
        bufferInd = bufferInd + 1;

        if bufferInd > numSamples
            bufferInd = 1;
        end
         
        % Average last n number of samples
        %toPlot = runningSum / double(min(numNonZeroFrames, numSamples));
        toPlot = runningSum / double(numSamples);

        plotting(app, toPlot, targetLine, ax1, ax2);

    end
    if isvalid(app)
        app.StartCalibrationButton.Enable = 'on';
        app.ResetButton.Enable = 'on';
    end
end