function updateVelocityScale(app, ax1, ax2)
    % Ensure both axes are valid before performing updates
    if ~isvalid(ax1) || ~isvalid(ax2)
        return;
    end

    c = 299792.458; % Speed of light in km/s
    f0 = app.targetFreq; % Your hydrogen rest frequency

    % 1. Calculate raw velocity transformations at the current XLim boundaries
    % (Using the Radio Convention: divided by static f0)
    v_start = c * ((f0 - ax1.XLim(1)) / f0);
    v_end   = c * ((f0 - ax1.XLim(2)) / f0);

    % 2. Store the raw vector to determine direction
    rawVelLimits = [v_start, v_end];
    sortedLimits = sort(rawVelLimits);

    % 3. Set the limits sorted 
    ax2.XLim = sortedLimits;

    % 4. CRITICAL FIX: Force ticks at exactly every 50 km/s step
    tickStart = ceil(sortedLimits(1) / 50) * 50;  % Find next highest multiple of 50
    tickEnd   = floor(sortedLimits(2) / 50) * 50; % Find next lowest multiple of 50
    ax2.XTick = tickStart:50:tickEnd;             % Generate the 50 km/s grid array

    % 5. Invert the top axis visually so higher frequencies align with lower velocities
    if rawVelLimits(1) > rawVelLimits(2)
        ax2.XDir = 'reverse';
    else
        ax2.XDir = 'normal';
    end
end
