.title adder32bits

.protect
.inc 'ptm90.l'
.unprotect

.global VDD VSS
VVdd VDD 0 dc 1
VVss VSS 0 dc 0
.param WN=0.2u
.param WP=0.36u
.param LB=90n

.subckt INV in out
Mp1 vdd in out vdd pmos w=WP l=LB m=1
Mn1 vss in out vss nmos w=WN l=LB m=1
.ends

.subckt BUF in out
Mp1 vdd in tmp vdd pmos w=WP l=LB m=1
Mn1 vss in tmp vss nmos w=WN l=LB m=1
Mp2 vdd tmp out vdd pmos w=2.7*WP l=LB m=1
Mn2 vss tmp out vss nmos w=2.7*WN l=LB m=1
.ends

.subckt AND A B out
MP1 NET1 a vdd vdd pmos W=WP L=LB
MN1 NET1 a gnd gnd nmos W=WN L=LB
MN2 out NET1 gnd gnd nmos W=WN L=LB
MP3 out NET1 b vdd pmos W=WP L=LB
MN3 out a b gnd nmos W=WN L=LB
.ends

**transmission gate: sw=1 open**
.subckt TG sw _sw in out
Mp1 out _sw in vdd  pmos w=WP l=LB
Mn1 out sw in vss nmos w=WN l=LB
.ends

.subckt OR A B out
MP1 NET1 A vdd vdd pmos W=WP L=LB
MN1 NET1 A gnd gnd nmos W=WN L=LB
MP2 out NET1 vdd vdd pmos W=WP L=LB
MP3 out A B vdd pmos W=WP L=LB
MN3 out NET1 B gnd nmos W=WN L=LB
.ends

.subckt XOR A B out
XINV1 A _A INV
XINV2 B _B INV
XTG1 _B B A out TG
XTG2 B _B _A out TG
.ends

**carry propagate = A XOR B**
.subckt P A B out
XXOR1 A B out XOR
.ends

**carry generate = A AND B**
.subckt G A B out
XAND1 A B out AND
.ends

.subckt HA A B S Co
XXOR1 A B S XOR
XAND1 A B Co AND
.ends

.subckt DHA A B S0 S1 Co0 Co1
XHA1 A B S0 Co0 HA
XINV1 S0 S1 INV
XOR1 A B Co1 OR
.ends

.subckt FA A B Ci S Co
XP1 A B P1 P
XG1 A B G1 G
XOR1 G1 PCi Co OR
XAND1 P1 Ci PCi AND
XXOR1 P1 Ci S XOR
.ends

.subckt MUX D1 D2 ctrl out
XINV1 ctrl _ctrl INV
XTG1 ctrl _ctrl D2 out TG
XTG2 _ctrl ctrl D1 out TG
.ends

.subckt x2MUX S10 S11 C10 C11 ctrl So Co
XMUX0 S10 S11 ctrl So MUX
XMUX1 C10 C11 ctrl Co MUX
.ends

.subckt x3MUX S10 S11 S20 S21 C0 C1 ctrl So1 So2 Co
XMUX0 S10 S11 ctrl So1 MUX
XMUX1 S20 S21 ctrl So2 MUX
XMUX3 C0 C1 ctrl Ctmp MUX
XBUF1 Ctmp Co BUF
.ends

.subckt x5MUX S10 S11 S20 S21 S30 S31 S40 S41 C0 C1 ctrl So1 So2 So3 So4 Co
XMUX0 S10 S11 ctrl So1 MUX
XMUX1 S20 S21 ctrl So2 MUX
XMUX2 S30 S31 ctrl So3 MUX
XMUX3 S40 S41 ctrl So4 MUX
XMUX4 C0 C1 ctrl Co MUX
.ends

.subckt ADD8bits X0 X1 X2 X3 X4 X5 X6 X7 Y0 Y1 Y2 Y3 Y4 Y5 Y6 Y7 S0 S1 S2 S3 S4 S5 S6 S7 Cin Cout
XFA0 X0 Y0 Cin S0 C1 FA
XDHA1 X1 Y1 S10 S11 C20 C21 DHA
XDHA2 X2 Y2 S20 S21 C30 C31 DHA
XDHA3 X3 Y3 S30 S31 C40 C41 DHA
XDHA4 X4 Y4 S40 S41 C50 C51 DHA
XDHA5 X5 Y5 S50 S51 C60 C61 DHA
XDHA6 X6 Y6 S60 S61 C70 C71 DHA
XDHA7 X7 Y7 S70 S71 C80 C81 DHA

