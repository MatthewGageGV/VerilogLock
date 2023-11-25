`timescale 1ns / 1ps

module Keypad(clk, Row, Col, Out0, Out1, Out2, Out3, Flag_out, Key_out);

input clk;
input [3:0] Row;
output Flag_out;
output [3:0] Col;
output [3:0] Key_out;
output [3:0] Out0, Out1, Out2, Out3;

reg flag, scan;
reg [15:0] flagCount;
reg [1:0] sel;
reg [28:0] count;
reg [3:0] Col;
reg [3:0] Out0, Out1, Out2, Out3;
reg [3:0]DecodeOut;

always @(posedge clk) begin
    // Set a flag high every 0.25 seconds
    if (count == 12500000) begin
      count <= 0; // Reset count
      scan <= ~scan;
    end else begin
      count <= count + 1;
    end
end

always @(posedge clk) begin

if ((count == 100000) && scan) begin
     Col <= 4'b0111;
end 
else if ((count == 110000) && scan) begin
         
    case(Row)
    
     4'b0111: //Row 1
      begin
        DecodeOut <= 4'h1;
        if (!flag) flag <= 1;
      end
        
     4'b1011: //Row 2
      begin
        DecodeOut <= 4'h4;
        if (!flag) flag <= 1;
      end
      
     4'b1101: //Row 3
      begin
        DecodeOut <= 4'h7; 
        if (!flag) flag <= 1;
      end
     
     4'b1110: //Row 4
      begin
        DecodeOut <= 4'h0;
        if (!flag) flag <= 1;
      end

     endcase
     
end
else if ((count == 200000) && scan) begin
     Col <= 4'b1011;
end 
else if ((count == 210000) && scan) begin
         
    case(Row)
    
     4'b0111: //Row 1
      begin
        DecodeOut <= 4'h2;
        if (!flag) flag <= 1;
      end
        
     4'b1011: //Row 2
      begin
        DecodeOut <= 4'h5;
        if (!flag) flag <= 1;
      end
      
     4'b1101: //Row 3
      begin
        DecodeOut <= 4'h8; 
        if (!flag) flag <= 1;
      end
     
     4'b1110: //Row 4
      begin
        DecodeOut <= 4'hF;
        if (!flag) flag <= 1;
      end

     endcase
     
end 
else if ((count == 300000) && scan) begin
     Col <= 4'b1101;
end 
else if ((count == 310000) && scan) begin
         
    case(Row)
    
     4'b0111: //Row 1
      begin
        DecodeOut <= 4'h3;
        if (!flag) flag <= 1;
      end
        
     4'b1011: //Row 2
      begin
        DecodeOut <= 4'h6;
        if (!flag) flag <= 1;
      end
      
     4'b1101: //Row 3
      begin
        DecodeOut <= 4'h9; 
        if (!flag) flag <= 1;
      end
     
     4'b1110: //Row 4
      begin
        DecodeOut <= 4'hE;
        if (!flag) flag <= 1;
      end

     endcase
     
end
else if ((count == 400000) && scan) begin
     Col <= 4'b1110;
end 
else if ((count == 410000) && scan) begin
         
    case(Row)
    
     4'b0111: //Row 1
      begin
        DecodeOut <= 4'hA;
        if (!flag) flag <= 1;
      end
        
     4'b1011: //Row 2
      begin
        DecodeOut <= 4'hB;
        if (!flag) flag <= 1;
      end
      
     4'b1101: //Row 3
      begin
        DecodeOut <= 4'hC; 
        if (!flag) flag <= 1;
      end
     
     4'b1110: //Row 4
      begin
        DecodeOut <= 4'hD;
        if (!flag) flag <= 1;
      end

     endcase
     
end

if (flag) begin

    if (flagCount == 50000) begin
      flagCount <= 0; // Reset count after 1 second
      flag <= 0;
    end else begin
      flagCount <= flagCount + 1;
    end
           
        
end

end

 
always @(posedge flag) begin

sel <= sel + 1;

    case(sel)
        2'b00: Out0 <= DecodeOut;
        2'b01: Out1 <= DecodeOut;
        2'b10: Out2 <= DecodeOut;
        2'b11: Out3 <= DecodeOut;
    endcase
    
end

assign Flag_out = flag;
assign Key_out = DecodeOut;

endmodule