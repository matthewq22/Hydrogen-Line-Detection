# Full setup and operational instructions
A comprehensive guide on how to detect the 21cm hydrogen line of the milky way using amateur equipment.
### Before starting, ensure you have the following
* RTL-SDR
* LNA with hydrogen filter
* Wok & Tripod
* Wires to connect everything together

My setup used a nooelec SAWBird+ H1t as the LNA and an RTL-SDR V4, however other options may still work.

## Hardware Setup
1. Setup tripod and attach the wok to it
2. Connect the input side of the LNA directly to the antenna from the wok
3. Run a cable from the LNA output to the RTL-SDR, then by USB connect the RTL-SDR to a laptop

## Software setup
1. Download the installer at the end of this document
2. On macOS, a warning may appear when opening the installer saying it is damaged.
To get around this, run `sudo xattr -cr HLDInstaller_macOS` in the directory where the installer is.
3. Follow the installer instructions. MATLAB runtime will automatically be installed
4. For some devices, a driver may be needed for the RTL-SDR. These can be found online.

## Operation
1. Before starting anything, ensure the white LED on the LNA is on. Some trouble shooting options can be found at the end of this document
2. Set the calibration time, FFT Size and the centre frequency. None of these need to be changed from their default values, however the calibration time can be increased for more precise results. It should be a minimum of 60 seconds.
3. Locate the Milky Way with a smartphone app such as Stellarium. Point the wok well away from the Milky Way and click calibrate. This will measure the average background radio signals.
