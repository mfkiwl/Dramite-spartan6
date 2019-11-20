EESchema Schematic File Version 4
LIBS:pcb-cache
EELAYER 30 0
EELAYER END
$Descr A3 16535 11693
encoding utf-8
Sheet 3 4
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L symbol:MT41J128M16 U1
U 1 1 5DD44F7F
P 6000 4500
F 0 "U1" H 6000 7593 60  0000 C CNN
F 1 "MT41J128M16" H 6000 7487 60  0000 C CNN
F 2 "footprint:BGA96-0.8" H 6000 7381 60  0000 C CNN
F 3 "" H 6000 4500 60  0000 C CNN
	1    6000 4500
	1    0    0    -1  
$EndComp
Text HLabel 2600 1800 0    50   Input ~ 0
DDR0_A[0..14]
Text HLabel 2600 3300 0    50   Input ~ 0
DDR0_BA[0..2]
Text HLabel 2600 3800 0    50   Input ~ 0
DDR0_CKE
Text HLabel 2600 4000 0    50   Input ~ 0
DDR0_CK_P
Text HLabel 2600 4100 0    50   Input ~ 0
DDR0_CK_N
Text HLabel 2600 4500 0    50   Input ~ 0
DDR0_LDM
Text HLabel 2600 4800 0    50   Input ~ 0
DDR0_ODT
Text HLabel 2600 4900 0    50   Input ~ 0
DDR0_RESET_N
Text HLabel 2600 5100 0    50   Input ~ 0
DDR0_RAS_N
Text HLabel 2600 5200 0    50   Input ~ 0
DDR0_CAS_N
Text HLabel 2600 5300 0    50   Input ~ 0
DDR0_WE_N
Text HLabel 2600 4600 0    50   Input ~ 0
DDR0_UDM
Entry Wire Line
	2700 1800 2800 1900
Entry Wire Line
	2700 1900 2800 2000
Entry Wire Line
	2700 2000 2800 2100
Entry Wire Line
	2700 2100 2800 2200
Entry Wire Line
	2700 2200 2800 2300
Entry Wire Line
	2700 2300 2800 2400
Entry Wire Line
	2700 2400 2800 2500
Entry Wire Line
	2700 2500 2800 2600
Entry Wire Line
	2700 2600 2800 2700
Entry Wire Line
	2700 2700 2800 2800
Entry Wire Line
	2700 2800 2800 2900
Entry Wire Line
	2700 2900 2800 3000
Entry Wire Line
	2700 3000 2800 3100
Entry Wire Line
	2700 3100 2800 3200
Entry Wire Line
	2700 3200 2800 3300
Entry Wire Line
	2700 3300 2800 3400
Entry Wire Line
	2700 3400 2800 3500
Entry Wire Line
	2700 3500 2800 3600
Wire Bus Line
	2600 1800 2700 1800
Wire Bus Line
	2600 3300 2700 3300
Text Label 2900 1900 0    50   ~ 0
DDR0_A0
Text Label 2900 2000 0    50   ~ 0
DDR0_A1
Text Label 2900 2100 0    50   ~ 0
DDR0_A2
Text Label 2900 2200 0    50   ~ 0
DDR0_A3
Text Label 2900 2300 0    50   ~ 0
DDR0_A4
Text Label 2900 2400 0    50   ~ 0
DDR0_A5
Text Label 2900 2500 0    50   ~ 0
DDR0_A6
Text Label 2900 2600 0    50   ~ 0
DDR0_A7
Text Label 2900 2700 0    50   ~ 0
DDR0_A8
Text Label 2900 2800 0    50   ~ 0
DDR0_A9
Text Label 2900 2900 0    50   ~ 0
DDR0_A10
Text Label 2900 3000 0    50   ~ 0
DDR0_A11
Text Label 2900 3100 0    50   ~ 0
DDR0_A12
Text Label 2900 3200 0    50   ~ 0
DDR0_A13
Text Label 2900 3300 0    50   ~ 0
DDR0_A14
Text Label 2900 3400 0    50   ~ 0
DDR0_BA0
Text Label 2900 3500 0    50   ~ 0
DDR0_BA1
Text Label 2900 3600 0    50   ~ 0
DDR0_BA2
$Comp
L Device:R R100
U 1 1 5DD6DD7F
P 4750 3900
F 0 "R100" V 4543 3900 50  0000 C CNN
F 1 "100" V 4634 3900 50  0000 C CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 4680 3900 50  0001 C CNN
F 3 "~" H 4750 3900 50  0001 C CNN
	1    4750 3900
	0    1    1    0   
