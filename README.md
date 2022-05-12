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

# Dependencies
The BaseNILM Toolkit was implemented using the following dependencies:
- Python 3.8
- Tensorflow 2.5.0
- Keras 2.4.3

For GPU based calculations CUDA in combination with cuDNN has been used, 
utilizing the Nvidia RTX 3000 series for calculation. 
The following versions have been tested and proven to work with the BaseNILM toolkit:
- CUDA 11.4
- DNN 8.2.4
- Driver 472.39

# Usage


# Results

# Development
As failure and mistakes are inextricably linked to human nature, the toolkit is obviously not perfect, 
thus suggestions and constructive feedback are always welcome. If you want to contribute to the optiPWM 
toolkit or spotted any mistake, please contact me via: p.schirmer@herts.ac.uk

# License
The software framework is provided under the MIT license.

# Cite

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

[6] Felix Jenni, Dieter Wüest
1. Auflage 1995; 368 Seiten, Format 16 x 23 cm, broschiert mit 
zahlreichen grafischen Darstellungen, ISBN 978-3-7281-2141-7
