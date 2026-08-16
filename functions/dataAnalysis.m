function corrected = dataAnalysis(app)
    info = sdrinfo();

    if ~isempty(info)
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    else
       rtlNotConnected(app);
       app.ScanButton.Enable = 'off';
       app.AccumulateButton.Enable = 'off';
       corrected = zeros(app.fftSize, 1);
   end
end