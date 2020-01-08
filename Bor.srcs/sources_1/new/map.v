`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/01/06 16:36:08
// Design Name: 
// Module Name: map
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


module map(
    input [1:0] track,
    input [15:0] current_h,
    output reg [31:0] shortcut
    );
    reg [511:0] DTrack=512'b1000010000000000000010000000000000010000000000001000000000000100000000100001000000100000000000000100000000000000001000000000000100000000100001000000100000000000000100000000000000001;
    reg [511:0] FTrack=512'b0000000000001000000000000000000100001000000100000000001000000000000100000000000010000000000100000000001000000001000000001000000000000100000000000010000000000100000000001000000001000;
    reg [511:0] JTrack=512'b0000000000001001000010000100000000000000001000000000010000000010000001000010010000000000000010000000000000010000000000010000000010000001000010010000000000000010000000000000010000000;
    reg [511:0] KTrack=512'b1000010010000000000000000000010000000010000000000100000010000000010000001000000000000100000000000000001000000000000100000010000000010000001000000000000100000000000000001000000000000;
    integer cur;
    integer i;
    always@(*) begin
        cur = current_h;
        case (track)
            2'b00: begin
                for(i=00;i<31;i=i+1) begin
                    shortcut[i] = DTrack[cur+i];
                end
            end
            2'b01: begin
                for(i=00;i<31;i=i+1) begin
                    shortcut[i] = FTrack[cur+i];
                end
            end
            2'b10: begin
                for(i=00;i<31;i=i+1) begin
                    shortcut[i] = JTrack[cur+i];
                end
            end
            2'b11: begin
                for(i=00;i<31;i=i+1) begin
                    shortcut[i] = KTrack[cur+i];
                end
            end
        endcase
    end
    
endmodule
