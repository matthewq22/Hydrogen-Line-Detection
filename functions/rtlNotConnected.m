function rtlNotConnected(app)
    app.WarningsLabel.Text = 'CONNECT RTL-SDR';
    app.WarningsLabel.Visible = 'on';
    drawnow;

    if app.isAccumulating
        toggleAccumulate();
    end
    if app.isScanning
        toggleScan();
    end
end