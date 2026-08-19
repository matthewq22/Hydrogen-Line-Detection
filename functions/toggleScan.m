function toggleScan(app)
    % Switch betweeing scanning and not
    if app.isAccumulating
        toggleAccumulate(app);
    end
    
    if app.isScanning
        app.isScanning = false;
        app.ScanButton.BackgroundColor = 'green';
        app.ScanButton.Text = 'Start';
    else
        app.isScanning = true;
        app.ScanButton.BackgroundColor = 'red';
        app.ScanButton.Text = 'Stop';
        scanningLoopOpt(app);
    end      
end