function accumulationLoop(app)
            % To be run when in accumulation phase
            app.StartCalibrationButton.Enable = 'off';
            data = zeros(app.fftSize, 1);
            count = 0;

            % Create plots
            hLine = plot(app.UIAxes, app.freq, zeros(app.fftSize, 1));
            hold(app.UIAxes, 'on');
            hTargetLine = xline(app.UIAxes, app.targetFreq, 'Color', 'r', 'LineWidth', 1.5);
            if app.plotLine
                hTargetLine.Visible = 'on';
            else
                hTargetLine.Visible = 'off';
            end
            hold(app.UIAxes, 'off');

            while app.isAccumulating
                % Check if the RTL-SDR is still connected, every few cycles
                if mod(count, 200) == 0
                    doCheck = true;
                else
                    doCheck = false;
                end
                % Add new data to existing vector
                newData = dataAnalysis(app, doCheck);
                data = data + newData;
                count = count + 1;
                toplot = data / count;
                
                plotting(app, toplot, hLine, hTargetLine);

            end
            if isvalid(app)
                % Allow calibration only once everything is stopped
                app.StartCalibrationButton.Enable = 'on';
            end
        end