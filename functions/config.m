function sdrConnected = config(app)
    % Configure the RTL-SDR
    app.centreFreq = app.CentreFrequencySlider.Value * 10^6;
    app.fftSize = str2double(app.FFTSizeDropDown.Value);
    app.window = hann(app.fftSize);
    rawFreqs = ((-app.fftSize/2 : app.fftSize/2 - 1) * (app.sampleRate / app.fftSize)); 
    app.freq = (app.centreFreq + rawFreqs) / 1e6; % MHz
    app.accumData = zeros(app.fftSize, 1);
    app.plotLine = min(app.freq) < app.targetFreq && max(app.freq) > app.targetFreq;

    if ~isempty(app.sdr) && isvalid(app.sdr)
        release(app.sdr); 
        clear app.sdr;
    end

    try
        app.sdr = comm.SDRRTLReceiver(...
            'CenterFrequency', app.centreFreq, ...
            'SampleRate', app.sampleRate, ...
            'OutputDataType', 'double', ...
            'SamplesPerFrame', app.fftSize);
        
        % Check sdr is connected before doing anything else
        info = sdrinfo(app.sdr.RadioAddress);
        if isempty(info)
            error("Radio not connected");
        end
        sdrConnected = true;
    
    catch ME
        fprintf("SDR Connection Failed: %s\n", ME.message);
        sdrConnected = false;
        rtlNotConnected(app);
    end
end