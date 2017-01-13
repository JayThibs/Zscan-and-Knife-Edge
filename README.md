# Zscan-and-Knife-Edge
Contains a Labview program to build your own Z-Scan setup as well as Matlab code making it possible to analyse the data and obtain transmittance and Reflectance plots. In order to test the calibration of your setup and it is also possible to calculate the non-linear coeffecient β of a well-known material such as ZnSe.  It also contains a function to calculate the half-width of the beam at different positions (Knife-Edge method).

The LabView program is called "z-scan.vi". The z-scan setup that I have built has a transmission detector, a reflection detector and a reference detector. It also has 2 motorized translation stages to move in the propagation axis (z) and in the horizontal-perpendicular axis (x). This allows the user perform a z-scan when moving along the z-scan axis and either change the position of the beam on the sample or perform a knife-edge method measurement when moving along the x-axis.

For my measurements, I have not used a closed aperture setup in order to study the Kerr nonlinearity, but it is still very much possible to use the same code for that particular setup.

I'm still working on making the matlab code as general as possible in order to let anyone use it. I will be updating soon.

Here's my setup (French version for now):

![Image of Z-Scan Setup](https://github.com/JayThibs/Zscan-and-Knife-Edge/blob/master/Z-scan/Z-scan%20setup.png)

The LabView interface looks like:

![Image of LabView Z-Scan Interface](https://github.com/JayThibs/Zscan-and-Knife-Edge/blob/master/Z-scan/LabViewZScanInterface.png)

The LabView block diagram looks like:

![Image of LabView Z-Scan Block Diagram](https://github.com/JayThibs/Zscan-and-Knife-Edge/blob/master/Z-scan/LbaViewZScanBlockDiagram.png)