Xx2MUX_C1 S10 S11 C20 C21 C1 S1 C2 x2MUX	**MUX is named by ctrl value
Xx2MUX_C30 S30 S31 C40 C41 C30 S30_MC30 C40_MC30 x2MUX
Xx2MUX_C31 S30 S31 C40 C41 C31 S31_MC31 C41_MC31 x2MUX
Xx3MUX_C2 S20 S21 S30_MC30 S31_MC31 C40_MC30 C41_MC31 C2 S2 S3 C4 x3MUX
Xx2MUX_C50 S50 S51 C60 C61 C50 S50_MC50 C60_MC50 x2MUX
Xx2MUX_C51 S50 S51 C60 C61 C51 S51_MC51 C61_MC51 x2MUX
Xx3MUX_C60_MC50 S60 S61 S70_MC70 S71_MC71 C80_MC70 C81_MC71 C60_MC50 S60_MC60 S70_MC60 C80_MC60 x3MUX
Xx2MUX_C70 S70 S71 C80 C81 C70 S70_MC70 C80_MC70 x2MUX
Xx2MUX_C71 S70 S71 C80 C81 C71 S71_MC71 C81_MC71 x2MUX
Xx3MUX_C61_MC51 S60 S61 S70_MC70 S71_MC71 C80_MC70 C81_MC71 C61_MC51 S61_MC61 S71_MC61 C81_MC61 x3MUX
Xx5MUX_C4 S40 S41 S50_MC50 S51_MC51 S60_MC60 S61_MC61 S70_MC60 S71_MC61 C80_MC60 C81_MC61 C4 S4 S5 S6 S7 Cout x5MUX
.ends

.subckt ADD32bits X0 X1 X2 X3 X4 X5 X6 X7 X8 X9 X10 X11 X12 X13 X14 X15 X16 X17 X18 X19 X20 X21 X22 X23 X24 X25 X26 X27 X28 X29 X30 X31 Y0 Y1 Y2 Y3 Y4 Y5 Y6 Y7 Y8 Y9 Y10 Y11 Y12 Y13 Y14 Y15 Y16 Y17 Y18 Y19 Y20 Y21 Y22 Y23 Y24 Y25 Y26 Y27 Y28 Y29 Y30 Y31 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 Cin Cout
XADD8bits1 X0 X1 X2 X3 X4 X5 X6 X7 Y0 Y1 Y2 Y3 Y4 Y5 Y6 Y7 S0 S1 S2 S3 S4 S5 S6 S7 Cin C8 ADD8bits
XADD8bits2 X8 X9 X10 X11 X12 X13 X14 X15 Y8 Y9 Y10 Y11 Y12 Y13 Y14 Y15 S8 S9 S10 S11 S12 S13 S14 S15 C8 C16 ADD8bits
XADD8bits3 X16 X17 X18 X19 X20 X21 X22 X23 Y16 Y17 Y18 Y19 Y20 Y21 Y22 Y23 S16 S17 S18 S19 S20 S21 S22 S23 C16 C24 ADD8bits
XADD8bits4 X24 X25 X26 X27 X28 X29 X30 X31 Y24 Y25 Y26 Y27 Y28 Y29 Y30 Y31 S24 S25 S26 S27 S28 S29 S30 S31 C24 Cout ADD8bits
.ends