$EndComp
$Comp
L Device:R R101
U 1 1 5DD6F073
P 4800 7850
F 0 "R101" H 4730 7804 50  0000 R CNN
F 1 "100" H 4730 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 4730 7850 50  0001 C CNN
F 3 "~" H 4800 7850 50  0001 C CNN
	1    4800 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R102
U 1 1 5DD6FBDC
P 4400 7850
F 0 "R102" H 4330 7804 50  0000 R CNN
F 1 "4K7" H 4330 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 4330 7850 50  0001 C CNN
F 3 "~" H 4400 7850 50  0001 C CNN
	1    4400 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R103
U 1 1 5DD6FF35
P 4000 7850
F 0 "R103" H 3930 7804 50  0000 R CNN
F 1 "4K7" H 3930 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 3930 7850 50  0001 C CNN
F 3 "~" H 4000 7850 50  0001 C CNN
	1    4000 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R104
U 1 1 5DD70397
P 3600 7850
F 0 "R104" H 3530 7804 50  0000 R CNN
F 1 "4K7" H 3530 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 3530 7850 50  0001 C CNN
F 3 "~" H 3600 7850 50  0001 C CNN
	1    3600 7850
	-1   0    0    1   
$EndComp
Text HLabel 2600 5400 0    50   BiDi ~ 0
DDR0_DQ[0..15]
Text HLabel 2600 7200 0    50   BiDi ~ 0
DDR0_LDQS_P
Text HLabel 2600 7300 0    50   BiDi ~ 0
DDR0_LDQS_N
Text HLabel 2600 7500 0    50   BiDi ~ 0
DDR0_UDQS_P
Text HLabel 2600 7600 0    50   BiDi ~ 0
DDR0_UDQS_N
Entry Wire Line
	2700 5400 2800 5500
Entry Wire Line
	2700 5500 2800 5600
Entry Wire Line
	2700 5600 2800 5700
Entry Wire Line
	2700 5700 2800 5800
Entry Wire Line
	2700 5800 2800 5900
Entry Wire Line
	2700 5900 2800 6000
Entry Wire Line
	2700 6000 2800 6100
Entry Wire Line
	2700 6100 2800 6200
Entry Wire Line
	2700 6200 2800 6300
Entry Wire Line
	2700 6300 2800 6400
Entry Wire Line
	2700 6400 2800 6500
Entry Wire Line
	2700 6500 2800 6600
Entry Wire Line
	2700 6600 2800 6700
Entry Wire Line
	2700 6700 2800 6800
Entry Wire Line
	2700 6800 2800 6900
Entry Wire Line
	2700 6900 2800 7000
Wire Bus Line
	2600 5400 2700 5400
