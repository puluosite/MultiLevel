** 60 cascaded, 2 paralleled cells


**First Colony Starts
I111_1 11_1 1_0 DC 4.000000e+00
D111_1 1_0 11_1 diode111_1
Rs111_1 1 1_0 7.900000e-02
Rsh111_1 1_0 11_1 5.000000e+03
.MODEL diode111_1 D IS=1.000000e-06 N=1.500000e+01

**it does not exit, short!
R11_111_2 11_1 11_2 1e-30

**it does not exit, short!
R11_211_3 11_2 11_3 1e-30

**it does not exit, short!
R11_311_4 11_3 11_4 1e-30

I11_411 11 11_4_0 DC 2.000000e+00
D11_411 11_4_0 11 diode11_411
Rs11_411 11_4 11_4_0 7.900000e-02
Rsh11_411 11_4_0 11 5.000000e+03
.MODEL diode11_411 D IS=1.000000e-06 N=1.500000e+01

.MODEL diode_bp111 D IS=1.000000e-05 N=1.000000e+00
D_Bypass111 11 1 diode_bp111

**Second Colony Starts
I1121_1 21_1 11_0 DC 4.000000e+00
D1121_1 11_0 21_1 diode1121_1
Rs1121_1 11 11_0 1.580000e-01
Rsh1121_1 11_0 21_1 5.000000e+03
.MODEL diode1121_1 D IS=1.000000e-06 N=3.000000e+01

**it does not exit, short!
R21_121_2 21_1 21_2 1e-30

**it does not exit, short!
R21_221_3 21_2 21_3 1e-30

**it does not exit, short!
R21_321_4 21_3 21_4 1e-30

**it does not exit, short!
R21_421 21_4 21 1e-30

.MODEL diode_bp2111 D IS=1.000000e-05 N=1.000000e+00
D_Bypass2111 21 11 diode_bp2111

**Third Colony Starts
I2131_1 31_1 21_0 DC 4.000000e+00
D2131_1 21_0 31_1 diode2131_1
Rs2131_1 21 21_0 1.580000e-01
Rsh2131_1 21_0 31_1 5.000000e+03
.MODEL diode2131_1 D IS=1.000000e-06 N=3.000000e+01

**it does not exit, short!
R31_131_2 31_1 31_2 1e-30

**it does not exit, short!
R31_231_3 31_2 31_3 1e-30

**it does not exit, short!
R31_331_4 31_3 31_4 1e-30

**it does not exit, short!
R31_40 31_4 0 1e-30

.MODEL diode_bp021 D IS=1.000000e-05 N=1.000000e+00
D_Bypass021 0 21 diode_bp021

**First Colony Starts
I112_1 12_1 1_0 DC 4.000000e+00
D112_1 1_0 12_1 diode112_1
Rs112_1 1 1_0 9.480000e-02
Rsh112_1 1_0 12_1 5.000000e+03
.MODEL diode112_1 D IS=1.000000e-06 N=1.800000e+01

**it does not exit, short!
R12_112_2 12_1 12_2 1e-30

**it does not exit, short!
R12_212_3 12_2 12_3 1e-30

**it does not exit, short!
R12_312_4 12_3 12_4 1e-30

I12_412 12 12_4_0 DC 2.000000e+00
D12_412 12_4_0 12 diode12_412
Rs12_412 12_4 12_4_0 6.320000e-02
Rsh12_412 12_4_0 12 5.000000e+03
.MODEL diode12_412 D IS=1.000000e-06 N=1.200000e+01

.MODEL diode_bp121 D IS=1.000000e-05 N=1.000000e+00
D_Bypass121 12 1 diode_bp121

**Second Colony Starts
I1222_1 22_1 12_0 DC 4.000000e+00
D1222_1 12_0 22_1 diode1222_1
Rs1222_1 12 12_0 1.580000e-01
Rsh1222_1 12_0 22_1 5.000000e+03
.MODEL diode1222_1 D IS=1.000000e-06 N=3.000000e+01

**it does not exit, short!
R22_122_2 22_1 22_2 1e-30

**it does not exit, short!
R22_222_3 22_2 22_3 1e-30

**it does not exit, short!
R22_322_4 22_3 22_4 1e-30

**it does not exit, short!
R22_422 22_4 22 1e-30

.MODEL diode_bp2212 D IS=1.000000e-05 N=1.000000e+00
D_Bypass2212 22 12 diode_bp2212

**Third Colony Starts
I2232_1 32_1 22_0 DC 4.000000e+00
D2232_1 22_0 32_1 diode2232_1
Rs2232_1 22 22_0 1.501000e-01
Rsh2232_1 22_0 32_1 5.000000e+03
.MODEL diode2232_1 D IS=1.000000e-06 N=2.850000e+01

**it does not exit, short!
R32_132_2 32_1 32_2 1e-30

I32_232_3 32_3 32_2_0 DC 3.000000e+00
D32_232_3 32_2_0 32_3 diode32_232_3
Rs32_232_3 32_2 32_2_0 7.900000e-03
Rsh32_232_3 32_2_0 32_3 5.000000e+03
.MODEL diode32_232_3 D IS=1.000000e-06 N=1.500000e+00

**it does not exit, short!
R32_332_4 32_3 32_4 1e-30

**it does not exit, short!
R32_40 32_4 0 1e-30

.MODEL diode_bp022 D IS=1.000000e-05 N=1.000000e+00
D_Bypass022 0 22 diode_bp022



 Vds 1 0
.DC Vds 0 60.000000 0.005
.PRINT V(1) I(Vds)
.end
