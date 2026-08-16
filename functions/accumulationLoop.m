function accumulationLoop(app)
            % Loop to run while in the accumulation phase
            app.StartCalibrationButton.Enable = 'off';
            data = zeros(app.fftSize, 1);
            count = 0;
            while app.isAccumulating
                if mod(count, 200) == 0
                    doCheck = true;
                else
                    doCheck = false;
                end
                % Add new data to existing vector
                newData = dataAnalysis(app, doCheck);
                data = data + newData;
                count = count + 1;
                plot(app.UIAxes, app.freq, data / count);
                drawnow limitrate;
                if app.closeReq
                    onClose(app);
                    break
                end
            end
            if isvalid(app)
                app.StartCalibrationButton.Enable = 'on';
            end
        end