Text Label 2900 3800 0    50   ~ 0
DDR0_CKE
Text Label 2900 4000 0    50   ~ 0
DDR0_CK_P
Text Label 2900 4100 0    50   ~ 0
DDR0_CK_N
Text Label 2900 4500 0    50   ~ 0
DDR0_LDM
Text Label 2900 4600 0    50   ~ 0
DDR0_UDM
Text Label 2900 4800 0    50   ~ 0
DDR0_ODT
Text Label 2900 4900 0    50   ~ 0
DDR0_RESET_N
Text Label 2900 5100 0    50   ~ 0
DDR0_RAS_N
Text Label 2900 5200 0    50   ~ 0
DDR0_CAS_N
Text Label 2900 5300 0    50   ~ 0
DDR0_WE_N
Text Label 2900 5500 0    50   ~ 0
DDR0_DQ0
Text Label 2900 5600 0    50   ~ 0
DDR0_DQ1
Text Label 2900 5700 0    50   ~ 0
DDR0_DQ2
Text Label 2900 5800 0    50   ~ 0
DDR0_DQ3
Text Label 2900 5900 0    50   ~ 0
DDR0_DQ4
Text Label 2900 6000 0    50   ~ 0
DDR0_DQ5
Text Label 2900 6100 0    50   ~ 0
DDR0_DQ6
Text Label 2900 6200 0    50   ~ 0
DDR0_DQ7
Text Label 2900 6300 0    50   ~ 0
DDR0_DQ8
Text Label 2900 6400 0    50   ~ 0
DDR0_DQ9
Text Label 2900 6500 0    50   ~ 0
DDR0_DQ10
Text Label 2900 6600 0    50   ~ 0
DDR0_DQ11
Text Label 2900 6700 0    50   ~ 0
DDR0_DQ12
Text Label 2900 6800 0    50   ~ 0
DDR0_DQ13
Text Label 2900 6900 0    50   ~ 0
DDR0_DQ14
Text Label 2900 7000 0    50   ~ 0
DDR0_DQ15
Text Label 2900 7200 0    50   ~ 0
DDR0_LDQS_P
Text Label 2900 7300 0    50   ~ 0
DDR0_LDQS_N
Text Label 2900 7500 0    50   ~ 0
DDR0_UDQS_P
Text Label 2900 7600 0    50   ~ 0
DDR0_UDQS_N
$Comp
L power:GND #PWR0101
U 1 1 5DDC4BAB
P 4800 8100
F 0 "#PWR0101" H 4800 7850 50  0001 C CNN
F 1 "GND" H 4805 7927 50  0000 C CNN
F 2 "" H 4800 8100 50  0001 C CNN
F 3 "" H 4800 8100 50  0001 C CNN
	1    4800 8100
	1    0    0    -1  
$EndComp
Connection ~ 4000 8000
Wire Wire Line
	4000 8000 4400 8000
Connection ~ 4400 8000
Wire Wire Line
	4400 8000 4800 8000
Wire Wire Line
	4800 8100 4800 8000
Connection ~ 4800 8000
Wire Wire Line
	3600 8000 4000 8000
Wire Wire Line
	3600 7700 3600 4900
Wire Wire Line
	4000 7700 4000 4800
Wire Wire Line
	4600 3900 4600 4000
Wire Wire Line
	4600 4000 5100 4000
Wire Wire Line
	4900 3900 4900 4100
Wire Wire Line
	4900 4100 5100 4100
Wire Wire Line
	4000 4800 5100 4800
Wire Wire Line
	3600 4900 5100 4900
Wire Wire Line
	5100 3800 4400 3800
Wire Wire Line
	4400 3800 4400 7700
Wire Wire Line
	4800 7700 4800 4300
Wire Wire Line
	4800 4300 5100 4300
Wire Wire Line
	2800 1900 5100 1900
Wire Wire Line
	2800 2000 5100 2000
Wire Wire Line
	2800 2100 5100 2100
Wire Wire Line
	2800 2200 5100 2200
Wire Wire Line
	2800 2300 5100 2300
Wire Wire Line
	2800 2400 5100 2400
Wire Wire Line
	2800 2500 5100 2500
Wire Wire Line
	2800 2600 5100 2600
Wire Wire Line
	2800 2700 5100 2700
Wire Wire Line
	2800 2800 5100 2800
Wire Wire Line
	2800 2900 5100 2900
Wire Wire Line
	2800 3000 5100 3000
Wire Wire Line
	2800 3100 5100 3100
Wire Wire Line
	2800 3200 5100 3200
Wire Wire Line
	2800 3300 5100 3300
Wire Wire Line
	2800 3400 5100 3400
Wire Wire Line
	2800 3500 5100 3500
