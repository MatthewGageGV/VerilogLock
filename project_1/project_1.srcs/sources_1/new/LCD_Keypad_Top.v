`timescale 1ns / 1ps

module LCD_Keypad_Top(clk, reset, row, col, anode, segment, LCD_Out, E, RS, R_W, RGB);

input clk, reset;
inout [3:0] row;
inout [3:0] col;

output RS, R_W, E;

output [3:0] anode;
output [6:0] segment;

output [7:0] LCD_Out;
output [2:0] RGB;

wire clk_out, Key_Flag;
wire [1:0] sel;
wire [6:0] seg0, seg1, seg2, seg3;
wire [3:0] Key_out;
wire [7:0] decode_out;
wire [3:0] display_0, display_1, display_2, display_3;

Clk_Divider_1KHz    C1  (.clkin(clk), .reset(reset), .clkout(clk_out));
Two_Bit_Counter     T1  (.clk(clk_out), .reset(reset), .count(sel));
Multiplexer         M1  (.seg0(seg0), .seg1(seg1), .seg2(seg2), .seg3(seg3), .sel(sel), .anode(anode), .segment(segment));
Seg_Decoder         S1  (.display_value(display_0), .segment_out(seg0));
Seg_Decoder         S2  (.display_value(display_1), .segment_out(seg1));
Seg_Decoder         S3  (.display_value(display_2), .segment_out(seg2));
Seg_Decoder         S4  (.display_value(display_3), .segment_out(seg3));
Keypad              K1  (.clk(clk), .Row(row), .Col(col), .Out0(display_0), .Out1(display_1), .Out2(display_2), .Out3(display_3), .Flag_out(Key_Flag), .Key_out(Key_out));
LCD_Decoder         D1  (.decode_in(Key_out), .decode_out(decode_out));
LCD                 L1  (.clk(clk), .reset(reset), .data(LCD_Out), .RS(RS), .R_W(R_W), .E(E), .Key_Flag(Key_Flag), .Key_in(decode_out), .RGB(RGB));


endmodule
