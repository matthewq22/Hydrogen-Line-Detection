function rtlNotConnected(app)
    % To be run when RTL-SDR is disconnected
    app.WarningsLabel.Text = 'CONNECT RTL-SDR';
    app.WarningsLabel.FontColor = 'red';
    app.WarningsLabel.Visible = 'on';
    app.StartCalibrationButton.Enable = 'on';

    % Stop all processes
    if app.isAccumulating
        toggleAccumulate(app);
    end
    if app.isScanning
        toggleScan(app);
    end
    app.sdr = [];
    drawnow;
end