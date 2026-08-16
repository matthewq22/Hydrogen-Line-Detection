function sdrConnected = config(app)
    app.centreFreq = app.CentreFrequencySlider.Value * 10^6;
    app.fftSize = str2double(app.FFTSizeDropDown.Value);
    app.window = hann(app.fftSize);
    rawFreqs = ((-app.fftSize/2 : app.fftSize/2 - 1) * (app.sampleRate / app.fftSize)); 
    app.freq = (app.centreFreq + rawFreqs) / 1e6; % MHz
    app.plotLine = min(app.freq) < app.targetFreq && max(app.freq) > app.targetFreq;
    
    sdrConnected = false;
    app.sdr = comm.SDRRTLReceiver(CenterFrequency=app.centreFreq, SampleRate=app.sampleRate, OutputDataType='double', SamplesPerFrame=app.fftSize);
    if app.sdr.info.RadioName ~= "Cannot find radio"
        sdrConnected = true;
    else
        rtlNotConnected(app);
    end
end