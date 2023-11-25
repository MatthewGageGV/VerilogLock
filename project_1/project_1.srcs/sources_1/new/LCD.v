`timescale 1ns / 1ps

module LCD (clk, reset, data, RS, R_W, E, Key_Flag, Key_in);

    input clk, reset, Key_Flag;
    input [7:0] Key_in;
    output [7:0] data;
    output E, RS, R_W;
    
    reg [27:0] clkcount;
    reg clk_divide_1MHz;
    reg [15:0] delay_count;
    reg [2:0] key_count;
    
    parameter [3:0] Initialize          = 1,
                    Function_Set        = 2,
                    Wait1               = 3,
                    Display_Set         = 4,
                    Wait2               = 5,
                    Display_Clear       = 6,
                    Wait3               = 7,
                    DisplayOK           = 8,
                    Write1              = 9,
                    Write_Delay1        = 10,
                    Shift               = 11,
                    Wait4               = 12,
                    Input_Wait          = 13,
                    Write_Input         = 14,
                    Write_Delay2        = 15,
                    End                 = 16;
                    
    reg [3:0] state = Initialize;
    reg E = 0, RS = 0, R_W = 0; 
    reg [7:0] data = 0;
    
    reg [7:0] letter_pos;
    reg [7:0] line1 [0:14];

    initial begin
    
        line1[0] = 8'h45;  // E
        line1[1] = 8'h6E;  // n
        line1[2] = 8'h74;  // t
        line1[3] = 8'h65;  // e
        line1[4] = 8'h72;  // r

        line1[5] = 8'h20;  // space

        line1[6] = 8'h34;  // 4

        line1[7] = 8'h20;  // space

        line1[8] = 8'h64;  // d
        line1[9] = 8'h69;  // i
        line1[10] = 8'h67; // g

        line1[11] = 8'h20; // space

        line1[12] = 8'h50; // P
        line1[13] = 8'h49; // I
        line1[14] = 8'h4E; // N
    
    end
  
    // 1MHz clock divider
    always @(posedge clk or posedge reset) begin
    
        if (reset) begin 
        
            clkcount <= 0;
            
        end else if (clkcount == 50) begin
        
            clkcount <= 0;
            clk_divide_1MHz <= ~clk_divide_1MHz;
            
        end else begin
        
            clkcount <= clkcount + 1;
        
        end
        
    end
    
    always @(posedge clk_divide_1MHz) begin
    
        if (reset) begin
        
            state <= Initialize;
            key_count <= 0;
        
        end else begin
    
        case (state)
        
        Initialize: 
        begin
          
          RS <= 0;
          E <= 0;
          
          if (delay_count == 20000) begin
            state <= Function_Set;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        Function_Set:
        begin
        
          RS <= 0;
          E <= 1;
          data <= 8'h3C;
          
          state <= Wait1;
        
        end
        
        Wait1:
        begin
          
          E <= 0;
          
          if (delay_count == 40) begin
            state <= Display_Set;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        Display_Set:
        begin
        
          RS <= 0;
          E <= 1;
          data <= 8'h0F;
          
          state <= Wait2;
        
        end
        
        Wait2:
        begin
          
          E <= 0;
          
          if (delay_count == 40) begin
            state <= Display_Clear;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        Display_Clear:
        begin
        
          RS <= 0;
          E <= 1;
          data <= 8'h01;
          
          state <= Wait3;
        
        end
        
        Wait3:
        begin
          
          E <= 0;
          
          if (delay_count == 1600) begin
            state <= DisplayOK;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        DisplayOK:
        begin
        
          state <= Write1;
        
        end
        
        Write1:
        begin
        
          RS <= 1;
          E <= 1;
                
          letter_pos <= letter_pos + 1;
          data <= line1[letter_pos];
                
          if (letter_pos == 15) begin 
                
            letter_pos <= 0;
            state <= Shift; 
                
          end else begin
          
            state <= Write_Delay1;
            
          end
        
        end
        
        Write_Delay1:
        begin
        
          E <= 0;
          
          if (delay_count == 26000) begin
            state <= Write1;
            delay_count <= 0;
          end else begin 
            state <= Write_Delay1;
            delay_count <= delay_count + 1;
          end             
        
        end
        
        Shift:
        begin
          
          RS <= 0;
          E <= 1;
          data <= 8'hC6;

          state <= Wait4;
        
        end
        
        Wait4:
        begin
          
          E <= 0;
          
          if (delay_count == 40) begin
            state <= Input_Wait;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        Input_Wait:
        begin
        
          if (Key_Flag) begin
            
            key_count <= key_count + 1;
          
            if (key_count < 4) begin        
                state <= Write_Input;
            end else begin
                state <= End;
            end
          
          end else begin
          
            state <= Input_Wait;
            
          end 
        
        end
        
        Write_Input:
        begin
        
          RS <= 1;
          E <= 1;
          data <= Key_in;
          
          state <= Write_Delay2;
        
        end
        
        Write_Delay2:
        begin
        
          E <= 0;
          
          if (delay_count == 26000) begin
            state <= Input_Wait;
            delay_count <= 0;
          end else begin 
            state <= Write_Delay2;
            delay_count <= delay_count + 1;
          end             
        
        end
        
        End:
          state <= End;
        
      endcase
      
      end
    
    end
    
endmodule