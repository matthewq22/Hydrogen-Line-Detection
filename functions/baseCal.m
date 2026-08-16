function success = baseCal(app, time)
    % Function to find the average background vector

    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    numFrames = time / frameLength;
    
    vector = zeros(app.fftSize, 1);
    win = hann(app.fftSize);

    success = true;
    
    for i=1:numFrames
        if mod(i, 50) == 0
            % Check if the RTL-SDR is still connected
            info = sdrinfo(app.sdr.RadioAddress);
            if isempty(info)
                rtlNotConnected(app);
                success = false;
                break
            end
        end
        data = app.sdr();
        mag = abs(fft(data .* win)).^2;
        
        vector = vector + mag;
    end
    
    app.avgBg = fftshift(vector / numFrames);
end