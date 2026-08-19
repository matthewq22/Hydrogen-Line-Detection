function success = baseCal(app, time)
    % Function to find the average background vector

    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    numFrames = int32(time / frameLength);
    
    vector = zeros(app.fftSize, 1);
    win = hann(app.fftSize);

    success = true;
    
    tic;
    try
        for i=1:numFrames
            data = app.sdr();
            mag = abs(fft(data .* win)).^2;
            
            vector = vector + mag;
        end
        
        app.avgBg = fftshift(vector / double(numFrames));
    
        time = toc;
    
        fprintf("Calibration time: %f\nSample Rate: %f\nSamples Per Frame: %f\nFrame Length: %f\nnumFrames: %f\n", time, app.sdr.SampleRate, app.sdr.SamplesPerFrame,frameLength, numFrames);
    catch ME
        rtlNotConnected(app);
        success = false;
    end
end