******************signal*********************
VA0 A0 VSS pulse(0V 1V 0.5n 50p 50p 6n 10n)
VA1 A1 0 dc 0
VA2 A2 0 dc 0
VA3 A3 0 dc 0
VA4 A4 0 dc 0
VA5 A5 0 dc 0
VA6 A6 0 dc 0
VA7 A7 0 dc 0
VA8 A8 0 dc 0
VA9 A9 0 dc 0
VA10 A10 0 dc 0
VA11 A11 0 dc 0
VA12 A12 0 dc 0
VA13 A13 0 dc 0
VA14 A14 0 dc 0
VA15 A15 0 dc 0
VA16 A16 0 dc 0
VA17 A17 0 dc 0
VA18 A18 0 dc 0
VA19 A19 0 dc 0
VA20 A20 0 dc 0
VA21 A21 0 dc 0
VA22 A22 0 dc 0
VA23 A23 0 dc 0
VA24 A24 0 dc 0
VA25 A25 0 dc 0
VA26 A26 0 dc 0
VA27 A27 0 dc 0
VA28 A28 0 dc 0
VA29 A29 0 dc 0
VA30 A30 0 dc 0
VA31 A31 0 dc 0

VB0 B0 0 dc 1
VB1 B1 0 dc 1
VB2 B2 0 dc 1
VB3 B3 0 dc 1
VB4 B4 0 dc 1
VB5 B5 0 dc 1
VB6 B6 0 dc 1
VB7 B7 0 dc 1
VB8 B8 0 dc 1
VB9 B9 0 dc 1
VB10 B10 0 dc 1
VB11 B11 0 dc 1
VB12 B12 0 dc 1
VB13 B13 0 dc 1
VB14 B14 0 dc 1
VB15 B15 0 dc 1
VB16 B16 0 dc 1
VB17 B17 0 dc 1
VB18 B18 0 dc 1
VB19 B19 0 dc 1
VB20 B20 0 dc 1
VB21 B21 0 dc 1
VB22 B22 0 dc 1
VB23 B23 0 dc 1
VB24 B24 0 dc 1
VB25 B25 0 dc 1
VB26 B26 0 dc 1
VB27 B27 0 dc 1
VB28 B28 0 dc 1
VB29 B29 0 dc 1
VB30 B30 0 dc 1
VB31 B31 0 dc 0

VCi Ci 0 dc 0
*********************************************


*******************main**********************

XADD A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 A10 A11 A12 A13 A14 A15 A16 A17 A18 A19 A20 A21 A22 A23 A24 A25 A26 A27 A28 A29 A30 A31 B0 B1 B2 B3 B4 B5 B6 B7 B8 B9 B10 B11 B12 B13 B14 B15 B16 B17 B18 B19 B20 B21 B22 B23 B24 B25 B26 B27 B28 B29 B30 B31 S0 S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11 S12 S13 S14 S15 S16 S17 S18 S19 S20 S21 S22 S23 S24 S25 S26 S27 S28 S29 S30 S31 Ci C32 ADD32bits

Cc0 S0 VSS 10fF
Cc1 S1 VSS 10fF
Cc2 S2 VSS 10fF
Cc3 S3 VSS 10fF
Cc4 S4 VSS 10fF
Cc5 S5 VSS 10fF
Cc6 S6 VSS 10fF
Cc7 S7 VSS 10fF
Cc8 S8 VSS 10fF
Cc9 S9 VSS 10fF
Cc10 S10 VSS 10fF
Cc11 S11 VSS 10fF
Cc12 S12 VSS 10fF
Cc13 S13 VSS 10fF
Cc14 S14 VSS 10fF
Cc15 S15 VSS 10fF
Cc16 S16 VSS 10fF
Cc17 S17 VSS 10fF
Cc18 S18 VSS 10fF
Cc19 S19 VSS 10fF
Cc20 S20 VSS 10fF
Cc21 S21 VSS 10fF
Cc22 S22 VSS 10fF
Cc23 S23 VSS 10fF
Cc24 S24 VSS 10fF
Cc25 S25 VSS 10fF
Cc26 S26 VSS 10fF
Cc27 S27 VSS 10fF
Cc28 S28 VSS 10fF
Cc29 S29 VSS 10fF
Cc30 S30 VSS 10fF
Cc31 S31 VSS 10fF

*********************************************

.op
.temp 27
.tran 25p 10n
.probe v(vout)
.option post=3

.meas tran T1 when V(A0)=0.5 rise=1
.meas tran T2 when V(S31)=0.5 rise=1
.meas Td param="T2-T1"
.meas tran power avg p(XADD) from T1 to T2

.end