`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:25:05
// Design Name: 
// Module Name: ShiftReg
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


module ShiftReg(clk, pdata, sout);
	parameter WIDTH = 16;
	parameter DELAY = 12;
	input clk;
	input [WIDTH - 1:0] pdata;
	output [3:0] sout;
	wire sck, sdat, clrn;
	reg oe;
	assign sout = {sck, sdat, oe, clrn};
	
	reg [WIDTH:0] shift;
	reg [DELAY-1:0] counter = -1;
	wire sckEn;
	
	assign sckEn = |shift[WIDTH - 1:0];
	assign sck = ~clk & sckEn;
	assign sdat = shift[WIDTH];
	assign clrn = 1'b1;
	
	always @ (posedge clk)
	begin
		if(sckEn)
			shift <= {shift[WIDTH - 1:0], 1'b0};
		else
		begin
			if(&counter)
			begin
				shift <= {pdata, 1'b1};
				oe <= 1'b0;
			end
			else
				oe <= 1'b1;
			counter <= counter + 1'b1;
		end
	end
endmodule

