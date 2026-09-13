function corrected = dataAnalysis(app, doCheck)
    failure = false;

    % Check if sdr is still connected
    if doCheck && ~app.bypassHardwareCheck
        info = sdrinfo(app.sdr.RadioAddress);
        if isempty(info)
            rtlNotConnected(app);
            corrected = zeros(app.fftSize, 1);
            failure = true;

            % Force a re-calibration after disconnected
            app.ScanButton.Enable = 'off';
            app.AccumulateButton.Enable = 'off';
        end
    end
    if ~failure
        % FFT and adjust for background
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    end   
end