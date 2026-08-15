function [avgBg] = baseCal(sdr, time, fftSize)
    
    frameLength = sdr.SamplesPerFrame / sdr.SampleRate;
    numFrames = time / frameLength;
    
    vector = zeros(fftSize, 1);
    win = hann(fftSize);
    
    for i=1:numFrames
        data = sdr();
        mag = abs(fft(data .* win)).^2;
        
        vector = vector + mag;
    end
    
    avgBg = fftshift(vector / numFrames);
end