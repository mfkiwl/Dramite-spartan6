/*******************************************************************************

    This Source Code Form is subject to the terms of the Open Hardware 
    Description License, v. 1.0. If a copy of the OHDL was not distributed
    with this file, you can obtain one at http://juliubaxter.net/ohdl/ohdl.txt

    Description: Dramite portable top level

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/

`default_nettype wire

module busmaster(
    // Clock & Reset
    input              clk,           // Base Clock Input (50MHz)
    input              rst,           // Clean Active High reset input
    // CPU interface
    input [23:1]       cpu_a,
    inout [15:0]       cpu_d,
    input              cpu_ads_n,     // Address Status
    input              cpu_bhe_n,     // High Byte Enable
    input              cpu_ble_n,     // Low Byte Enable 
    output             cpu_busy_n,    // Busy
    output             cpu_clk2,      // Clock
    /* verilator lint_off UNUSED */
    // This should be used when the interrupt is supported.
    input              cpu_dc,        // H: Data, Low: Control
    /* verilator lint_on UNUSED */
    output             cpu_error_n,   // Error
    /* verilator lint_off UNUSED */
    // There is nothing else on the CPU bus, no need to hold the bus, for now.
    input              cpu_hlda,      // Bus Hold Acknowledge
    input              cpu_lock_n,    // Bus Lock
    /* verilator lint_on UNUSED */
    output             cpu_hold,      // Bus Hold Request
    output             cpu_intr,      // Interrupt Request
    input              cpu_mio,       // H: Memory, L: IO
    output             cpu_na_n,      // Next Address
    output             cpu_nmi,       // Non-Maskable Interrupt Request
    output             cpu_pereq,     // Processor Extension Request
    output reg         cpu_ready_n,   // Bus Ready
    output             cpu_reset,     // Reset
    input              cpu_wr,        // H: Write, L: Read
    // RAM interface
    input              ram_wr_ack,
    output reg [31:0]  ram_wr_data,
    output reg [31:2]  ram_address,
    output reg         ram_wr_enable,
    output reg [3:0]   ram_wr_mask,
    output reg         ram_rd_enable,
    input      [31:0]  ram_rd_data,
    input              ram_rd_valid,          
    // VGA Interface
    output             vga_vsync,     // VGA Vertical Sync
    output             vga_hsync,     // VGA Horizontal Sync
    output             vga_pclk,      // VGA Pixel Clock
    output             vga_de,        // VGA Data Enable
    output     [17:0]  vga_pixel,     // VGA Pixel Data (6-6-6)
    // BIOS     ROM Interface
    output reg [15:2]  rom_address,   // BIOS ROM Address
    input      [31:0]  rom_rd_data,   // BIOS ROM Data
    output reg         rom_rd_enable, // BIOS ROM Read Enable
    input              rom_rd_valid,  // BIOS ROM Read Valid
    // Debug
    output     [7:0]   led_output,
    output     [2:0]   state,
    output     [1:0]   bus_state
);

    // 386 Memory Map
    // ---------------------------- 0x00FFFFFF 16MB
    //  System ROM Mirror (64KB)
    // ---------------------------- 0x00FEFFFF 15.9MB
    //  ISA Memory Hole (1MB)
    // ---------------------------- 0x00EFFFFF 15MB
    //  Extended Memory (14MB)
    // ---------------------------- 0x000FFFFF 1MB
    //  System ROM (64KB)
    // ---------------------------- 0x000EFFFF 960KB
    //  System RAM (64KB)
    // ---------------------------- 0x000DFFFF 896KB
    //  Unused (80KB)
    // ---------------------------- 0x000CBFFF 816KB
    //  Video ROM (48KB)
    // ---------------------------- 0x000BFFFF 768KB
    //  Video RAM (128KB)
    // ---------------------------- 0x0009FFFF 640KB
    //  Conventional RAM (640KB)
    // ---------------------------- 0x00000000 0

    // Internal Bus
    // Memory Bus
    reg         bus_mem_wr_ack;
    wire [31:0] bus_mem_wr_data;
    wire [31:2] bus_mem_address;
    wire        bus_mem_wr_enable;
    wire [3:0]  bus_mem_wr_mask;
    wire        bus_mem_rd_enable;
    reg  [31:0] bus_mem_rd_data;
    reg         bus_mem_rd_valid;

    // IO Bus
    /* verilator lint_off UNUSED */
    // IO bus is not a thing... yet.
    reg         bus_io_wr_ack;
    wire [31:0] bus_io_wr_data;
    wire [31:2] bus_io_address;
    wire        bus_io_wr_enable;
    wire [3:0]  bus_io_wr_mask;
    wire        bus_io_rd_enable;
    reg  [31:0] bus_io_rd_data;
    reg         bus_io_rd_valid;
    /* verilator lint_on UNUSED */

    // Clock & Reset
    assign cpu_clk2 = clk;
    assign cpu_reset = rst;

    cpu_interface cpu_interface(
        .clk(clk),
        .rst(rst),
        .cpu_a(cpu_a),
        .cpu_d(cpu_d),
        .cpu_ads_n(cpu_ads_n),
        .cpu_bhe_n(cpu_bhe_n),
        .cpu_ble_n(cpu_ble_n),
        .cpu_busy_n(cpu_busy_n),
        .cpu_clk2(cpu_clk2),
        .cpu_dc(cpu_dc),
        .cpu_error_n(cpu_error_n),
        .cpu_hlda(cpu_hlda),
        .cpu_lock_n(cpu_lock_n),
        .cpu_hold(cpu_hold),
        .cpu_intr(cpu_intr),
        .cpu_mio(cpu_mio),
        .cpu_na_n(cpu_na_n),
        .cpu_nmi(cpu_nmi),
        .cpu_pereq(cpu_pereq),
        .cpu_ready_n(cpu_ready_n),
        .cpu_reset(cpu_reset),
        .cpu_wr(cpu_wr),
        .mem_wr_ack(bus_mem_wr_ack),
        .mem_wr_data(bus_mem_wr_data),
        .mem_address(bus_mem_address),
        .mem_wr_enable(bus_mem_wr_enable),
        .mem_wr_mask(bus_mem_wr_mask),
        .mem_rd_enable(bus_mem_rd_enable),
        .mem_rd_data(bus_mem_rd_data),
        .mem_rd_valid(bus_mem_rd_valid),
        .io_wr_ack(bus_io_wr_ack),
        .io_wr_data(bus_io_wr_data),
        .io_address(bus_io_address),
        .io_wr_enable(bus_io_wr_enable),
        .io_wr_mask(bus_io_wr_mask),
        .io_rd_enable(bus_io_rd_enable),
        .io_rd_data(bus_io_rd_data),
        .io_rd_valid(bus_io_rd_valid)
    )

    wire [31:0] bus_mem_addr_pad = {bus_mem_address, 2'b0};

    // Memory Bus
    always @ (*)
    begin
        if (rst) begin
            bus_mem_wr_ack = 0;
            bus_mem_rd_valid = 0;
        end
        else begin
            rom_address[15:2] = 14'b0;
            ram_address[31:2] = 30'b0;
            bus_mem_rd_data[31:0] = 32'b0;
            ram_wr_mask[3:0] = 4'b0;
            ram_wr_data[31:0] = 32'b0;
            
        
            if (((bus_mem_addr_pad >= 32'h000F0000) && 
                (bus_mem_addr_pad <= 32'h000FFFFF)) || 
               ((bus_mem_addr_pad >= 32'h00FF0000) &&
                (bus_mem_addr_pad <= 32'h00FFFFFF))) begin
                // System ROM
                rom_address[15:2] = bus_mem_address[15:2];
                rom_rd_enable = bus_mem_rd_enable;
                bus_mem_rd_data = rom_rd_data;
                bus_mem_rd_valid = rom_rd_valid;
                bus_mem_wr_ack = 1;
            end
            else if 
               ((bus_mem_addr_pad >= 32'h000C0000) &&
                (bus_mem_addr_pad <= 32'h000CBFFF)) begin
                // Video ROM
                bus_mem_rd_valid = 1;
                bus_mem_wr_ack = 1;
            end
            else if
               ((bus_mem_addr_pad >= 32'h00F00000) &&
                (bus_mem_addr_pad <= 32'h00FEFFFF)) begin
                // ISA Memory Hole
                bus_mem_rd_valid = 1;
                bus_mem_wr_ack = 1;
            end
            else begin
                bus_mem_wr_ack = ram_wr_ack;
                ram_wr_data = bus_mem_wr_data;
                ram_wr_enable = bus_mem_wr_enable;
                ram_wr_mask = bus_mem_wr_mask;
                bus_mem_rd_valid = ram_rd_valid;
                bus_mem_rd_data = ram_rd_data;
                ram_rd_enable = bus_mem_rd_enable;
                ram_address = bus_mem_address;
            end
        end    
    end

    // IO Bus
    // ??
    assign led_output = bus_io_wr_data[7:0];
    always @ (*)
    begin
        if (rst) begin
            bus_io_wr_ack = 0;
            bus_io_rd_valid = 0;
        end
        else begin
            bus_io_wr_ack = 1;
            bus_io_rd_valid = 1;
        end    
    end

    
    assign vga_vsync = 1'b1;
    assign vga_hsync = 1'b1;
    assign vga_pclk = 1'b0;
    assign vga_de = 1'b0;
    assign vga_pixel = 18'b0;
    
    assign state = cpu_bus_state;
    assign bus_state[0] = bus_mem_rd_valid;
    assign bus_state[1] = bus_mem_rd_enable;

endmodule
