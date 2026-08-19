function corrected = dataAnalysis(app, doCheck)
    try
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    catch ME
        fprintf("Error catched");
        rtlNotConnected(app);
        corrected = zeros(app.fftSize, 1);
    end
end