Wire Wire Line
	2800 3600 5100 3600
Wire Wire Line
	2600 3800 4400 3800
Connection ~ 4400 3800
Wire Wire Line
	2600 4000 4600 4000
Connection ~ 4600 4000
Wire Wire Line
	2600 4100 4900 4100
Connection ~ 4900 4100
Wire Wire Line
	2600 4500 5100 4500
Wire Wire Line
	2600 4600 5100 4600
Wire Wire Line
	2600 4800 4000 4800
Connection ~ 4000 4800
Wire Wire Line
	2600 4900 3600 4900
Connection ~ 3600 4900
Wire Wire Line
	2600 5100 5100 5100
Wire Wire Line
	2600 5200 5100 5200
Wire Wire Line
	2600 5300 5100 5300
Wire Wire Line
	2800 5500 5100 5500
Wire Wire Line
	2800 5600 5100 5600
Wire Wire Line
	2800 5700 5100 5700
Wire Wire Line
	2800 5800 5100 5800
Wire Wire Line
	2800 5900 5100 5900
Wire Wire Line
	2800 6000 5100 6000
Wire Wire Line
	2800 6100 5100 6100
Wire Wire Line
	2800 6200 5100 6200
Wire Wire Line
	2800 6300 5100 6300
Wire Wire Line
	2800 6400 5100 6400
Wire Wire Line
	2800 6500 5100 6500
Wire Wire Line
	2800 6600 5100 6600
Wire Wire Line
	2800 6700 5100 6700
Wire Wire Line
	2800 6800 5100 6800
Wire Wire Line
	2800 6900 5100 6900
Wire Wire Line
	2800 7000 5100 7000
Wire Wire Line
	2600 7200 5100 7200
Wire Wire Line
	2600 7300 5100 7300
Wire Wire Line
	2600 7500 5100 7500
Wire Wire Line
	2600 7600 5100 7600
$Comp
L symbol:MT41J128M16 U2
U 1 1 5E0F95E5
P 13000 4500
F 0 "U2" H 13000 7593 60  0000 C CNN
F 1 "MT41J128M16" H 13000 7487 60  0000 C CNN
F 2 "footprint:BGA96-0.8" H 13000 7381 60  0000 C CNN
F 3 "" H 13000 4500 60  0000 C CNN
	1    13000 4500
	1    0    0    -1  
$EndComp
Text HLabel 9600 3300 0    50   Input ~ 0
DDR1_BA[0..2]
Text HLabel 9600 3800 0    50   Input ~ 0
DDR1_CKE
Text HLabel 9600 4000 0    50   Input ~ 0
DDR1_CK_P
Text HLabel 9600 4100 0    50   Input ~ 0
DDR1_CK_N
Text HLabel 9600 4500 0    50   Input ~ 0
DDR1_LDM
Text HLabel 9600 4800 0    50   Input ~ 0
DDR1_ODT
Text HLabel 9600 4900 0    50   Input ~ 0
DDR1_RESET_N
Text HLabel 9600 5100 0    50   Input ~ 0
DDR1_RAS_N
Text HLabel 9600 5200 0    50   Input ~ 0
DDR1_CAS_N
Text HLabel 9600 5300 0    50   Input ~ 0
DDR1_WE_N
Text HLabel 9600 4600 0    50   Input ~ 0
DDR1_UDM
Entry Wire Line
	9700 1800 9800 1900
Entry Wire Line
	9700 1900 9800 2000
Entry Wire Line
	9700 2000 9800 2100
Entry Wire Line
	9700 2100 9800 2200
Entry Wire Line
	9700 2200 9800 2300
Entry Wire Line
	9700 2300 9800 2400
Entry Wire Line
	9700 2400 9800 2500
Entry Wire Line
	9700 2500 9800 2600
Entry Wire Line
	9700 2600 9800 2700
Entry Wire Line
	9700 2700 9800 2800
Entry Wire Line
	9700 2800 9800 2900
Entry Wire Line
	9700 2900 9800 3000
