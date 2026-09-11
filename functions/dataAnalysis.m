function corrected = dataAnalysis(app, doCheck)
    failure = false;

    if doCheck && ~app.bypassHardwareCheck
        %info = sdrinfo(app.sdr.RadioAddress);
        locked = isLocked(app.sdr);
        if ~locked
            rtlNotConnected(app);
            corrected = zeros(app.fftSize, 1);
            failure = true;

            % Force a recalibration after disconnected
            app.ScanButton.Enable = 'off';
            app.AccumulateButton.Enable = 'off';
        end
    end
    if ~failure
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    end   
end