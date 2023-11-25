`timescale 1ns / 1ps

module LCD_Decoder(decode_in, decode_out);

input[3:0] decode_in;
output[7:0] decode_out;

wire [3:0] decode_in;
reg [7:0] decode_out;

always @(decode_in) begin
    case (decode_in)
        4'h0:
            decode_out <= 8'h30;
        4'h1:
            decode_out <= 8'h31;
        4'h2:
            decode_out <= 8'h32;
        4'h3:
            decode_out <= 8'h33;
        4'h4:
            decode_out <= 8'h34;
        4'h5:
            decode_out <= 8'h35;
        4'h6:
            decode_out <= 8'h36;
        4'h7:
            decode_out <= 8'h37;
        4'h8:
            decode_out <= 8'h38;
        4'h9:
            decode_out <= 8'h39;
        4'hA:
            decode_out <= 8'h41;
        4'hB:
            decode_out <= 8'h42;
        4'hC:
            decode_out <= 8'h43;
        4'hD:
            decode_out <= 8'h44;
        4'hE:
            decode_out <= 8'h45;
        4'hF:
            decode_out <= 8'h46;
        default:
            decode_out <= 8'h3F; // ?
    endcase;
end

endmodule
