** 30 cascaded, 4 paralleled cells


**First Colony Starts
I111_1 11_1 1_0 DC 4.000000e+00
D111_1 1_0 11_1 diode111_1
Rs111_1 1 1_0 9.480000e-02
Rsh111_1 1_0 11_1 6.000000e+04
.MODEL diode111_1 D IS=1.000000e-06 N=1.800000e+01

**it does not exit, short!
R11_111_2 11_1 11_2 1e-30

**it does not exit, short!
R11_211_3 11_2 11_3 1e-30

**it does not exit, short!
R11_311_4 11_3 11_4 1e-30

I11_411 11 11_4_0 DC 2.000000e+00
D11_411 11_4_0 11 diode11_411
Rs11_411 11_4 11_4_0 2.370000e-02
Rsh11_411 11_4_0 11 1.500000e+04
.MODEL diode11_411 D IS=1.000000e-06 N=4.500000e+00

.MODEL diode_bp111 D IS=1.000000e-05 N=1.000000e+00
D_Bypass111 11 1 diode_bp111

**Second Colony Starts
I1121_1 21_1 11_0 DC 4.000000e+00
D1121_1 11_0 21_1 diode1121_1
Rs1121_1 11 11_0 8.690000e-02
Rsh1121_1 11_0 21_1 5.500000e+04
.MODEL diode1121_1 D IS=1.000000e-06 N=1.650000e+01

I21_121_2 21_2 21_1_0 DC 3.500000e+00
D21_121_2 21_1_0 21_2 diode21_121_2
Rs21_121_2 21_1 21_1_0 7.900000e-03
Rsh21_121_2 21_1_0 21_2 5.000000e+03
.MODEL diode21_121_2 D IS=1.000000e-06 N=1.500000e+00

I21_221_3 21_3 21_2_0 DC 3.000000e+00
D21_221_3 21_2_0 21_3 diode21_221_3
Rs21_221_3 21_2 21_2_0 1.580000e-02
Rsh21_221_3 21_2_0 21_3 1.000000e+04
.MODEL diode21_221_3 D IS=1.000000e-06 N=3.000000e+00

**it does not exit, short!
R21_321_4 21_3 21_4 1e-30

I21_40 0 21_4_0 DC 2.000000e+00
D21_40 21_4_0 0 diode21_40
Rs21_40 21_4 21_4_0 7.900000e-03
Rsh21_40 21_4_0 0 5.000000e+03
.MODEL diode21_40 D IS=1.000000e-06 N=1.500000e+00

.MODEL diode_bp011 D IS=1.000000e-05 N=1.000000e+00
D_Bypass011 0 11 diode_bp011

**First Colony Starts
I112_1 12_1 1_0 DC 4.000000e+00
D112_1 1_0 12_1 diode112_1
Rs112_1 1 1_0 9.480000e-02
Rsh112_1 1_0 12_1 6.000000e+04
.MODEL diode112_1 D IS=1.000000e-06 N=1.800000e+01

**it does not exit, short!
R12_112_2 12_1 12_2 1e-30

**it does not exit, short!
R12_212_3 12_2 12_3 1e-30

I12_312_4 12_4 12_3_0 DC 2.500000e+00
D12_312_4 12_3_0 12_4 diode12_312_4
Rs12_312_4 12_3 12_3_0 7.900000e-03
Rsh12_312_4 12_3_0 12_4 5.000000e+03
.MODEL diode12_312_4 D IS=1.000000e-06 N=1.500000e+00

I12_412 12 12_4_0 DC 2.000000e+00
D12_412 12_4_0 12 diode12_412
Rs12_412 12_4 12_4_0 1.580000e-02
Rsh12_412 12_4_0 12 1.000000e+04
.MODEL diode12_412 D IS=1.000000e-06 N=3.000000e+00

.MODEL diode_bp121 D IS=1.000000e-05 N=1.000000e+00
D_Bypass121 12 1 diode_bp121

