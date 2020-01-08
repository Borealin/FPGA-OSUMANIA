`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 09:38:38
// Design Name: 
// Module Name: Logic
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


module Logic(
    input [31:0] clkdiv, 
	input rstn, 
	input D, 
	input F, 
	input J, 
	input K, 
	input [8:0] row_addr, // pixel ram row address, 480 (512) lines
	input [9:0] col_addr, // pixel ram col address, 640 (1024) pixels
	output reg [2:0] type, // key type
	output reg [2:0] track,
	output reg [10:0] h, // relative height in the object. valid when type != 63
	output reg [9:0] w,
	output reg [1:0] over,  // 0x: sceen; 10: gameover; 11: win
	output reg [31:0] score,
	output reg [15:0] speed
	);
	localparam MAX_CUR = 6400;
	integer counter = 0;
	reg [15:0] current = 0;
	reg [4:0] key;
	wire [10:0] height;
	
	initial begin
	   speed = 10'd80;
	end
	
	always @(posedge clkdiv[0]) begin
	   if(counter > 30'd4000000) begin
	       counter = 0;
	       current = current + 1'b1;
	       if(current > MAX_CUR) begin
	           current = 0;
	       end
	   end
	   counter = counter + 1'b1;
	end
	
	wire [1:0] typeD;
	wire [1:0] typeF;
	wire [1:0] typeJ;
	wire [1:0] typeK;
	wire [15:0] resD;
	wire [15:0] resF;
	wire [15:0] resJ;
	wire [15:0] resK;
	wire [10:0] hD;
	wire [10:0] hF;
	wire [10:0] hJ;
	wire [10:0] hK;
	wire [31:0] sco;
	TrackLogic trackD(.clkdiv(clkdiv),.rstn(rstn),.button(key[0]),.current_h(current),.h(hD),.track(2'b00),.col_addr(col_addr),.speed(speed),.type(typeD),.res(resD));
	TrackLogic trackF(.clkdiv(clkdiv),.rstn(rstn),.button(key[1]),.current_h(current),.h(hF),.track(2'b01),.col_addr(col_addr),.speed(speed),.type(typeF),.res(resF));
	TrackLogic trackJ(.clkdiv(clkdiv),.rstn(rstn),.button(key[2]),.current_h(current),.h(hJ),.track(2'b10),.col_addr(col_addr),.speed(speed),.type(typeJ),.res(resJ));
	TrackLogic trackK(.clkdiv(clkdiv),.rstn(rstn),.button(key[3]),.current_h(current),.h(hK),.track(2'b11),.col_addr(col_addr),.speed(speed),.type(typeK),.res(resK));
	
	always @(posedge clkdiv[1]) begin
		if (D) begin 
		  key = key | 4'b0001;  
		end else begin
		  key = key & 4'b1110;
		end
		if (F) begin 
		  key = key | 4'b0010;  
		end else begin
		  key = key & 4'b1101;
		end
		if (J) begin
		  key = key | 4'b0100;  
		end else begin
		  key = key & 4'b1011;
		end
		if (K) begin 
		  key = key | 4'b1000;  
		end else begin
		  key = key & 4'b0111;
		end
		score[15:0] = resD+resF+resJ+resK;
	end
	wire [11:0] x; assign x = col_addr;
	wire [11:0] y; assign y = row_addr;
	always @(posedge clkdiv[2]) begin
	   if(y > 0 && y <= 9'd120) begin
	       w = x - 0;
	       h = hD;
	       type = typeD;
	       track = 2'b00;
	   end else if(y > 9'd120 && y <= 9'd240) begin
	       w = x - 9'd120;
	       h = hF;
	       type = typeF;
	       track = 2'b01;
	   end else if(y > 9'd240 && y <= 9'd360) begin
	       w = x - 9'd240;
	       h = hJ;
	       type = typeJ;
	       track = 2'b10;
	   end else if(y > 9'd360 && y <= 10'd480) begin
	       w = x - 9'd360;
	       h = hK;
	       type = typeK;
	       track = 2'b11;
	   end
	end
endmodule
