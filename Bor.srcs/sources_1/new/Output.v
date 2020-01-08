`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:09:43
// Design Name: 
// Module Name: Output
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Output(
    input [31:0] clk, 
	input [2:0] type, 
	input [2:0] track, 
	input [10:0] h, 
	input [9:0] w, 
	input [31:0] num, 
	input [11:0] mask, 
	input [15:0] speed,
	output [3:0] sout, 
	output [8:0] row_addr, // pixel ram row address, 480 (512) lines
	output [9:0] col_addr, // pixel ram col address, 640 (1024) pixels
	output [3:0] r, 
	output [3:0] g, 
	output [3:0] b, 
	output hs, vs    // horizontal and vertical synchronization
	);
	localparam TRACK_WIDTH = 160;
	wire [11:0] rom_data;
	wire [11:0] sceen_data; 
	wire [11:0] vga_data;
	
	wire [3:0] fix_r;
	wire [3:0] fix_g;
	wire [3:0] fix_b;
	assign r = fix_b;
	assign g = fix_g; 
	assign b = fix_r;
	
	VGA vga(
		.vga_clk(clk[1]), .clrn(1'b1), .d_in(vga_data), .row_addr(row_addr), .col_addr(col_addr), .r(fix_r), 
		.g(fix_g), .b(fix_b), .hs(hs), .vs(vs)
	);
	
	wire [18:0] addr_begin; 
	wire [18:0] addr_offset;
	wire [10:0] height; 
	wire [10:0] width; 
	
	KeyObject keys(
	   .type(type),
	   .h(height),
	   .w(width),
	   .addr(addr_begin)
	);
	assign addr_offset = (type==2'b00)? addr_begin + col_addr * width + row_addr : addr_begin + h * width + w;
	
	Image rom(
		.clka(clk[0]),
		.ena(1'b1), 
		.wea(1'b0), 
		.addra(addr_offset), 
		.dina(12'b0), 
		.douta(rom_data)
	);
	wire [11:0] scene_data;
	assign scene_data = (rom_data != 12'hF0F ) ? rom_data : 12'h9CD;
	assign vga_data = mask & scene_data;
	
	DispBCD dispBCD(
		.clkdiv(clk), 
		.hex(num), 
		.sout(sout)
	);
endmodule
