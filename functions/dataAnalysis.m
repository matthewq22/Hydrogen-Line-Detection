function corrected = dataAnalysis(app, doCheck)

    failure = false;
    
    if doCheck
        % Check to see that the device is still connected
        info = sdrinfo(app.sdr.RadioAddress);
        if isempty(info)
           % Stop all processes if no device connected
           rtlNotConnected(app);
           % Require to start from background once again
           app.ScanButton.Enable = 'off';
           app.AccumulateButton.Enable = 'off';
           corrected = zeros(app.fftSize, 1);
           failure = true;
        end
    end
    if ~failure
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    end
end