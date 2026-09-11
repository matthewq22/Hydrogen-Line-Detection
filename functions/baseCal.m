function success = baseCal(app, time)
    % Function to find the average background vector

    fprintf("Calibrating...\n")

    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    numFrames = int32(time / frameLength);
    
    vector = zeros(app.fftSize, 1);
    win = hann(app.fftSize);

    success = true;
    
    drawnow;

    bar = uiprogressdlg(app.UIFigure, Title='Calibrating',...
        Message='Measuring background noise',...
        Cancelable='on');

    fprintf("Progress bar created\n");


    tic;
    try
        for i=1:numFrames
            if bar.CancelRequested
                error("Cancel Requested")
            end
            data = app.sdr();
            mag = abs(fft(data .* win)).^2;
            
            vector = vector + mag;
            if mod(i,1000) == 0
                bar.Value = double(i) / double(numFrames);
            end
        end
        
        app.avgBg = fftshift(vector / double(numFrames));
    
        time = toc;
    
        fprintf("Calibration time: %f\nSample Rate: %f\nSamples Per Frame: %f\nFrame Length: %f\nnumFrames: %f\n", time, app.sdr.SampleRate, app.sdr.SamplesPerFrame,frameLength, numFrames);
    catch ME
        fprintf('Calibration stopped due to: %s\n', ME.message);
        if ME.message ~= "Cancel Requested"
            rtlNotConnected(app);
        end
        success = false;
    end
    
    if isvalid(bar)
        delete(bar)
    end
end