Entry Wire Line
	9700 3000 9800 3100
Entry Wire Line
	9700 3100 9800 3200
Entry Wire Line
	9700 3200 9800 3300
Entry Wire Line
	9700 3300 9800 3400
Entry Wire Line
	9700 3400 9800 3500
Entry Wire Line
	9700 3500 9800 3600
Wire Bus Line
	9600 1800 9700 1800
Wire Bus Line
	9600 3300 9700 3300
$Comp
L Device:R R105
U 1 1 5E0F961D
P 11750 3900
F 0 "R105" V 11543 3900 50  0000 C CNN
F 1 "100" V 11634 3900 50  0000 C CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 11680 3900 50  0001 C CNN
F 3 "~" H 11750 3900 50  0001 C CNN
	1    11750 3900
	0    1    1    0   
$EndComp
$Comp
L Device:R R106
U 1 1 5E0F9623
P 11800 7850
F 0 "R106" H 11730 7804 50  0000 R CNN
F 1 "100" H 11730 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 11730 7850 50  0001 C CNN
F 3 "~" H 11800 7850 50  0001 C CNN
	1    11800 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R107
U 1 1 5E0F9629
P 11400 7850
F 0 "R107" H 11330 7804 50  0000 R CNN
F 1 "4K7" H 11330 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 11330 7850 50  0001 C CNN
F 3 "~" H 11400 7850 50  0001 C CNN
	1    11400 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R108
U 1 1 5E0F962F
P 11000 7850
F 0 "R108" H 10930 7804 50  0000 R CNN
F 1 "4K7" H 10930 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 10930 7850 50  0001 C CNN
F 3 "~" H 11000 7850 50  0001 C CNN
	1    11000 7850
	-1   0    0    1   
$EndComp
$Comp
L Device:R R109
U 1 1 5E0F9635
P 10600 7850
F 0 "R109" H 10530 7804 50  0000 R CNN
F 1 "4K7" H 10530 7895 50  0000 R CNN
F 2 "Resistor_SMD:R_0402_1005Metric" V 10530 7850 50  0001 C CNN
F 3 "~" H 10600 7850 50  0001 C CNN
	1    10600 7850
	-1   0    0    1   
$EndComp
Text HLabel 9600 5400 0    50   BiDi ~ 0
DDR1_DQ[0..15]
Text HLabel 9600 7200 0    50   BiDi ~ 0
DDR1_LDQS_P
Text HLabel 9600 7300 0    50   BiDi ~ 0
DDR1_LDQS_N
Text HLabel 9600 7500 0    50   BiDi ~ 0
DDR1_UDQS_P
Text HLabel 9600 7600 0    50   BiDi ~ 0
DDR1_UDQS_N
Entry Wire Line
	9700 5400 9800 5500
Entry Wire Line
	9700 5500 9800 5600
Entry Wire Line
	9700 5600 9800 5700
Entry Wire Line
	9700 5700 9800 5800
Entry Wire Line
	9700 5800 9800 5900
Entry Wire Line
	9700 5900 9800 6000
Entry Wire Line
	9700 6000 9800 6100
Entry Wire Line
	9700 6100 9800 6200
Entry Wire Line
	9700 6200 9800 6300
Entry Wire Line
	9700 6300 9800 6400
Entry Wire Line
	9700 6400 9800 6500
Entry Wire Line
	9700 6500 9800 6600
Entry Wire Line
	9700 6600 9800 6700
Entry Wire Line
	9700 6700 9800 6800
Entry Wire Line
	9700 6800 9800 6900
Entry Wire Line
	9700 6900 9800 7000
Wire Bus Line
	9600 5400 9700 5400
$Comp
L power:GND #PWR0102
U 1 1 5E0F966F
P 11800 8100
F 0 "#PWR0102" H 11800 7850 50  0001 C CNN
F 1 "GND" H 11805 7927 50  0000 C CNN
F 2 "" H 11800 8100 50  0001 C CNN
F 3 "" H 11800 8100 50  0001 C CNN
	1    11800 8100
	1    0    0    -1  
