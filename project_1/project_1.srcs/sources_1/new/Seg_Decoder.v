`timescale 1ns / 1ps

module Seg_Decoder(display_value, segment_out);

input  [3:0] display_value;
output [6:0] segment_out;

reg  [6:0] segment_out;
wire [3:0] display_value;

initial begin

segment_out = 7'b0000001; // Display '0'

end

always begin
   
        case (display_value)
            4'h0: segment_out = 7'b0000001; // Display '0'
            4'h1: segment_out = 7'b1001111; // Display '1'
            4'h2: segment_out = 7'b0010010; // Display '2'
            4'h3: segment_out = 7'b0000110; // Display '3'
            4'h4: segment_out = 7'b1001100; // Display '4'
            4'h5: segment_out = 7'b0100100; // Display '5'
            4'h6: segment_out = 7'b0100000; // Display '6'
            4'h7: segment_out = 7'b0001111; // Display '7'
            4'h8: segment_out = 7'b0000000; // Display '8'
            4'h9: segment_out = 7'b0000100; // Display '9'
            4'hA: segment_out = 7'b0001000; // Display 'A'
            4'hB: segment_out = 7'b1100000; // Display 'B'
            4'hC: segment_out = 7'b0110001; // Display 'C'
            4'hD: segment_out = 7'b1000010; // Display 'D'
            4'hE: segment_out = 7'b0110000; // Display 'E'
            4'hF: segment_out = 7'b0111000; // Display 'F'
            default: segment_out = 7'b1111111; // All segments off for unknown input
        endcase

end

endmodule
