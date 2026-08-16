function rtlNotConnected(app)
    app.WarningsLabel.Text = 'CONNECT RTL-SDR';
    app.WarningsLabel.FontColor = 'red';
    app.WarningsLabel.Visible = 'on';
    if app.isAccumulating
        toggleAccumulate(app);
    end
    if app.isScanning
        toggleScan(app);
    end
    drawnow;
end