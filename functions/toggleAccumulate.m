function toggleAccumulate(app)
    % Switch between accumulating and not
    if app.isScanning
        toggleScan(app);
    end
    
    if app.isAccumulating
        app.isAccumulating = false;
        app.AccumulateButton.BackgroundColor = 'green';
        app.AccumulateButton.Text = 'Accumulate';
        app.ScanButton.Enable = 'on';
        app.StartCalibrationButton.Enable = 'on';
    else
        app.isAccumulating = true;
        app.AccumulateButton.BackgroundColor = 'red';
        app.AccumulateButton.Text = 'Stop';
        app.StartCalibrationButton.Enable = 'off';
        app.ScanButton.Enable = 'off';
        drawnow
        accumulationLoop(app);
    end
end