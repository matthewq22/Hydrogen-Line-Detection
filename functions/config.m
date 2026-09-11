function sdrConnected = config(app)
    % Configure the RTL-SDR
    app.centreFreq = app.CentreFrequencySlider.Value * 10^6;
    app.fftSize = str2double(app.FFTSizeDropDown.Value);
    app.window = hann(app.fftSize);
    rawFreqs = ((-app.fftSize/2 : app.fftSize/2 - 1) * (app.sampleRate / app.fftSize)); 
    app.freq = (app.centreFreq + rawFreqs) / 1e6; % MHz
    app.accumData = zeros(app.fftSize, 1);
    app.plotLine = min(app.freq) < app.targetFreq && max(app.freq) > app.targetFreq;

    % Once the centre frequency has been set, it cannot be changed again.
    % This is because my code is bad. Would be good to fix it
    app.CentreFrequencySlider.Enable = 'off';

    fprintf("Min freq: %f\nMax freq: %f\n", min(app.freq), max(app.freq));

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
        
        radioDetails = info(app.sdr); 
        fprintf("Finished searching\n");
        disp(radioDetails);
        
        sdrConnected = true;
    
    catch ME
        fprintf("SDR Connection Failed: %s\n", ME.message);
        sdrConnected = false;
        rtlNotConnected(app);
    end

end