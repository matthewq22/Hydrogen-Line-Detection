function success = baseCal(app, time)
    % Function to find the average background vector
    fprintf("Calibrating...\n")

    % Determine the number of frames needed
    frameLength = app.sdr.SamplesPerFrame / app.sdr.SampleRate;
    numFrames = int32(time / frameLength);
    
    % Create results vector and hanning window
    vector = zeros(app.fftSize, 1);
    win = hann(app.fftSize);

    success = true;
    
    % Update UI
    drawnow;

    % Create progress bar pbject
    bar = uiprogressdlg(app.UIFigure, Title='Calibrating',...
        Message='Measuring background noise',...
        Cancelable='on');

    elapsedTime = tic;
    try
        for i=1:numFrames
            % Check if the calibration has been cancelled
            if bar.CancelRequested
                error("Cancel Requested")
            end

            % Check sdr is still connected
            if toc(elapsedTime) >= 0.1
                info = sdrinfo(app.sdr.RadioAddress);
                if isempty(info)
                    error("RTL-SDR Disconnected")
                end
                elapsedTime = tic;
            end

            % Collect data and fft
            data = app.sdr();
            mag = abs(fft(data .* win)).^2;
            
            % Add this frame to existing frames
            vector = vector + mag;

            % Update progress bar
            if mod(i,100) == 0
                bar.Value = double(i) / double(numFrames);
            end
        end
        
        % Total average background vector
        app.avgBg = fftshift(vector / double(numFrames));
    catch ME
        fprintf('Calibration stopped due to: %s\n', ME.message);
        % If the error was due to anything other than the cancel being
        % requested, show the error message
        if ME.message ~= "Cancel Requested"
            rtlNotConnected(app);
        end
        success = false;
    end
    if isvalid(bar)
        delete(bar)
    end
end