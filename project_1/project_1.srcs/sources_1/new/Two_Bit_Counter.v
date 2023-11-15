`timescale 1ns / 1ps

module Two_Bit_Counter(clk, reset, count);

input clk, reset;
output [1:0] count;

reg [1:0] count = 2'b00;
wire clk, reset;

always @(posedge clk) begin

    if (reset) begin
    
        //count <= 2'b00;
        
     end
     else begin
     
        count <= count + 1;
        
     end
     
end
     
endmodule
