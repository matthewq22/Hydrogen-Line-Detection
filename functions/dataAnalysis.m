function corrected = dataAnalysis(app)
    data = app.sdr();
    y = abs(fft(data .* app.window)).^2;
    y = fftshift(y);

    corrected = y ./ app.avgBg;
end