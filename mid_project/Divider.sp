.title divider

.protect
.inc 'ptm90.l'
.unprotect

.global VDD VSS
VVdd VDD 0 dc 1
VVss VSS 0 dc 0

.subckt Inv in out
Mp1 out in vdd vdd pmos w=0.36u l=90n m=1
Mn1 out in vss vss nmos w=0.2u l=90n m=1
.ends

*CLK=1 open, CLK=0 close
.subckt TG CLK _CLK in out
Mp1 out _CLK in vdd  pmos w=0.36u l=90n
Mn1 out CLK in vss nmos w=0.2u l=90n
.ends

.subckt Latch CLK _CLK data out _out
XTG1 _CLK CLK data w1 TG
XInv1 w1 _out Inv
XInv2 _out out Inv
XTG2 CLK _CLK out w1 TG
.ends

.subckt DFF CLK _CLK D Q _Q
XLatch1 CLK _CLK D w1 w2 Latch
XLatch2 _CLK CLK w2 _Q Q Latch
.ends

.subckt InBuf CLK CLKBuf _CLKBuf
XInv1 CLK w1 Inv
XInv2 w1 w2 Inv
XInv3 w2 w3 Inv
XInv4 w3 w4 Inv
XInv5 w4 w5 Inv
XInv6 w5 w6 Inv
XInv7 w6 _CLKBuf Inv
XInv8 _CLKBuf CLKBuf Inv
.ends

.subckt TapBuf in out
Mp1 out1 in vdd vdd pmos w=1.08u l=90n m=1
Mn1 out1 in vss vss nmos w=0.6u l=90n m=1
Mp2 out2 out1 vdd vdd pmos w=3.24u l=90n m=1
Mn2 out2 out1 vss vss nmos w=1.8u l=90n m=1
Mp3 out out2 vdd vdd pmos w=9.72u l=90n m=1
Mn3 out out2 vss vss nmos w=5.4u l=90n m=1
.ends

XInBuf1 CLK CLKBuf _CLKBuf InBuf
XDFF2 CLKBuf _CLKBuf _Q2 Q2 _Q2 DFF
XDFF4 Q2 _Q2 _Q4 Q4 _Q4 DFF
XDFF8 Q4 _Q4 _Q8 Q8 _Q8 DFF

XTapBufA Q2 T2 TapBuf
XTapBufB Q4 T4 TapBuf
XTapBufC Q8 T8 TapBuf

CoutA T2 vss 0.1p
CoutB T4 vss 0.1p
CoutC T8 vss 0.1p

.op
.param Frequency=8.75G
.param period='1/Frequency'
.temp 27
.tran 'period/10' 'period*30'
.probe v(CLKBuf) v(T2) v(T4) v(T8)
.option post=3

**Input signal**
VCLK CLK VSS pulse(0V 1V 'period/4' 0.1p 0.1p 'period/2' 'period')


**Time measurement**
.meas tran period_2 
+trig v(T2) val=1*0.5 rise=6
+targ v(T2) val=1*0.5 rise=7
.meas tran Trise 
+trig v(T2) val=1*0.1 rise=6
+targ v(T2) val=1*0.9 rise=6
.meas tran Tfall 
+trig v(T2) val=1*0.9 td='2.5*period' fall=6
+targ v(T2) val=1*0.1 fall=6
.meas tran rise_percent param='(Trise/period_2)*100'
.meas tran fall_percent param='abs(Tfall/period_2)*100'
.meas tran Frequency_2% param='(1/period_2)/Frequency'

**Power measurement**
.meas tran pwr rms power

.end