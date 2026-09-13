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
3. Locate the Milky Way with a smartphone app such as Stellarium. Point the wok well away from the Milky Way and click 'Start Calibration'. This will measure the average background radio signal.
4. After the calibration has been completed, the plot will show the results. There should be a smooth bump near the centre frequency.
5. To locate the Milky Way precisely, the Scanning mode can be used. Scanning mode will only show the results for up to the last 50 seconds of recorded data. This time can be adjusted using the slider before pressing Scan. Point the wok towards the Milky Way and press Scan. After waiting for roughly the amount of time you selected, check to see if there is a smooth peak near the red hydrogen line. If there is not, adjust the wok and repeat until it can be seen.
6. Once the Milky Way has been found, Accumulation mode can be used. This will continuously record data and average them, so the hydrogen line peak becomes even clearer.
7. Adjusting the position of the wok along the milky way, switching between scan and accumulate, will allow for the red and blue shift of the hydrogen line to be observed. Ensure that the Reset button in the accumulation panel is clicked when moving to a different part of the sky.

## Figures panel
This panel provides a number of options for the display.

#### Smoothing
This adjusts the Savitzky-Golay smoothing algorithm used, or allows it to be disabled entirely. The Smoothing Order allows the polynomial order to be adjusted, while the Smoothing Frame adjusts the frame length of the algorithm. In this panel there is also the option to remove the red hydrogen line showing the exact frequency of neutral hydrogen.

#### Figure saving
Here, figures can be saved to any folder you set. To avoid overwriting files, al filenames will have the current time appending to them. For example, if you enter `figure` in the textbox, it will be saved as `figure1234.png` in the directory you set. (Assuming it is 12:34pm)

#### Hardware Check
By default, a check is done to ensure that the RTL-SDR is still connected. However, on some devices this drastically reduces the performance. Choosing to bypass the hardware check will increase the speed however if the app **will** crash if the RTL-SDR is removed. *It will probably crash if the RTL-SDR is removed and the bypass option isn't selected, but it isn't supposed to.*

## INSTALLER DOWNLOADS
macOS (1.1): [HLDInstaller_macOS.zip](https://github.com/user-attachments/files/32156451/HLDInstaller_macOS.zip)

Windows (1.0): [InstallerWindows.zip](https://github.com/user-attachments/files/32156481/InstallerWindows.zip)

## Troubleshooting
### LNA not working:
If the LED on the LNA is not on:
1. Check the small red LED on the side of the RTL-SDR is on. For the V4, this will be near the input connected (the side not connected to the laptop). If this is ON, then the issue is between the RTL-SDR and the LNA (step 2). If off, then there is no power being sent to the LNA (step 3).
2. Check the LNA is connected correctly. The input side should be connected to the wok, and the output should be connected to the RTL-SDR. If this is the case, check all wires are securely connected.
3. If no power is being sent to the LNA, then a bias T option needs to be switched on. Using a dedicated radio receiving app, such as sdr++, this option can be manually switched on. Close this app. and open sdr++ or alternatives. Select the device, and switch on bias T. The red and white LEDs should turn on. After this, close sdr++ before opening this app, and the LNA will remain powered.