$EndComp
Connection ~ 11000 8000
Wire Wire Line
	11000 8000 11400 8000
Connection ~ 11400 8000
Wire Wire Line
	11400 8000 11800 8000
Wire Wire Line
	11800 8100 11800 8000
Connection ~ 11800 8000
Wire Wire Line
	10600 8000 11000 8000
Wire Wire Line
	10600 7700 10600 4900
Wire Wire Line
	11000 7700 11000 4800
Wire Wire Line
	11600 3900 11600 4000
Wire Wire Line
	11600 4000 12100 4000
Wire Wire Line
	11900 3900 11900 4100
Wire Wire Line
	11900 4100 12100 4100
Wire Wire Line
	11000 4800 12100 4800
Wire Wire Line
	10600 4900 12100 4900
Wire Wire Line
	12100 3800 11400 3800
Wire Wire Line
	11400 3800 11400 7700
Wire Wire Line
	11800 7700 11800 4300
Wire Wire Line
	11800 4300 12100 4300
Text Label 9900 1900 0    50   ~ 0
DDR1_A0
Text Label 9900 2000 0    50   ~ 0
DDR1_A1
Text Label 9900 2100 0    50   ~ 0
DDR1_A2
Text Label 9900 2200 0    50   ~ 0
DDR1_A3
Text Label 9900 2300 0    50   ~ 0
DDR1_A4
Text Label 9900 2400 0    50   ~ 0
DDR1_A5
Text Label 9900 2500 0    50   ~ 0
DDR1_A6
Text Label 9900 2600 0    50   ~ 0
DDR1_A7
Text Label 9900 2700 0    50   ~ 0
DDR1_A8
Text Label 9900 2800 0    50   ~ 0
DDR1_A9
Text Label 9900 2900 0    50   ~ 0
DDR1_A10
Text Label 9900 3000 0    50   ~ 0
DDR1_A11
Text Label 9900 3100 0    50   ~ 0
DDR1_A12
Text Label 9900 3200 0    50   ~ 0
DDR1_A13
Text Label 9900 3300 0    50   ~ 0
DDR1_A14
Text Label 9900 3400 0    50   ~ 0
DDR1_BA0
Text Label 9900 3500 0    50   ~ 0
DDR1_BA1
Text Label 9900 3600 0    50   ~ 0
DDR1_BA2
Text Label 9900 3800 0    50   ~ 0
DDR1_CKE
Text Label 9900 4000 0    50   ~ 0
DDR1_CK_P
Text Label 9900 4100 0    50   ~ 0
DDR1_CK_N
Text Label 9900 4500 0    50   ~ 0
DDR1_LDM
Text Label 9900 4600 0    50   ~ 0
DDR1_UDM
Text Label 9900 4800 0    50   ~ 0
DDR1_ODT
Text Label 9900 4900 0    50   ~ 0
DDR1_RESET_N
Text Label 9900 5100 0    50   ~ 0
DDR1_RAS_N
Text Label 9900 5200 0    50   ~ 0
DDR1_CAS_N
Text Label 9900 5300 0    50   ~ 0
DDR1_WE_N
Text Label 9900 5500 0    50   ~ 0
DDR1_DQ0
Text Label 9900 5600 0    50   ~ 0
DDR1_DQ1
Text Label 9900 5700 0    50   ~ 0
DDR1_DQ2
Text Label 9900 5800 0    50   ~ 0
DDR1_DQ3
Text Label 9900 5900 0    50   ~ 0
DDR1_DQ4
Text Label 9900 6000 0    50   ~ 0
DDR1_DQ5
Text Label 9900 6100 0    50   ~ 0
DDR1_DQ6
Text Label 9900 6200 0    50   ~ 0
DDR1_DQ7
Text Label 9900 6300 0    50   ~ 0
DDR1_DQ8
Text Label 9900 6400 0    50   ~ 0
DDR1_DQ9
Text Label 9900 6500 0    50   ~ 0
DDR1_DQ10
Text Label 9900 6600 0    50   ~ 0
DDR1_DQ11
Text Label 9900 6700 0    50   ~ 0
DDR1_DQ12
Text Label 9900 6800 0    50   ~ 0
DDR1_DQ13
Text Label 9900 6900 0    50   ~ 0
DDR1_DQ14
Text Label 9900 7000 0    50   ~ 0
DDR1_DQ15
Text Label 9900 7200 0    50   ~ 0
DDR1_LDQS_P
Text Label 9900 7300 0    50   ~ 0
DDR1_LDQS_N
Text Label 9900 7500 0    50   ~ 0
DDR1_UDQS_P
Text Label 9900 7600 0    50   ~ 0
DDR1_UDQS_N
Text HLabel 9600 1800 0    50   Input ~ 0
DDR1_A[0..14]
Wire Wire Line
	9800 1900 12100 1900
