** Super Cell 1 Max Current

 I1 0 P_1 DC 4.000000
 D1 P_1 0 diode1
 D1_inv 0 M diode2
 Rsh_1 P_1 0 9.400000e+04
 Rs_1 P_1 M 1.485200e-01
.MODEL diode1 D IS=1.880000e-06 N=5.640000e+01
.MODEL diode2 D IS=1.880000e-05 N=1.880000e+00


**  Super Cell 2 Min Current

 I2 M P_2 DC 4.000000
 D2 P_2 M diode3
 D2_inv M out diode4
 Rsh_2 M P_2 6.000000e+03
 Rs_2 P_2 out 9.480000e-03
.MODEL diode3 D IS=1.200000e-07 N=3.600000e+00
.MODEL diode4 D IS=1.200000e-06 N=1.200000e-01




 Vds out 0
.DC Vds 0 60.000000 0.005
.PRINT V(out) I(Vds)
.end
