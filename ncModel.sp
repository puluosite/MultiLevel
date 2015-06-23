** Super Cell 1 Max Current

 I1 0 1_1 DC 5.000000
 D1 1_1 0 diode1
 D1_inv 0 1 diode2
 Rsh_1 1_1 0 3.207611e+04
 Rs_1 1_1 1 5.068025e-02
.MODEL diode1 D IS=6.415222e-07 N=1.924567e+01
.MODEL diode2 D IS=6.415222e-06 N=9.622833e-01


** Super Cell 2 Mid Current

 I2 1 2_1 DC 4.000000
 D2 2_1 1 diode3
 D2_inv 1 2 diode4
 Rsh_2 2_1 1 3.560035e+04
 Rs_2 2_1 2 5.624855e-02
.MODEL diode3 D IS=7.120069e-07 N=2.136021e+01
.MODEL diode4 D IS=7.120069e-06 N=1.068010e+00


** Super Cell 3 Min Current

 I3 2 3_1 DC 4.000000
 D3 3_1 2 diode5
 D3_inv 2 3 diode6
 Rsh_3 3_1 2 3.232355e+04
 Rs_3 3_1 3 5.107120e-02
.MODEL diode5 D IS=6.464709e-07 N=1.939413e+01
.MODEL diode6 D IS=6.464709e-06 N=9.697064e-01




 Vds 3 0
.DC Vds 0 60.000000 0.005
.PRINT V(out) I(Vds)
.end
