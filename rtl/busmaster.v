/*******************************************************************************

    This Source Code Form is subject to the terms of the Open Hardware 
    Description License, v. 1.0. If a copy of the OHDL was not distributed
    with this file, you can obtain one at http://juliubaxter.net/ohdl/ohdl.txt

    Description: Dramite portable top level

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/

`default_nettype	none

module busmaster(
    // Clock & Reset
    input          clk,           // Base Clock Input (50MHz)
    input          rst,           // Clean Active High reset input
    // CPU interface
    input [23:1]   cpu_a,
    inout [15:0]   cpu_d,
    input          cpu_ads_n,     // Address Status
    input          cpu_bhe_n,     // High Byte Enable
    input	       cpu_ble_n,     // Low Byte Enable 
    output         cpu_busy,      // Busy
    output         cpu_clk2,      // Clock
    input          cpu_dc,        // H: Data, Low: Control
    output         cpu_error_n,   // Error
    input          cpu_hlda,      // Bus Hold Acknowledge
    output         cpu_hold,      // Bus Hold Request
    output         cpu_intr,      // Interrupt Request
    input          cpu_lock_n,    // Bus Lock
    input          cpu_mio,       // H: Memory, L: IO
    output         cpu_na_n,      // Next Address
    output         cpu_nmi,       // Non-Maskable Interrupt Request
    output         cpu_pereq,     // Processor Extension Request
    output         cpu_ready_n,   // Bus Ready
    output         cpu_reset,     // Reset
    inout          cpu_wr,        // H: Write, L: Read
    // RAM interface
    input          ram_wr_ack,
    output [31:0]  ram_wr_data,
    output [31:0]  ram_address,
    output         ram_wr_enable,
    output [3:0]   ram_wr_mask,
    output         ram_rd_enable,
    input  [31:0]  ram_rd_data,
    input          ram_rd_valid,          
    // VGA Interface
    output         vga_vsync,     // VGA Vertical Sync
    output         vga_hsync,     // VGA Horizontal Sync
    output         vga_pclk,      // VGA Pixel Clock
    output         vga_de,        // VGA Data Enable
    output [17:0]  vga_pixel,     // VGA Pixel Data (6-6-6)
    // BIOS ROM Interface
    output [15:0]  rom_address,   // BIOS ROM Address
    input [7:0]    rom_rd_data,   // BIOS ROM Data
    output         rom_rd_enable, // BIOS ROM Read Enable
    output         rom_rd_valid,  // BIOS ROM Clock for Async Access 
    );

    // 386 Memory Map
    // ---------------------------- 0x00FFFFFF 16MB
    //  ISA Memory Hole (1MB)
    // ---------------------------- 0x00EFFFFF 15MB
    //  Extended Memory (14MB)
    // ---------------------------- 0x000FFFFF 1MB
    //  System ROM (64KB)
    // ---------------------------- 0x000EFFFF 960KB
    //  Unused
    // ---------------------------- 0x000CBFFF 816KB
    //  Video ROM (48KB)
    // ---------------------------- 0x000BFFFF 768KB
    //  Video RAM (128KB)
    // ---------------------------- 0x0009FFFF 640KB
    //  Conventional RAM (640KB)
    // ---------------------------- 0x00000000 0

    // 386 Bus
    localparam CPU_BUS_Ti  = 3'd0;  // Idle State
    localparam CPU_BUS_Th  = 3'd1;  // Hold Acknowledge (CPU asserts HLDA)
    localparam CPU_BUS_T1  = 3'd2;  // First clock of a non-pipelined bus cycle
                                    // (CPU drives new addr and asserts ADS_n)
    localparam CPU_BUS_T2  = 3'd3;  // Subsequent clocks of a bus cycle when 
                                    // NA_n has not been sampled asserted in    
                                    // the current bus cycle
    localparam CPU_BUS_T2I = 3'd4;  // Subsequent clocks of a bus cycle when 
                                    // NA_n has been sampled asserted but there 
                                    // has not yet an internal bus req pending 
                                    // (CPU drives new addr and asserts ADS_n)
    localparam CPU_BUS_T2P = 3'd5;  // Subsequent clocks of a bus cycle when 
                                    // NA_n has been sampled asserted and there 
                                    // is a internal bus req pending 
                                    // (CPU drives new addr and asserts ADS_n)
    localparam CPU_BUS_T1P = 3'd6;  // First clock of a pipelined bus cycle

    // Internal Bus
    // Memory Bus
    wire        bus_mem_wr_ack;
    wire [31:0] bus_mem_wr_data;
    wire [31:0] bus_mem_address;
    wire        bus_mem_wr_enable;
    wire [3:0]  bus_mem_wr_mask;
    wire        bus_mem_rd_enable;
    wire [31:0] bus_mem_rd_data;
    wire        bus_mem_rd_valid;

    // IO Bus
    wire        bus_io_wr_ack;
    wire [31:0] bus_io_wr_data;
    wire [31:0] bus_io_address;
    wire        bus_io_wr_enable;
    wire [3:0]  bus_io_wr_mask;
    wire        bus_io_rd_enable;
    wire [31:0] bus_io_rd_data;
    wire        bus_io_rd_valid;

    // Clock & Reset
    assign cpu_clk2 = clock;

    // 386 Bus to Internal Bus
    always @(posedge cpu_clk2)
    begin
      
    end

    // Disable all unhandled signals
    assign cpu_nmi = 1'b0;
    assign cpu_pereq = 1'b0;
    assign cpu_busy = 1'b0;

endmodule
