# Dramite

# Overall

This project aims to create a "bridge" that would work with a real 386SX processor. The full system should be IBM-PC compatible, being able to run operating system and software written for IBM-PC. Supporting for other CPUs (like 386DX, 486) and other architecture (like PC-98) are planned, but not now. This project also includes a software x86 emulator for the simulation purpose. Currently work in progress, see Progress for details.

# Build

To run the simulation:

```sh
cd rtl
make
cd ../sim
make
./sim
```

To build for the FPGA board:

Open the project file with ISE/Vivado/Quartus with corresponding FPGA project in the fpga folder. 

# Progress

RTL side:

 - [x] CPU interface
 - [ ] DDR memory controller interface
 - [ ] On-chip / Off-chip cache
 - [ ] 8042-compatible keyboard & mouse controller
 - [ ] 8259-compatible programmable interrupt controller
 - [ ] 8253-compatible programmable interval timer
 - [ ] 8250-compatible UART
 - [ ] MC146818-compatible RTC 
 - [ ] CPU-to-ISA bridge
 - [ ] VGA-compatible graphics

Board-specific:

 - [ ] PCF8583 RTC driver

Verilated Simulator:

 - [x] Basic memory support
 - [ ] x86 CPU simulation
 - [ ] VGA monitor
 - [ ] Serial console

# Acknowledge

This project use the "tiny x86 cpu emulator" by tuz358 (https://github.com/tuz358/cpu-emulator). This allowed simulation without a real CPU.

# Copyright

Unless otherwise noted, all HDL files are licensed under OHDL, all software codes including verilated simulation codes are licensed under GNU GPLv3.