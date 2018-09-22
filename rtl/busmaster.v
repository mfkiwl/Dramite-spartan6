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
    reg  [31:0] bus_mem_wr_data;
    reg  [31:2] bus_mem_address;
    reg         bus_mem_wr_enable;
    reg  [3:0]  bus_mem_wr_mask;
    reg         bus_mem_rd_enable;
    reg  [31:0] bus_mem_rd_data;
    reg         bus_mem_rd_valid;

    // IO Bus
    /* verilator lint_off UNUSED */
    // IO bus is not a thing... yet.
    reg         bus_io_wr_ack;
    reg  [31:0] bus_io_wr_data;
    reg  [31:2] bus_io_address;
    reg         bus_io_wr_enable;
    reg  [3:0]  bus_io_wr_mask;
    reg         bus_io_rd_enable;
    reg  [31:0] bus_io_rd_data;
    reg         bus_io_rd_valid;
    /* verilator lint_on UNUSED */

    // Clock & Reset
    assign cpu_clk2 = clk;
    assign cpu_reset = rst;

    // 386 Bus (24bit A + 16b D)
    localparam CPU_BUS_S0 = 3'd0; // Idle, no bus req       000
    localparam CPU_BUS_S1 = 3'd1; // Start Bus Transfer     001
    localparam CPU_BUS_S2 = 3'd2; // Check R/W Status       010
    localparam CPU_BUS_S3 = 3'd3; // Waiting for Bus finish 011
    localparam CPU_BUS_S4 = 3'd4; // Waiting for R/W finish 100
    // Only handle non-pipelined transfer
    // Note: D/C is not currently handled, lock is not used now.
    reg [2:0] cpu_bus_state;
    reg [3:0] cpu_bus_wr_mask;

    reg [15:0] cpu_d_wr;
    wire [15:0] cpu_d_rd;
    reg        cpu_d_dir; // 0: Ext->Int, 1: Int->Ext
    assign cpu_d = (cpu_d_dir) ? (cpu_d_wr) : (16'hzzzz);
    assign cpu_d_rd = (cpu_d_dir) ? (cpu_d_wr) : (cpu_d);

    always @(posedge cpu_clk2, posedge rst) begin
        if (rst) begin
            cpu_bus_state <= CPU_BUS_S0;
            cpu_ready_n <= 1'b1;
            cpu_d_dir <= 1'b0;
            bus_mem_address <= 30'b0;
            bus_io_address <= 30'b0;
        end
        else begin
            case (cpu_bus_state)
                CPU_BUS_S0: begin
                    cpu_d_dir <= 1'b0;
                    cpu_ready_n <= 1'b1; // Data not ready
                    if (!cpu_ads_n) begin
                        // Bus cycle start
                        if (cpu_mio) begin 
                            // This is a memory access cycle
                            bus_mem_address[23:2] <= cpu_a[23:2];
                            if (!cpu_wr) bus_mem_rd_enable <= 1'b1;
                        end
                        else begin
                            // This is a IO access cycle
                            bus_io_address[23:2] <= cpu_a[23:2];
                            if (!cpu_wr) bus_io_rd_enable <= 1'b1;
                        end
                        cpu_bus_wr_mask[3] <= ~cpu_bhe_n &  cpu_a[1];
                        cpu_bus_wr_mask[2] <= ~cpu_ble_n &  cpu_a[1];
                        cpu_bus_wr_mask[1] <= ~cpu_bhe_n & ~cpu_a[1];
                        cpu_bus_wr_mask[0] <= ~cpu_ble_n & ~cpu_a[1];
                        cpu_bus_state <= CPU_BUS_S1;
                    end
                end
                CPU_BUS_S1: begin
                    if (cpu_wr) begin
                        // Write data becomes available at this stage
                        if (cpu_mio) begin
                            if (cpu_a[1])
                                bus_mem_wr_data[31:16] <= cpu_d_rd[15:0];
                            else
                                bus_mem_wr_data[15:0] <= cpu_d_rd[15:0];
                            bus_mem_wr_mask <= cpu_bus_wr_mask;
                            bus_mem_wr_enable <= 1'b1;
                        end
                        else begin
                            if (cpu_a[1])
                                bus_io_wr_data[31:16] <= cpu_d_rd[15:0];
                            else
                                bus_io_wr_data[15:0] <= cpu_d_rd[15:0];
                            bus_io_wr_mask <= cpu_bus_wr_mask;
                            bus_io_wr_enable <= 1'b1;
                        end
                    end
                    cpu_bus_state <= CPU_BUS_S2;
                end
                CPU_BUS_S2: begin
                    if (cpu_wr) begin
                        // Check if write have finished
                        if (cpu_mio) begin
                            if (bus_mem_wr_ack) begin
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                        else begin
                            if (bus_io_wr_ack) begin
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                    end
                    else begin
                        // Check if read have finished 
                        if (cpu_mio) begin
                            if (bus_mem_rd_valid) begin
                                cpu_d_dir <= 1'b1;
                                if (cpu_a[1])
                                    cpu_d_wr[15:0] <= bus_mem_rd_data[31:16];
                                else
                                    cpu_d_wr[15:0] <= bus_mem_rd_data[15:0];
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                        else begin
                            if (bus_mem_rd_valid) begin
                                cpu_d_dir <= 1'b1;
                                if (cpu_a[1])
                                    cpu_d_wr[15:0] <= bus_mem_rd_data[31:16];
                                else
                                    cpu_d_wr[15:0] <= bus_mem_rd_data[15:0];
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                    end
                end
                CPU_BUS_S3: begin
                    cpu_bus_state <= CPU_BUS_S0;
                end
                CPU_BUS_S4: begin
                    cpu_bus_state <= CPU_BUS_S2;
                end
                default: begin
                    cpu_bus_state <= CPU_BUS_S0;
                end
            endcase
        end
    end

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

    // Disable all unhandled signals
    assign cpu_nmi = 1'b0;
    assign cpu_pereq = 1'b0;
    assign cpu_busy_n = 1'b1;
    assign cpu_error_n = 1'b1;
    assign cpu_hold = 1'b0;
    assign cpu_na_n = 1'b1;
    assign cpu_intr = 1'b0;
    assign vga_vsync = 1'b1;
    assign vga_hsync = 1'b1;
    assign vga_pclk = 1'b0;
    assign vga_de = 1'b0;
    assign vga_pixel = 18'b0;
    
    assign state = cpu_bus_state;
    assign bus_state[0] = bus_mem_rd_valid;
    assign bus_state[1] = bus_mem_rd_enable;

endmodule
