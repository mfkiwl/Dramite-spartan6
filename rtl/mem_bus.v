/*******************************************************************************

    This Source Code Form is subject to the terms of the Open Hardware 
    Description License, v. 1.0. If a copy of the OHDL was not distributed
    with this file, you can obtain one at http://juliubaxter.net/ohdl/ohdl.txt

    Description: Dramite portable top level

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/

`default_nettype	wire

module busmaster(
    // Clock & Reset
    input          clk,           // Base Clock Input (50MHz)
    input          rst,           // Clean Active High reset input