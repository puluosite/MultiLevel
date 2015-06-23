** Super Cell 1 Max Current

 I1 0 1_1 DC 8.000000
 D1 1_1 0 diode1
 D1_inv 0 1 diode2
 Rsh_1 1_1 0 4.425000e+04
 Rs_1 1_1 1 6.991500e-02
.MODEL diode1 D IS=1.180000e-06 N=2.655000e+01
.MODEL diode2 D IS=1.180000e-05 N=1.770000e+00


** Super Cell 2 Mid Current

 I2 1 2_1 DC 5.000000
 D2 2_1 1 diode3
 D2_inv 1 2 diode4
 Rsh_2 2_1 1 2.725000e+04
 Rs_2 2_1 2 4.305500e-02
.MODEL diode3 D IS=7.266667e-07 N=1.635000e+01
.MODEL diode4 D IS=7.266667e-06 N=1.090000e+00


** Super Cell 3 Min Current

 I3 2 3_1 DC 2.000000
 D3 3_1 2 diode5
 D3_inv 2 3 diode6
 Rsh_3 3_1 2 3.500000e+03
 Rs_3 3_1 3 5.530000e-03
.MODEL diode5 D IS=9.333333e-08 N=2.100000e+00
.MODEL diode6 D IS=9.333333e-07 N=1.400000e-01




 Vds 3 0
.DC Vds 0 30 0.005
.PRINT V(out) I(Vds)
.end
