`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 11:11:13
// Design Name: 
// Module Name: TrackLogic
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


module TrackLogic(
    input [31:0] clkdiv, 
	input rstn, 
	input button,
	input [15:0] current_h,
	input [1:0] track,
	input [9:0] col_addr,//row_addr and speed calculate screen mapping relation
	input [8:0] speed,
	output reg [10:0] h,
	output reg [1:0] type, // key type 00 none 01 normal 10 special 11 hold
	output reg [15:0] res // 00 none 01 perfect 10 great 11 miss
    );
    reg last_button_state = 1'b0;
    wire [31:0] shortcut;
    map mapp(.track(track),.current_h(current_h),.shortcut(shortcut));
    always @(posedge clkdiv[0]) begin
        if(button != last_button_state) begin
		  last_button_state = button;
		  if(button == 1'b1) begin
		      if(shortcut[0]==1'b1) begin
		          res = res + 4'd10;
		      end else if(shortcut[1]==1'b1) begin
		          res = res + 4'd05;
		      end else if(shortcut[2]==1'b1) begin
		          res = res + 4'd0;
		      end else begin
		          res = res + 4'd0;
		      end
		  end
	   end
    end
//	reg [639:0] remap;
//	integer times = 4'd10;
//	integer i;
//	integer j;
//	integer sp = 10'd320;
//	always @(posedge clkdiv[1]) begin
//	    sp = (speed == 0)?10'd80:speed;
//		times = 10'd640 / sp;
//		for(i=0;i<times && i<=4'd8;i=i+1) begin
//		  remap[i*sp] = shortcut[i];
//		  for(j=1;j < sp && j<10'd320;j=j+1) begin
//		      remap[i*sp+j] = 1'b0;
//		  end
//		end
//	end
    always @(posedge clkdiv[1]) begin
		if(shortcut[col_addr/43]==1) begin
		      h = col_addr % 43;
		      type = (track[1]^track[0])?1:2;
		end else begin
		  h = col_addr;
		  type = 0;
		end
	end
    
endmodule
