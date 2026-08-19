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

    % Initialise plots

    hLine = plot(app.UIAxes, app.freq, zeros(app.fftSize, 1));
    hold(app.UIAxes, 'on');
    hTargetLine = xline(app.UIAxes, app.targetFreq, 'Color', 'r', 'LineWidth', 1.5);
    if app.plotLine
        hTargetLine.Visible = 'on';
    else
        hTargetLine.Visible = 'off';
    end
    hold(app.UIAxes, 'off');

    % Loop to run while in the scanning phase
    while app.isScanning
        if mod(count, 100) == 0
            % Check RTL-SDR is still running
            doCheck = true;
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
        %toplot = runningSum / double(min(numNonZeroFrames, numSamples));
        toplot = runningSum / double(numSamples);

        plotting(app, toplot, hLine, hTargetLine);

    end
    if isvalid(app)
        app.StartCalibrationButton.Enable = 'on';
    end
end