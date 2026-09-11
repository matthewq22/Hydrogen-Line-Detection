function scanningLoop(app)
    % To be run when entering scanning mode
    
    [ready, sdr] = config(app);

    time = app.ScanLengthSlider.Value;

    resetplotview(app.UIAxes);
    updateVelocityScale(app);
    
    frameLength = sdr.SamplesPerFrame / sdr.SampleRate;
    
    numSamples = int32(time / frameLength);
    
    app.lastSamples = zeros(app.fftSize, numSamples);
    runningSum = zeros(app.fftSize, 1);

    bufferInd = 1;
    count = 0.;
    numNonZeroFrames = 0.; % Number of non zeros frames in the array

    elapsedTime = tic;

    if ready

        % Loop to run while in the scanning phase
        while app.isScanning
            if toc(elapsedTime) >= 0.1
                doCheck = true;
                elapsedTime = tic;
            else
                doCheck = false;
            end
            % Get latest fft vector
            newData = dataAnalysis(app, sdr, doCheck);
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
    
            plotting(app, toPlot);
        end
        release(sdr);
    else
        rtlNotConnected(app);
    end
end