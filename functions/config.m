function sdrConnected = config(app)
    % Configure the RTL-SDR
    app.centreFreq = app.CentreFrequencySlider.Value * 10^6;
    app.fftSize = str2double(app.FFTSizeDropDown.Value);
    app.window = hann(app.fftSize);
    rawFreqs = ((-app.fftSize/2 : app.fftSize/2 - 1) * (app.sampleRate / app.fftSize)); 
    app.freq = (app.centreFreq + rawFreqs) / 1e6; % MHz
    app.accumData = zeros(app.fftSize, 1);
    app.plotLine = min(app.freq) < app.targetFreq && max(app.freq) > app.targetFreq;

    fprintf("Min freq: %f\nMax freq: %f\n", min(app.freq), max(app.freq));
    
    % 1. Cleanly clear out any existing stale device locks before re-testing
    if ~isempty(app.sdr) && isvalid(app.sdr)
        release(app.sdr); 
        clear app.sdr;
    end

    try
        % 2. Attempt to create the object 
        app.sdr = comm.SDRRTLReceiver(...
            'CenterFrequency', app.centreFreq, ...
            'SampleRate', app.sampleRate, ...
            'OutputDataType', 'double', ...
            'SamplesPerFrame', app.fftSize);
        
        % 3. Extract the info struct. 
        % (If no hardware is plugged in, this line will immediately trigger an error)
        radioDetails = info(app.sdr); 
        fprintf("Finished searching\n");
        disp(radioDetails);
        
        % 4. If we made it here without an error, the hardware is alive!
        sdrConnected = true;
    
    catch ME
        % 5. This handles an unplugged radio or a port conflict error seamlessly
        fprintf("SDR Connection Failed: %s\n", ME.message);
        sdrConnected = false;
        rtlNotConnected(app);
    end

end