/*******************************************************************************

    This Source Code Form is subject to the terms of the Open Hardware 
    Description License, v. 1.0. If a copy of the OHDL was not distributed
    with this file, you can obtain one at http://juliubaxter.net/ohdl/ohdl.txt

    Description: Dramite CPU interface for 386DX

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/

`default_nettype none

module cpu_interface(
    // Clock & Reset
    input  wire        clk,           // Base Clock Input (2xCPU clock)
    input  wire        rst,           // Clean Active High reset input

    // CPU interface
    input  wire [23:1] cpu_a,
    inout  wire [15:0] cpu_d,
    input  wire        cpu_ads_n,     // Address Status
    input  wire        cpu_bhe_n,     // High Byte Enable
    input  wire        cpu_ble_n,     // Low Byte Enable 
    output wire        cpu_busy_n,    // Busy
    output wire        cpu_clk2,      // Clock
    /* verilator lint_off UNUSED */
    // This should be used when the interrupt is supported.
    input  wire        cpu_dc,        // H: Data, Low: Control
    /* verilator lint_on UNUSED */
    output wire        cpu_error_n,   // Error
    /* verilator lint_off UNUSED */
    // There is nothing else on the CPU bus, no need to hold the bus, for now.
    input  wire        cpu_hlda,      // Bus Hold Acknowledge
    input  wire        cpu_lock_n,    // Bus Lock
    /* verilator lint_on UNUSED */
    output             cpu_hold,      // Bus Hold Request
    output             cpu_intr,      // Interrupt Request
    input              cpu_mio,       // H: Memory, L: IO
    output             cpu_na_n,      // Next Address
    output             cpu_nmi,       // Non-Maskable Interrupt Request
    output             cpu_pereq,     // Processor Extension Request
    /* verilator lint_off UNUSED */
    output reg         cpu_ready_n,   // Bus Ready
    output             cpu_reset,     // Reset
    input              cpu_wr,        // H: Write, L: Read

    // Memory Bus
    input  wire        mem_wr_ack,
    output reg  [31:0] mem_wr_data,
    output reg  [31:2] mem_address,
    output reg         mem_wr_enable,
    output reg  [3:0]  mem_wr_mask,
    output reg         mem_rd_enable,
    input  wire [31:0] mem_rd_data,
    input  wire        mem_rd_valid,

    // IO Bus
    input  wire        io_wr_ack,
    output reg  [31:0] io_wr_data,
    output reg  [31:2] io_address,
    output reg         io_wr_enable,
    output reg  [3:0]  io_wr_mask,
    output reg         io_rd_enable,
    input  wire [31:0] io_rd_data,
    input  wire        io_rd_valid
);

    // Clock & Reset
    assign cpu_clk2 = clk;
    assign cpu_reset = rst;


    // Disable all unhandled signals
    assign cpu_nmi = 1'b0;
    assign cpu_pereq = 1'b0;
    assign cpu_busy_n = 1'b1;
    assign cpu_error_n = 1'b1;
    assign cpu_hold = 1'b0;
    assign cpu_na_n = 1'b1;
    assign cpu_intr = 1'b0;

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
            mem_address <= 30'b0;
            io_address <= 30'b0;
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
                            mem_address[23:2] <= cpu_a[23:2];
                            if (!cpu_wr) mem_rd_enable <= 1'b1;
                        end
                        else begin
                            // This is a IO access cycle
                            bus_io_address[23:2] <= cpu_a[23:2];
                            if (!cpu_wr) io_rd_enable <= 1'b1;
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
                                mem_wr_data[31:16] <= cpu_d_rd[15:0];
                            else
                                mem_wr_data[15:0] <= cpu_d_rd[15:0];
                            mem_wr_mask <= cpu_bus_wr_mask;
                            mem_wr_enable <= 1'b1;
                        end
                        else begin
                            if (cpu_a[1])
                                io_wr_data[31:16] <= cpu_d_rd[15:0];
                            else
                                io_wr_data[15:0] <= cpu_d_rd[15:0];
                            io_wr_mask <= cpu_bus_wr_mask;
                            io_wr_enable <= 1'b1;
                        end
                    end
                    cpu_bus_state <= CPU_BUS_S2;
                end
                CPU_BUS_S2: begin
                    if (cpu_wr) begin
                        // Check if write have finished
                        if (cpu_mio) begin
                            if (mem_wr_ack) begin
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                        else begin
                            if (io_wr_ack) begin
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
                            if (mem_rd_valid) begin
                                cpu_d_dir <= 1'b1;
                                if (cpu_a[1])
                                    cpu_d_wr[15:0] <= mem_rd_data[31:16];
                                else
                                    cpu_d_wr[15:0] <= mem_rd_data[15:0];
                                cpu_ready_n <= 1'b0;
                                cpu_bus_state <= CPU_BUS_S3;
                            end
                            else begin
                                cpu_bus_state <= CPU_BUS_S4;
                            end
                        end
                        else begin
                            if (mem_rd_valid) begin
                                cpu_d_dir <= 1'b1;
                                if (cpu_a[1])
                                    cpu_d_wr[15:0] <= mem_rd_data[31:16];
                                else
                                    cpu_d_wr[15:0] <= mem_rd_data[15:0];
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

endmodule