Wire Wire Line
	9800 2000 12100 2000
Wire Wire Line
	9800 2100 12100 2100
Wire Wire Line
	9800 2200 12100 2200
Wire Wire Line
	9800 2300 12100 2300
Wire Wire Line
	9800 2400 12100 2400
Wire Wire Line
	9800 2500 12100 2500
Wire Wire Line
	9800 2600 12100 2600
Wire Wire Line
	9800 2700 12100 2700
Wire Wire Line
	9800 2800 12100 2800
Wire Wire Line
	9800 2900 12100 2900
Wire Wire Line
	9800 3000 12100 3000
Wire Wire Line
	9800 3100 12100 3100
Wire Wire Line
	9800 3200 12100 3200
Wire Wire Line
	9800 3300 12100 3300
Wire Wire Line
	9800 3400 12100 3400
Wire Wire Line
	9800 3500 12100 3500
Wire Wire Line
	9800 3600 12100 3600
Wire Wire Line
	9600 3800 11400 3800
Connection ~ 11400 3800
Wire Wire Line
	9600 4000 11600 4000
Connection ~ 11600 4000
Connection ~ 11900 4100
Wire Wire Line
	9600 4100 11900 4100
Wire Wire Line
	9600 4500 12100 4500
Wire Wire Line
	9600 4600 12100 4600
Wire Wire Line
	9600 4800 11000 4800
Connection ~ 11000 4800
Wire Wire Line
	9600 4900 10600 4900
Connection ~ 10600 4900
Wire Wire Line
	9600 5100 12100 5100
Wire Wire Line
	9600 5200 12100 5200
Wire Wire Line
	9600 5300 12100 5300
Wire Wire Line
	9800 5500 12100 5500
Wire Wire Line
	9800 5600 12100 5600
Wire Wire Line
	9800 5700 12100 5700
Wire Wire Line
	9800 5800 12100 5800
Wire Wire Line
	9800 5900 12100 5900
Wire Wire Line
	9800 6000 12100 6000
Wire Wire Line
	9800 6100 12100 6100
Wire Wire Line
	9800 6200 12100 6200
Wire Wire Line
	9800 6300 12100 6300
Wire Wire Line
	9800 6400 12100 6400
Wire Wire Line
	9800 6500 12100 6500
Wire Wire Line
	9800 6600 12100 6600
Wire Wire Line
	9800 6700 12100 6700
Wire Wire Line
	9800 6800 12100 6800
Wire Wire Line
	9800 6900 12100 6900
Wire Wire Line
	9800 7000 12100 7000
Wire Wire Line
	9600 7200 12100 7200
Wire Wire Line
	9600 7300 12100 7300
Wire Wire Line
	9600 7500 12100 7500
Wire Wire Line
	9600 7600 12100 7600
Wire Bus Line
	2700 3300 2700 3500
Wire Bus Line
	9700 3300 9700 3500
Wire Bus Line
	2700 1800 2700 3200
Wire Bus Line
	2700 5400 2700 6900
Wire Bus Line
	9700 1800 9700 3200
Wire Bus Line
	9700 5400 9700 6900
$EndSCHEMATC