**Second Colony Starts
I1222_1 22_1 12_0 DC 4.000000e+00
D1222_1 12_0 22_1 diode1222_1
Rs1222_1 12 12_0 7.110000e-02
Rsh1222_1 12_0 22_1 4.500000e+04
.MODEL diode1222_1 D IS=1.000000e-06 N=1.350000e+01

I22_122_2 22_2 22_1_0 DC 3.500000e+00
D22_122_2 22_1_0 22_2 diode22_122_2
Rs22_122_2 22_1 22_1_0 2.370000e-02
Rsh22_122_2 22_1_0 22_2 1.500000e+04
.MODEL diode22_122_2 D IS=1.000000e-06 N=4.500000e+00

I22_222_3 22_3 22_2_0 DC 3.000000e+00
D22_222_3 22_2_0 22_3 diode22_222_3
Rs22_222_3 22_2 22_2_0 1.580000e-02
Rsh22_222_3 22_2_0 22_3 1.000000e+04
.MODEL diode22_222_3 D IS=1.000000e-06 N=3.000000e+00

**it does not exit, short!
R22_322_4 22_3 22_4 1e-30

I22_40 0 22_4_0 DC 2.000000e+00
D22_40 22_4_0 0 diode22_40
Rs22_40 22_4 22_4_0 7.900000e-03
Rsh22_40 22_4_0 0 5.000000e+03
.MODEL diode22_40 D IS=1.000000e-06 N=1.500000e+00

.MODEL diode_bp012 D IS=1.000000e-05 N=1.000000e+00
D_Bypass012 0 12 diode_bp012

**First Colony Starts
I113_1 13_1 1_0 DC 4.000000e+00
D113_1 1_0 13_1 diode113_1
Rs113_1 1 1_0 7.900000e-02
Rsh113_1 1_0 13_1 5.000000e+04
.MODEL diode113_1 D IS=1.000000e-06 N=1.500000e+01

I13_113_2 13_2 13_1_0 DC 3.500000e+00
D13_113_2 13_1_0 13_2 diode13_113_2
Rs13_113_2 13_1 13_1_0 7.900000e-03
Rsh13_113_2 13_1_0 13_2 5.000000e+03
.MODEL diode13_113_2 D IS=1.000000e-06 N=1.500000e+00

**it does not exit, short!
R13_213_3 13_2 13_3 1e-30

I13_313_4 13_4 13_3_0 DC 2.500000e+00
D13_313_4 13_3_0 13_4 diode13_313_4
Rs13_313_4 13_3 13_3_0 1.580000e-02
Rsh13_313_4 13_3_0 13_4 1.000000e+04
.MODEL diode13_313_4 D IS=1.000000e-06 N=3.000000e+00

I13_413 13 13_4_0 DC 2.000000e+00
D13_413 13_4_0 13 diode13_413
Rs13_413 13_4 13_4_0 1.580000e-02
Rsh13_413 13_4_0 13 1.000000e+04
.MODEL diode13_413 D IS=1.000000e-06 N=3.000000e+00

.MODEL diode_bp131 D IS=1.000000e-05 N=1.000000e+00
D_Bypass131 13 1 diode_bp131

**Second Colony Starts
I1323_1 23_1 13_0 DC 4.000000e+00
D1323_1 13_0 23_1 diode1323_1
Rs1323_1 13 13_0 7.110000e-02
Rsh1323_1 13_0 23_1 4.500000e+04
.MODEL diode1323_1 D IS=1.000000e-06 N=1.350000e+01

I23_123_2 23_2 23_1_0 DC 3.500000e+00
D23_123_2 23_1_0 23_2 diode23_123_2
Rs23_123_2 23_1 23_1_0 3.160000e-02
Rsh23_123_2 23_1_0 23_2 2.000000e+04
.MODEL diode23_123_2 D IS=1.000000e-06 N=6.000000e+00

