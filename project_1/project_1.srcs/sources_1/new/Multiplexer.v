`timescale 1ns / 1ps

module Multiplexer(seg0, seg1, seg2, seg3, sel, anode, segment);

input  [6:0] seg0, seg1, seg2, seg3;
input  [1:0] sel;
output [6:0] segment;
output [3:0] anode;

reg [6:0] segment;
reg [3:0] anode;

always @(sel) begin
    case (sel)
        2'b00: begin
         anode <= 4'b0111;
         segment <= seg0;
        end
        2'b01: begin
         anode <= 4'b1011;
         segment <= seg1;
        end
        2'b10: begin
         anode <= 4'b1101;
         segment <= seg2;
        end
        2'b11: begin
         anode <= 4'b1110;
         segment <= seg3;
        end
    endcase
end


endmodule
