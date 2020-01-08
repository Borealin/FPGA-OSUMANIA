`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/05 23:43:36
// Design Name: 
// Module Name: TrackObject
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


module KeyObject(
	input [2:0] type, // 0 - 3 (4)
	output reg [10:0] h, 
	output reg [10:0] w, 
	output reg [18:0] addr
);

	always@(*) begin
		case(type)
		    0: begin
               h <= 640;
               w <= 480;
               addr <= 0;
//			0: begin
//               h <= 640;
//               w <= 480;
//               addr <= 0;
            end
            1: begin
               h <= 43;
               w <= 120;
               addr <= 307200;
            end
            2: begin
               h <= 43;
               w <= 120;
               addr <= 312360;
            end
//			2: begin
//				h <= 30;
//				w <= 160;
//				addr <= 0;
//			end
//			3: begin
//				h <= 30;
//				w <= 160;
//				addr <= 0;
//			end
			default: begin
				h <= 1;
				w <= 1;
				addr <= 0;
			end
		endcase

	end
endmodule