I23_223_3 23_3 23_2_0 DC 3.000000e+00
D23_223_3 23_2_0 23_3 diode23_223_3
Rs23_223_3 23_2 23_2_0 7.900000e-03
Rsh23_223_3 23_2_0 23_3 5.000000e+03
.MODEL diode23_223_3 D IS=1.000000e-06 N=1.500000e+00

**it does not exit, short!
R23_323_4 23_3 23_4 1e-30

I23_40 0 23_4_0 DC 2.000000e+00
D23_40 23_4_0 0 diode23_40
Rs23_40 23_4 23_4_0 7.900000e-03
Rsh23_40 23_4_0 0 5.000000e+03
.MODEL diode23_40 D IS=1.000000e-06 N=1.500000e+00

.MODEL diode_bp013 D IS=1.000000e-05 N=1.000000e+00
D_Bypass013 0 13 diode_bp013

**First Colony Starts
I114_1 14_1 1_0 DC 4.000000e+00
D114_1 1_0 14_1 diode114_1
Rs114_1 1 1_0 8.690000e-02
Rsh114_1 1_0 14_1 5.500000e+04
.MODEL diode114_1 D IS=1.000000e-06 N=1.650000e+01

**it does not exit, short!
R14_114_2 14_1 14_2 1e-30

**it does not exit, short!
R14_214_3 14_2 14_3 1e-30

I14_314_4 14_4 14_3_0 DC 2.500000e+00
D14_314_4 14_3_0 14_4 diode14_314_4
Rs14_314_4 14_3 14_3_0 2.370000e-02
Rsh14_314_4 14_3_0 14_4 1.500000e+04
.MODEL diode14_314_4 D IS=1.000000e-06 N=4.500000e+00

I14_414 14 14_4_0 DC 2.000000e+00
D14_414 14_4_0 14 diode14_414
Rs14_414 14_4 14_4_0 7.900000e-03
Rsh14_414 14_4_0 14 5.000000e+03
.MODEL diode14_414 D IS=1.000000e-06 N=1.500000e+00

.MODEL diode_bp141 D IS=1.000000e-05 N=1.000000e+00
D_Bypass141 14 1 diode_bp141

**Second Colony Starts
I1424_1 24_1 14_0 DC 4.000000e+00
D1424_1 14_0 24_1 diode1424_1
Rs1424_1 14 14_0 7.900000e-02
Rsh1424_1 14_0 24_1 5.000000e+04
.MODEL diode1424_1 D IS=1.000000e-06 N=1.500000e+01

I24_124_2 24_2 24_1_0 DC 3.500000e+00
D24_124_2 24_1_0 24_2 diode24_124_2
Rs24_124_2 24_1 24_1_0 2.370000e-02
Rsh24_124_2 24_1_0 24_2 1.500000e+04
.MODEL diode24_124_2 D IS=1.000000e-06 N=4.500000e+00

I24_224_3 24_3 24_2_0 DC 3.000000e+00
D24_224_3 24_2_0 24_3 diode24_224_3
Rs24_224_3 24_2 24_2_0 7.900000e-03
Rsh24_224_3 24_2_0 24_3 5.000000e+03
.MODEL diode24_224_3 D IS=1.000000e-06 N=1.500000e+00

**it does not exit, short!
R24_324_4 24_3 24_4 1e-30

I24_40 0 24_4_0 DC 2.000000e+00
D24_40 24_4_0 0 diode24_40
Rs24_40 24_4 24_4_0 7.900000e-03
Rsh24_40 24_4_0 0 5.000000e+03
.MODEL diode24_40 D IS=1.000000e-06 N=1.500000e+00

.MODEL diode_bp014 D IS=1.000000e-05 N=1.000000e+00
D_Bypass014 0 14 diode_bp014



 Vds 1 0
.DC Vds 0 30.000000 0.005
.PRINT V(1) I(Vds)
.end
