function toggleScan(app)
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
        scanningLoop(app);
    end      
end