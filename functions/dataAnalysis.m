function corrected = dataAnalysis(app)
    try
        data = app.sdr();
        y = abs(fft(data .* app.window)).^2;
        y = fftshift(y);
    
        corrected = y ./ app.avgBg;
    catch exception
        rtlNotConnected(app);
        corrected = zeros(app.fftSize);
    end
end