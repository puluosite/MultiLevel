** Super Cell 1 Max Current

 I1 0 1_1 DC 6.000000
 D1 1_1 0 diode1
 D1_inv 0 1 diode2
 Rsh_1 1_1 0 4.200933e+04
 Rs_1 1_1 1 6.637475e-02
.MODEL diode1 D IS=5.601245e-07 N=2.520560e+01
.MODEL diode2 D IS=5.601245e-06 N=8.401867e-01


** Super Cell 2 Mid Current

 I2 1 2_1 DC 5.000000
 D2 2_1 1 diode3
 D2_inv 1 2 diode4
 Rsh_2 2_1 1 4.717531e+04
 Rs_2 2_1 2 7.453699e-02
.MODEL diode3 D IS=6.290041e-07 N=2.830518e+01
.MODEL diode4 D IS=6.290041e-06 N=9.435061e-01


** Super Cell 3 Min Current

 I3 2 3_1 DC 4.000000
 D3 3_1 2 diode5
 D3_inv 2 3 diode6
 Rsh_3 3_1 2 6.081536e+04
 Rs_3 3_1 3 9.608827e-02
.MODEL diode5 D IS=8.108714e-07 N=3.648922e+01
.MODEL diode6 D IS=8.108714e-06 N=1.216307e+00




 Vds 3 0
.DC Vds 0 60.000000 0.005
.PRINT V(out) I(Vds)
.end
