** 40 cascaded, 2 paralleled cells


** subcircuit:4.000000e+00A,unshaded
.SUBCKT CELL1 P M 
 I1 M Y DC 4.000000e+00
 D1 Y M diode1
 Rsh Y M 5.000000e+03
 Rs Y P 7.900000e-03
.MODEL diode1 D IS=1.000000e-06 N=1.500000e+00
.ENDS


** subcircuit:3.500000e+00A,unshaded
.SUBCKT CELL2 P M 
 I1 M Y DC 3.500000e+00
 D1 Y M diode1
 Rsh Y M 5.000000e+03
 Rs Y P 7.900000e-03
.MODEL diode1 D IS=1.000000e-06 N=1.500000e+00
.ENDS


** subcircuit:3.000000e+00A,unshaded
.SUBCKT CELL3 P M 
 I1 M Y DC 3.000000e+00
 D1 Y M diode1
 Rsh Y M 5.000000e+03
 Rs Y P 7.900000e-03
.MODEL diode1 D IS=1.000000e-06 N=1.500000e+00
.ENDS


** subcircuit:2.500000e+00A,unshaded
.SUBCKT CELL4 P M 
 I1 M Y DC 2.500000e+00
 D1 Y M diode1
 Rsh Y M 5.000000e+03
 Rs Y P 7.900000e-03
.MODEL diode1 D IS=1.000000e-06 N=1.500000e+00
.ENDS


** subcircuit:2.000000e+00A,unshaded
.SUBCKT CELL5 P M 
 I1 M Y DC 2.000000e+00
 D1 Y M diode1
 Rsh Y M 5.000000e+03
 Rs Y P 7.900000e-03
.MODEL diode1 D IS=1.000000e-06 N=1.500000e+00
.ENDS


 XU11 1 11 CELL3
 XU21 11 21 CELL3
 XU31 21 31 CELL3
 XU41 31 41 CELL3
 XU51 41 51 CELL3
 XU61 51 61 CELL3
 XU71 61 71 CELL3
 XU81 71 81 CELL3
 XU91 81 91 CELL4
 XU101 91 101 CELL1
 XU111 101 111 CELL1
 XU121 111 121 CELL1
 XU131 121 131 CELL1
 XU141 131 141 CELL1
 XU151 141 151 CELL1
 XU161 151 161 CELL4
 XU171 161 171 CELL1
 XU181 171 181 CELL4
 XU191 181 191 CELL4
 XU201 191 201 CELL4
 XU211 201 211 CELL4
 XU221 211 221 CELL4
 XU231 221 231 CELL4
 XU241 231 241 CELL4
 XU251 241 251 CELL5
 XU261 251 261 CELL5
 XU271 261 271 CELL5
 XU281 271 281 CELL5
 XU291 281 291 CELL5
 XU301 291 301 CELL5
 XU311 301 311 CELL5
 XU321 311 321 CELL2
 XU331 321 331 CELL2
 XU341 331 341 CELL2
 XU351 341 351 CELL2
 XU361 351 361 CELL2
 XU371 361 371 CELL2
 XU381 371 381 CELL2
 XU391 381 391 CELL5
 XU401 391 0 CELL5

 D_Bypass11 0 261  diode_b1

 D_Bypass21 261 131  diode_b1

 D_Bypass31 131 1  diode_b1
.MODEL diode_b1 D IS=1.000000e-05 N=1.000000e+00
 XU12 1 12 CELL3
 XU22 12 22 CELL3
 XU32 22 32 CELL3
 XU42 32 42 CELL3
 XU52 42 52 CELL3
 XU62 52 62 CELL3
 XU72 62 72 CELL3
 XU82 72 82 CELL3
 XU92 82 92 CELL4
 XU102 92 102 CELL1
 XU112 102 112 CELL1
 XU122 112 122 CELL1
 XU132 122 132 CELL1
 XU142 132 142 CELL1
 XU152 142 152 CELL1
 XU162 152 162 CELL1
 XU172 162 172 CELL1
 XU182 172 182 CELL1
 XU192 182 192 CELL4
 XU202 192 202 CELL4
 XU212 202 212 CELL4
 XU222 212 222 CELL4
 XU232 222 232 CELL4
 XU242 232 242 CELL4
 XU252 242 252 CELL5
 XU262 252 262 CELL5
 XU272 262 272 CELL5
 XU282 272 282 CELL5
 XU292 282 292 CELL5
 XU302 292 302 CELL5
 XU312 302 312 CELL5
 XU322 312 322 CELL2
 XU332 322 332 CELL2
 XU342 332 342 CELL2
 XU352 342 352 CELL2
 XU362 352 362 CELL2
 XU372 362 372 CELL2
 XU382 372 382 CELL2
 XU392 382 392 CELL2
 XU402 392 0 CELL2

 D_Bypass12 0 262  diode_b2

 D_Bypass22 262 132  diode_b2

 D_Bypass32 132 1  diode_b2
.MODEL diode_b2 D IS=1.000000e-05 N=1.000000e+00


 Vds 1 0
.DC Vds 0 60.000000 0.005
.PRINT V(1) I(Vds)
.end
