`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:14:04
// Design Name: 
// Module Name: Input
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


module Input(
    input clk, 
	input ps2_clk, 
	input ps2_data, 
	output reg D, F, J, K, R
    );

	wire [7:0] ps2_byte;
	wire ps2_state;

	reg [2:0] rst_ticks = 0;
	wire rst = &rst_ticks;

	PS2Driver PS2Driver(
		.clk(clk), 
		.rst(rst), 
		.ps2_clk(ps2_clk), // Input
		.ps2_data(ps2_data), // Input
		.ps2_byte(ps2_byte), // Output
		.ps2_state(ps2_state) // Output
	);

	always @(posedge clk) begin
		case (ps2_byte)
			8'h23: D = ps2_state;
			8'h2b: F = ps2_state;
			8'h3b: J = ps2_state;
			8'h42: K = ps2_state;
			8'h2d: R = ps2_state;
		endcase
		if (~&rst_ticks) rst_ticks = rst_ticks + 1'b1;
	end

endmodule

