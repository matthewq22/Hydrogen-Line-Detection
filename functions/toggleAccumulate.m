function toggleAccumulate(app)
    % Switch between accumulating and not
    if app.isScanning
        toggleScan(app);
    end
    
    if app.isAccumulating
        app.isAccumulating = false;
        app.AccumulateButton.BackgroundColor = 'green';
        app.AccumulateButton.Text = 'Accumulate';
    else
        app.isAccumulating = true;
        app.AccumulateButton.BackgroundColor = 'red';
        app.AccumulateButton.Text = 'Stop';
        accumulationLoop(app);
    end
end