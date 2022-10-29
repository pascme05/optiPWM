# Introduction
The following script calculates the current distortions on the machine
side, as well as the current- and voltage distortions on the DC-Link, for
a standard 3-phase machine with voltage soure inverter (B6-VSI).
Apart from that, fundamental losses for the IGBT are evaluated. The 
calculations are subsequent to the following papers [1], [2] and [3].
Additionally for the overmodulation region [4] and [5] are utilised.
The transformation between the triangle-carrier-method and the space-
vector approach is done accordingly to [6]
The following boundary conditions are set for the calculations:

- Valid for high switching frequencies $f_s >> f_el$
- Semiconductors are ideal (linear commutation)
- the machine is modelled as a pure inductive load

# Publication
When using the toolkit please cite the following paper:

Schirmer, P.A., Glose, D. & Ammann, U. Zero-voltage and frequency pattern selection for DC-link loss minimization in PWM-VSI drives. Electr Eng (2022). https://doi.org/10.1007/s00202-022-01627-z

The full text is available here:
https://www.researchgate.net/publication/364826204_Zero-voltage_and_frequency_pattern_selection_for_DC-link_loss_minimization_in_PWM-VSI_drives

# Dependencies
The BaseNILM optiPWM toolkit was implemented using the following dependencies:

- MATLAB 2021 R1

# Usage
To start the toolkit use start.m, the results will then be calculate in main.m.

# Results
Overview of the time- and frequency-domain for switching sequence 0127:
![time](https://user-images.githubusercontent.com/66561268/198819940-051d735e-f548-4198-9ddd-c9977ab82580.png)

Overview of the spatial distortions for switching sequence 0127:
![distortion](https://user-images.githubusercontent.com/66561268/198819968-65cb3911-cfa7-4307-9ff2-9d9b6bdc3ad1.png)

Overview of the frms distortions for switching sequence 0127:
![frmsDist](https://user-images.githubusercontent.com/66561268/198819983-c9b49292-5000-4a36-be7f-90a8f622cb25.png)

# Development
As failure and mistakes are inextricably linked to human nature, the toolkit is obviously not perfect, 
thus suggestions and constructive feedback are always welcome. If you want to contribute to the optiPWM 
toolkit or spotted any mistake, please contact me via: p.schirmer@herts.ac.uk

# License
The software framework is provided under the MIT license.

# Cite
Schirmer, P.A., Glose, D. & Ammann, U. Zero-voltage and frequency pattern selection for DC-link loss minimization in PWM-VSI drives. Electr Eng (2022). https://doi.org/10.1007/s00202-022-01627-z

# References
[1] Simple Analytical and Graphical Methods for Carrier-Based PWM-VSI
Drives, Ahmet M. Hava, Russel J. Kerkman, and Thomas A. Lipo, 
IEEE TRANSACTIONS ON POWER ELECTRONICS, VOL. 14, NO. 1, JANUARY 1999

[2] Space Vector PWM Control of Dual Three-phase Induction Machine Using
Vector Space Decomposition, Yifan Zhao, Thomas A. Lipo, IEEE TRANSACTIONS
ON INDUSTRY APPLICATIONS, VOL. 31, NO. 5, SEPTEMBER/OCTOBER 1995
 
[3] Analytical calculation of the RMS current stress on the DC-link 
capacitor of voltage-PWM converter systems, J.W. Kolar, and S.D. Round, 
IEE Proceedings - Electronic Power Applications, Vol. 153, No. 4, 
July 2006

[4] J. Holtz, W. Lotzkat, and A. M. Khambadkone. “On continuous control 
of PWM inverters in the overmodulation range including the six-step mode”.
In: IEEE Transactions on Power Electronics 8.4 (1993),
pp. 546–553. ISSN: 0885-8993.

[5] Khanh NGUYEN THAC. “A SIMPLE WIDE RANGE SPACE VECTORPWM
A SIMPLE WIDE RANGE SPACE VECTOR PWM CONTROLLER ALGORITHM
FOR VOLTAGE-FED INVERTER INDUCTION MOTOR DRIVE INCLUDING
SIX-STEP MODE”.

[6] Felix Jenni, Dieter Wüest 1. Auflage 1995; 368 Seiten, Format 16 x 23 cm, broschiert mit 
zahlreichen grafischen Darstellungen, ISBN 978-3-7281-2141-7
