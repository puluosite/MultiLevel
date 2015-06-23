** 40 cascaded, 2 paralleled cells


**First Colony Starts
I111_1 11_1 1_0 DC 4.000000e+00
D111_1 1_0 11_1 diode111_1
Rs111_1 1 1_0 3.160000e-02
Rsh111_1 1_0 11_1 5.000000e+03
.MODEL diode111_1 D IS=1.000000e-06 N=6.000000e+00

**it does not exit, short!
R11_111_2 11_1 11_2 1e-30

**it does not exit, short!
R11_211_3 11_2 11_3 1e-30

I11_311_4 11_4 11_3_0 DC 2.500000e+00
D11_311_4 11_3_0 11_4 diode11_311_4
Rs11_311_4 11_3 11_3_0 7.110000e-02
Rsh11_311_4 11_3_0 11_4 5.000000e+03
.MODEL diode11_311_4 D IS=1.000000e-06 N=1.350000e+01

**it does not exit, short!
R11_411 11_4 11 1e-30

.MODEL diode_bp111 D IS=1.000000e-05 N=1.000000e+00
D_Bypass111 11 1 diode_bp111

**Second Colony Starts
I1121_1 21_1 11_0 DC 4.000000e+00
D1121_1 11_0 21_1 diode1121_1
Rs1121_1 11 11_0 2.370000e-02
Rsh1121_1 11_0 21_1 5.000000e+03
.MODEL diode1121_1 D IS=1.000000e-06 N=4.500000e+00

**it does not exit, short!
R21_121_2 21_1 21_2 1e-30

**it does not exit, short!
R21_221_3 21_2 21_3 1e-30

**it does not exit, short!
R21_321_4 21_3 21_4 1e-30

I21_421 21 21_4_0 DC 2.000000e+00
D21_421 21_4_0 21 diode21_421
Rs21_421 21_4 21_4_0 7.900000e-02
Rsh21_421 21_4_0 21 5.000000e+03
.MODEL diode21_421 D IS=1.000000e-06 N=1.500000e+01

.MODEL diode_bp2111 D IS=1.000000e-05 N=1.000000e+00
D_Bypass2111 21 11 diode_bp2111

**Third Colony Starts
**it does not exit, short!
R2131_1 21 31_1 1e-30

I31_131_2 31_2 31_1_0 DC 3.500000e+00
D31_131_2 31_1_0 31_2 diode31_131_2
Rs31_131_2 31_1 31_1_0 5.530000e-02
Rsh31_131_2 31_1_0 31_2 5.000000e+03
.MODEL diode31_131_2 D IS=1.000000e-06 N=1.050000e+01

**it does not exit, short!
R31_231_3 31_2 31_3 1e-30

**it does not exit, short!
R31_331_4 31_3 31_4 1e-30

I31_40 0 31_4_0 DC 2.000000e+00
D31_40 31_4_0 0 diode31_40
Rs31_40 31_4 31_4_0 5.530000e-02
Rsh31_40 31_4_0 0 5.000000e+03
.MODEL diode31_40 D IS=1.000000e-06 N=1.050000e+01

.MODEL diode_bp021 D IS=1.000000e-05 N=1.000000e+00
D_Bypass021 0 21 diode_bp021

**First Colony Starts
I112_1 12_1 1_0 DC 4.000000e+00
D112_1 1_0 12_1 diode112_1
Rs112_1 1 1_0 3.160000e-02
Rsh112_1 1_0 12_1 5.000000e+03
.MODEL diode112_1 D IS=1.000000e-06 N=6.000000e+00

**it does not exit, short!
R12_112_2 12_1 12_2 1e-30

**it does not exit, short!
R12_212_3 12_2 12_3 1e-30

I12_312_4 12_4 12_3_0 DC 2.500000e+00
D12_312_4 12_3_0 12_4 diode12_312_4
Rs12_312_4 12_3 12_3_0 7.110000e-02
Rsh12_312_4 12_3_0 12_4 5.000000e+03
.MODEL diode12_312_4 D IS=1.000000e-06 N=1.350000e+01

**it does not exit, short!
R12_412 12_4 12 1e-30

.MODEL diode_bp121 D IS=1.000000e-05 N=1.000000e+00
D_Bypass121 12 1 diode_bp121

**Second Colony Starts
I1222_1 22_1 12_0 DC 4.000000e+00
D1222_1 12_0 22_1 diode1222_1
Rs1222_1 12 12_0 3.950000e-02
Rsh1222_1 12_0 22_1 5.000000e+03
.MODEL diode1222_1 D IS=1.000000e-06 N=7.500000e+00

**it does not exit, short!
R22_122_2 22_1 22_2 1e-30

**it does not exit, short!
R22_222_3 22_2 22_3 1e-30

**it does not exit, short!
R22_322_4 22_3 22_4 1e-30

I22_422 22 22_4_0 DC 2.000000e+00
D22_422 22_4_0 22 diode22_422
Rs22_422 22_4 22_4_0 6.320000e-02
Rsh22_422 22_4_0 22 5.000000e+03
.MODEL diode22_422 D IS=1.000000e-06 N=1.200000e+01

.MODEL diode_bp2212 D IS=1.000000e-05 N=1.000000e+00
D_Bypass2212 22 12 diode_bp2212

**Third Colony Starts
**it does not exit, short!
R2232_1 22 32_1 1e-30

I32_132_2 32_2 32_1_0 DC 3.500000e+00
D32_132_2 32_1_0 32_2 diode32_132_2
Rs32_132_2 32_1 32_1_0 7.110000e-02
Rsh32_132_2 32_1_0 32_2 5.000000e+03
.MODEL diode32_132_2 D IS=1.000000e-06 N=1.350000e+01

**it does not exit, short!
R32_232_3 32_2 32_3 1e-30

**it does not exit, short!
R32_332_4 32_3 32_4 1e-30

I32_40 0 32_4_0 DC 2.000000e+00
D32_40 32_4_0 0 diode32_40
Rs32_40 32_4 32_4_0 3.950000e-02
Rsh32_40 32_4_0 0 5.000000e+03
.MODEL diode32_40 D IS=1.000000e-06 N=7.500000e+00

.MODEL diode_bp022 D IS=1.000000e-05 N=1.000000e+00
D_Bypass022 0 22 diode_bp022



 Vds 1 0
.DC Vds 0 60.000000 0.005
.PRINT V(1) I(Vds)
.end
