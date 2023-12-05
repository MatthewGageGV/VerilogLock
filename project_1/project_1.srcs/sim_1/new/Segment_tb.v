`timescale 1ns / 1ps


module Segment_tb();

    reg [3:0] display_value = 0;
    wire [6:0] segment_out;
    
    Seg_Decoder S1 (.display_value(display_value), .segment_out(segment_out));
    
    initial begin
    
        #10 Check_Out(1'b0);
        $finish;
    end

    task Check_Out;
    
        input [3:0] display_value;
        
        begin 
        
            
            $display ("Given: %d, Segment will display %b", display_value, segment_out);
            
            if (display_value > 16 || display_value < 0)
                $display ("error!");
    
        end
    
    endtask

endmodule
