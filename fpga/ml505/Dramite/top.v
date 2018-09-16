/*******************************************************************************

    This Source Code Form is subject to the terms of the Open Hardware 
    Description License, v. 1.0. If a copy of the OHDL was not distributed
    with this file, you can obtain one at http://juliubaxter.net/ohdl/ohdl.txt

    Description: Dramite FPGA top level

    Copyright (C) 2018 Wenting Zhang

*******************************************************************************/
`default_nettype wire

module top(
    // Audio
    //output         AUDIO_SDATA_OUT,
    //input         AUDIO_BIT_CLK,
    //input          AUDIO_SDATA_IN,
    //output         AUDIO_SYNC,
    //output         FLASH_AUDIO_RESET_B,

    // SRAM & Flash
    //output [30:0]  SRAM_FLASH_A,
    //inout  [15:0]  SRAM_FLASH_D,
    //inout  [31:16] SRAM_D,
    //inout  [3:0]   SRAM_DQP,
    //output [3:0]   SRAM_BW,
    //output         SRAM_FLASH_WE_B,
    //output         SRAM_CLK,
    //output         SRAM_CS_B,
    //output         SRAM_OE_B,
    //output         SRAM_MODE,
    //output         SRAM_ADV_LD_B,
    //output         FLASH_CE_B,
    //output         FLASH_OE_B,
    //output         FLASH_CLK,
    //output         FLASH_ADV_B,
    //output         FLASH_WAIT,
    
    // Rotrary Encoder
    //input          ROTARY_INCA,
    //input          ROTARY_INCB,
    
    // UART
    /*output         FPGA_SERIAL1_TX,
    input          FPGA_SERIAL1_RX,
    output         FPGA_SERIAL2_TX,
    input          FPGA_SERIAL2_RX,*/
    
    // IIC
    /*output         IIC_SCL_MAIN,
    inout          IIC_SDA_MAIN,*/
    //inout          IIC_SCL_VIDEO,
    //inout          IIC_SDA_VIDEO,
    /*output         IIC_SCL_SFP,
    inout          IIC_SDA_SFP,*/
    
    // PS2
    /*output         MOUSE_CLK,
    input          MOUSE_DATA,
    output         KEYBOARD_CLK,
    inout          KEYBOARD_DATA,*/
    
    // VGA IN
    /*input          VGA_IN_DATA_CLK,
    input  [7:0]   VGA_IN_BLUE,
    input  [7:0]   VGA_IN_GREEN,
    input  [7:0]   VGA_IN_RED,
    input          VGA_IN_HSOUT,
    input          VGA_IN_ODD_EVEN_B,
    input          VGA_IN_VSOUT,
    input          VGA_IN_SOGOUT,*/
    
    // SW
    input          GPIO_SW_C,
    input          GPIO_SW_W,
    input          GPIO_SW_E,
    input          GPIO_SW_S,
    input          GPIO_SW_N,
//    input  [7:0]   GPIO_DIP_SW,
    
    // LED
    output [7:0]   GPIO_LED,
    output         GPIO_LED_C,
    output         GPIO_LED_W,
    output         GPIO_LED_E,
    output         GPIO_LED_S,
    output         GPIO_LED_N,

    // DDR2
    /*inout  [63:0]  DDR2_D,
    output [7:0]   DDR2_DM,
    output [12:0]  DDR2_A,
    output [1:0]   DDR2_CLK_P,
    output [1:0]   DDR2_CLK_N,
    output [1:0]   DDR2_CS_B,
    output [1:0]   DDR2_ODT,
    output [1:0]   DDR2_CKE,
    output         DDR2_RAS_B,
    output         DDR2_CAS_B,
    output         DDR2_WE_B,
    output [1:0]   DDR2_BA,
    inout  [7:0]   DDR2_DQS_P,
    inout  [7:0]   DDR2_DQS_N,*/
    /*output         DDR2_SCL,
    inout          DDR2_SDA,*/
    
    // Speaker
    //output         PIEZO_SPEAKER,
    
    // DVI
    /*output [11:0]  DVI_D,
    output         DVI_DE,
    output         DVI_H,
    output         DVI_RESET_B,
    output         DVI_V,
    output         DVI_XCLK_N,
    output         DVI_XCLK_P,*/
    //input          DVI_GPIO1,
    
    // Dual Shock 2
    //input          DS2_DAT,
    //output         DS2_CMD,
    //output         DS2_ATT,
    //output         DS2_CLK,
    //input          DS2_ACK,
    
    // CSTN
    input [23:1]   CPU_A,
    inout [15:0]   CPU_D,
    output         CPU_FLT_B,
    output         CPU_RESET,
    output         CPU_NMI,
    output         CPU_INTR,
    output         CPU_PEREQ,
    output         CPU_BUSY_B,
    output         CPU_ERROR_B,
    input          CPU_BHE_B,
    input          CPU_BLE_B,
    input          CPU_ADS_B,
    output         CPU_NA_B,
    output         CPU_READY_B,
    input          CPU_WR,
    input          CPU_DC,
    input          CPU_MIO,
    input          CPU_LOCK_B,
    output         CPU_HOLD,
    input          CPU_HLDA,
    output         CPU_CLK2,
    output         CPU_A20M_B,
    output         CPU_FLUSH_B,
    output         CPU_KEN_B,
    output         CPU_SUSP_B,
      
    // System
    input          FPGA_CPU_RESET_B,
    input          CLK_33MHZ_FPGA
    //input          CLK_27MHZ_FPGA
    );

    //Clock and Reset control   
    wire clk_33;
    wire clk_50;
    wire clk_200;
    wire clk_200_90;
    wire clk_100;
    wire clk_200_dly;
    wire clk_from_ddr;

    wire rst_in;
    wire rst_pll;
    wire rst;
    wire pll_locked;
    wire rst_from_ddr;

    assign clk_33 = CLK_33MHZ_FPGA;
    assign rst_in = ~FPGA_CPU_RESET_B;
    
    pll pll (
        .CLKIN1_IN(clk_33), 
        .RST_IN(rst_pll), 
        .CLKOUT0_OUT(clk_50), 
        .CLKOUT1_OUT(clk_200), 
        .CLKOUT2_OUT(clk_200_90),
        .CLKOUT3_OUT(clk_100),
        .CLKOUT4_OUT(clk_200_dly),
        .LOCKED_OUT(pll_locked)
    );

    debounce_rst debounce_rst(
        .clk(clk_33),
        .noisy_rst(rst_in),
        .pll_locked(pll_locked),
        .clean_pll_rst(rst_pll),
        .clean_async_rst(rst)
    );
    
    //Keys
    button button_c(
        .pressed(), 
        .pressed_disp(GPIO_LED_C),
        .button_input(GPIO_SW_C),
        .clock(clk_50),
        .reset(rst)
    );

    button button_w(
        .pressed(), 
        .pressed_disp(GPIO_LED_W),
        .button_input(GPIO_SW_W),
        .clock(clk_50),
        .reset(rst)
    );
    
    button button_e(
        .pressed(), 
        .pressed_disp(GPIO_LED_E),
        .button_input(GPIO_SW_E),
        .clock(clk_50),
        .reset(rst)
    );
    
    button button_s(
        .pressed(), 
        .pressed_disp(GPIO_LED_S),
        .button_input(GPIO_SW_S),
        .clock(clk_50),
        .reset(rst)
    );
    
    assign GPIO_LED_N = pll_locked;
    
    wire [7:0] led_output;
    
    wire [13:0] rom_address;
    wire [31:0] rom_rd_data;
    wire rom_rd_enable;
    wire rom_rd_valid;
    
    wire [2:0] state;
    wire [1:0] bus_state;
    
    busmaster busmaster(
        .clk(clk_50),           // Base Clock Input (50MHz)
        .rst(rst),           // Clean Active High reset input
        .cpu_a(CPU_A),
        .cpu_d(CPU_D),
        .cpu_ads_n(CPU_ADS_B),     // Address Status
        .cpu_bhe_n(CPU_BHE_B),     // High Byte Enable
        .cpu_ble_n(CPU_BLE_B),     // Low Byte Enable 
        .cpu_busy_n(CPU_BUSY_B),      // Busy
        .cpu_clk2(CPU_CLK2),      // Clock
        .cpu_dc(CPU_DC),        // H: Data, Low: Control
        .cpu_error_n(CPU_ERROR_B),   // Error
        .cpu_hlda(CPU_HLDA),      // Bus Hold Acknowledge
        .cpu_hold(CPU_HOLD),      // Bus Hold Request
        .cpu_intr(CPU_INTR),      // Interrupt Request
        .cpu_lock_n(CPU_LOCK_B),    // Bus Lock
        .cpu_mio(CPU_MIO),       // H: Memory, L: IO
        .cpu_na_n(CPU_NA_B),      // Next Address
        .cpu_nmi(CPU_NMI),       // Non-Maskable Interrupt Request
        .cpu_pereq(CPU_PEREQ),     // Processor Extension Request
        .cpu_ready_n(CPU_READY_B),   // Bus Ready
        .cpu_reset(CPU_RESET),     // Reset
        .cpu_wr(CPU_WR),        // H: Write, L: Read
        .ram_wr_ack(1'b1),
        .ram_wr_data(),
        .ram_address(),
        .ram_wr_enable(),
        .ram_wr_mask(),
        .ram_rd_enable(),
        .ram_rd_data(32'b0),
        .ram_rd_valid(1'b1),          
        .vga_vsync(),     // VGA Vertical Sync
        .vga_hsync(),     // VGA Horizontal Sync
        .vga_pclk(),      // VGA Pixel Clock
        .vga_de(),        // VGA Data Enable
        .vga_pixel(),     // VGA Pixel Data (6-6-6)
        .rom_address(rom_address),   // BIOS ROM Address
        .rom_rd_data(rom_rd_data),   // BIOS ROM Data
        .rom_rd_enable(rom_rd_enable), // BIOS ROM Read Enable
        .rom_rd_valid(rom_rd_valid),  // BIOS ROM Read Valid
        .led_output(led_output),
        .state(state),
        .bus_state(bus_state)
    );
    
    assign CPU_FLT_B = 1'b1;
    assign CPU_A20M_B = 1'b1;
    assign CPU_FLUSH_B = 1'b1;
    assign CPU_KEN_B = 1'b1;
    assign CPU_SUSP_B = 1'b1;
    
    bios_rom bios_rom(
        .clk(clk_50),
        .rst(rst),
        .address(rom_address[12:0]),
        .rd_data(rom_rd_data),
        .rd_enable(rom_rd_enable),
        .rd_valid(rom_rd_valid)
    );
    
    assign GPIO_LED[0] = led_output[0];
    assign GPIO_LED[1] = rom_rd_enable;
    assign GPIO_LED[2] = rom_rd_valid;
    assign GPIO_LED[7:5] = state[2:0];
    assign GPIO_LED[4:3] = bus_state[1:0];

endmodule
