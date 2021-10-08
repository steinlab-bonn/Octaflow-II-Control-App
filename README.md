# Octaflow II Control App V1.0
by Michael Rabenstein (October 2021)
DOI: https://doi.org/10.5281/zenodo.5556799

About:
The Octaflow II Control App is a user written alternative to the official control software.  
Therefore, the usage is at your own risk.  
It is written and tested using MATLAB R2021b on a PC using Windows 10 (64 bit) as operating system.  
Octaflow II ™ is a trademark of ALA Scientific Instruments, Inc., Farmingdale, NY, USA.  
Usage of the compiled app is only allowed with the Octaflow II™ system or other devices with Cypress controllers.  

This repository provides the app in two forms:  
•	The Matlab code folder contains the code as App Designer file and as exported M-file  
•	The OctaflowIIControlApp folder contains the compiled app with its manual  
Please respect the different licenses for the different forms 

System requirements:  
•	Windows 10 (64 bit) (.NET Framework 4.0 or newer necessary)  
•	MATLAB Runtime v. 9.11 from The MathWorks, Inc. System requirements available at www.mathworks.com)  
•	Octaflow II Software Version 3.0.1.0 64 bit from ALA Scientific Instruments, Inc. installed to get the necessary drivers  
•	CyUSB.dll v. 1.2.3.0 from the Cypress Semiconductor Corp., San Jose, CA, USA. (included in the compiled app, otherwise part of the EZ-USB FX3 Software Development Kit 1.3.4 (https://www.cypress.com/documentation/software-and-drivers/ez-usb-fx3-software-development-kit, last acess 04/13/2021))

Acknowledgments:   
I thank Prof. Valentin Stein and Ulf Einsfelder from the Institute for Physiology II of the University of Bonn for their help in designing the app and Andy Pomerantz from ALA Scientific Instruments, Inc. for providing the program’s base code.  
Connection to device via CyUSB.dll adapted from code provided by anonymous user on the Feb 19, 2015 04:41 AM at https://community.cypress.com/t5/USB-Low-Full-High-Speed/CyUSB-dll-in-MATLAB-problems-at-indexing-a-device-list/m-p/58551 (last access 04/13/2021).  

