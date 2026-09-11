function toggleScan(app)
    % Switch between scanning and not
    if app.isAccumulating
        toggleAccumulate(app);
    end
    
    if app.isScanning
        app.isScanning = false;
        app.ScanButton.BackgroundColor = 'green';
        app.ScanButton.Text = 'Start';
        app.StartCalibrationButton.Enable = 'on';
        app.ResetButton.Enable = 'on';
        app.AccumulateButton.Enable = 'on';
    else
        app.isScanning = true;
        app.ScanButton.BackgroundColor = 'red';
        app.ScanButton.Text = 'Stop';
        app.StartCalibrationButton.Enable = 'off';
        app.ResetButton.Enable = 'off';
        app.AccumulateButton.Enable = 'off';
        drawnow
        scanningLoop(app);
    end      
end