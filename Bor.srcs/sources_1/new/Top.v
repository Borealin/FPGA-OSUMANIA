`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:08:06
// Design Name: 
// Module Name: Top
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


module Top(
    input clk, 
	input ps2_clk, 
	input ps2_data, 
	output [3:0] sout, 
	output [3:0] r, 
	output [3:0] g, 
	output [3:0] b, 
	output hs, vs    // horizontal and vertical synchronization
    );
    wire [31:0] div;
	clkdiv clkdiv(.clk(clk), .rst(1'b0), .clkdiv(div));
	
	wire D, F, J, K, R;
	Input in(.clk(clk), .ps2_clk(ps2_clk), .ps2_data(ps2_data), .D(D), 
		.F(F),.J(J),.K(K),.R(R));
	wire [8:0] row_addr;
	wire [9:0] col_addr;
	wire [2:0] key; 
	wire [2:0] track; 
	wire [10:0] h; 
	wire [1:0] over;
	wire [11:0] mask;
	wire rstn;
	wire [31:0] score;
	wire [15:0] speed;

    Logic logic(.clkdiv(div), .rstn(rstn), .D(D), .F(F), .J(J), .K(K),
		.row_addr(row_addr), .col_addr(col_addr), .type(key),.track(track),.h(h),.w(w), .over(over), .score(score));
    
	Output out(.clk(div), .type(key),.track(track),.h(h),.w(w), .num(score),
	.row_addr(row_addr), .col_addr(col_addr), .r(r), .g(g), .b(b), 
		.hs(hs), .vs(vs), .mask(mask), .sout(sout));
	
	Fading fading(.clk(clk), .clk_frame(div[17]), .over(over), .retry(R), 
		.row_addr(row_addr), .col_addr(col_addr), .rstn(rstn), .mask(mask));
	
endmodule
