`timescale 1ns / 1ps

module Password(clk, data_in, key_flag, reset, RGB);
input[3:0] data_in;
input clk, key_flag;
input reset;
output[2:0] RGB;

parameter IDLE = 0,
          ONE = 1,
          TWO = 2,
          THREE = 3,
          FOUR = 4,
          LOCKED = 5,
          UNLOCKED = 6,
          WAIT1 = 7,
          WAIT2 = 8,
          WAIT3 = 9;
         
reg[2:0] RGB;
reg[4:0] digit1, digit2, digit3, digit4;
reg[3:0] state = IDLE;
reg[22:0] count = 23'h0;

always @(posedge clk) begin
    case (state)
        
        IDLE: begin
            if (reset) state <= IDLE;
            else if (key_flag) state <= ONE;
            else begin
                RGB <= 3'b000; // OFF
                digit1 <= 0; digit2 <= 0; digit3 <= 0; digit4 <= 0;
            end
        end
        
        ONE: begin
            digit1 = data_in;
            if (reset) state <= IDLE;
            else if (key_flag) state <= WAIT1;
            else state <= ONE;
        end
        
        TWO: begin
            digit2 = data_in;
            if (reset) state <= IDLE;
            else if (key_flag) state <= WAIT2;
            else state <= TWO;
        end
        
        THREE: begin
            digit3 = data_in;
            if (reset) state <= IDLE;
            else if (key_flag) state <= WAIT3;
            else state <= THREE;
        end
        
        FOUR: begin
            digit4 = data_in;
            if (reset) state <= IDLE;
            else if ((digit1 == 4'h1) && (digit2 == 4'h2) && (digit3 == 4'h3) && (digit4 == 4'h4)) state <= UNLOCKED;
            else state <= LOCKED;
        end 
        
        LOCKED: begin
            if (reset) state <= IDLE;
            else RGB <= 3'b100; // RED
        end
        
        UNLOCKED: begin
            if (reset) state <= IDLE;
            else RGB <= 3'b001; // GREEN
        end   
        
        WAIT1: begin
            if (count == 2600000) state <= TWO;
            else count <= count + 1;
        end
        
        WAIT2: begin
            if (count == 2600000) state <= THREE;
            else count <= count + 1;
        end
        
        WAIT3: begin
            if (count == 2600000) state <= FOUR;
            else count <= count + 1;
        end
        
    endcase
end

endmodule
