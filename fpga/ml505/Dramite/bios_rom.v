`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:51:46 09/15/2018 
// Design Name: 
// Module Name:    bios_rom 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module bios_rom(
    input clk,
    input rst,
    input [12:0] address,
    output reg [31:0] rd_data,
    input rd_enable,
    output reg rd_valid
    );

    reg [31:0] brom [0:8191]; // 32 KBytes BROM array
   
    initial begin
        $readmemh("bios.mif", brom, 0, 8191);
    end
    
    always @(posedge clk) begin
        if (rd_enable) begin
            rd_data <= brom[address];
            rd_valid <= 1'b1;
        end
        else begin
            rd_valid <= 1'b0;
        end
    end

endmodule
