`timescale 1ns / 1ps

module LCD (clk, reset, data, RS, R_W, E, Key_Flag, Key_in, RGB, LED);

    input clk, reset, Key_Flag;
    input [7:0] Key_in;
    output [7:0] data;
    output E, RS, R_W;
    output [2:0] RGB;
    output [7:0] LED;
    
    reg [27:0] clkcount;
    reg clk_divide_1MHz;
    reg [15:0] delay_count;
    reg [2:0] key_count;
    reg pass;
    reg[2:0] RGB;
    
    parameter [7:0] Initialize          = 1,
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
                    End                 = 16,
                    Locked              = 17,
                    Wait5               = 18,
                    WriteLock           = 19,
                    WaitLock            = 20,
                    Unlocked            = 21,
                    Wait6               = 22,
                    WriteUnlock         = 23,
                    WaitUnlock          = 24,
                    End2                = 25;
                    
    reg [7:0] state = Initialize;
    reg E = 0, RS = 0, R_W = 0; 
    reg [7:0] data = 0;
    
    reg [7:0] letter_pos;
    reg [7:0] line1 [0:14];
    reg [7:0] unlocked[0:12];
    reg [7:0] locked[0:10];

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
        
        unlocked[0]  = 8'h55; // 'U'
        unlocked[1]  = 8'h6E; // 'n'
        unlocked[2]  = 8'h6C; // 'l'
        unlocked[3]  = 8'h6F; // 'o'
        unlocked[4]  = 8'h63; // 'c'
        unlocked[5]  = 8'h6B; // 'k'
        
        locked[0]  = 8'h4C; // 'L'
        locked[1]  = 8'h6F; // 'o'
        locked[2]  = 8'h63; // 'c'
        locked[3]  = 8'h6B; // 'k'
    
    end
  
    // 1MHz clock divider
    always @(posedge clk) begin
    
        if (reset) begin 
        
            clkcount <= 0;
            
        end else if (clkcount == 50) begin
        
            clkcount <= 0;
            clk_divide_1MHz <= ~clk_divide_1MHz;
            
        end else begin
        
            clkcount <= clkcount + 1;
        
        end
        
    end
    
    always @(posedge clk_divide_1MHz or posedge reset) begin
    
        if (reset) begin
        
            state <= Initialize;
            key_count <= 0;
        
        end else begin
    
        case (state)
        
        Initialize: 
        begin
          
          RS <= 0;
          E <= 0;
          
          key_count <= 0;
          RGB <= 3'b000;
          
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
          data <= 8'hC2;

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
                case (key_count)
                    0: begin
                        if (Key_in == 8'h31) begin
                            pass <= 1;
                        end
                        else begin
                            pass <= 0;
                        end
                    end
                    1: begin
                        if ((Key_in == 8'h32) && pass == 1) begin
                            pass <= 1;
                        end
                        else begin
                            pass <= 0;
                        end
                    end
                    2: begin
                        if ((Key_in == 8'h33) && pass == 1) begin
                            pass <= 1;
                        end
                        else begin
                            pass <= 0;
                        end
                    end
                    3: begin
                        if ((Key_in == 8'h34) && pass == 1) begin
                            pass <= 1;
                        end
                        else begin
                            pass <= 0;
                        end
                    end
                endcase
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
            if (key_count < 4) begin
                state <= Input_Wait;
            end
            else begin
                state <= End;
            end
            delay_count <= 0;
          end else begin 
            state <= Write_Delay2;
            delay_count <= delay_count + 1;
          end             
        
        end
        
        End: begin
            
            if (pass) begin
                state <= Unlocked;
            end else begin
                state <= Locked;
            end
             
        end
        
        Locked:
        begin
        
            RGB <= 3'b010; // Red
        
            RS <= 0;
            E <= 1;
            data <= 8'hC8;
          
            state <= Wait5;
        
        end
        
        Wait5:
        begin
          
          E <= 0;
          
          if (delay_count == 40) begin
            state <= WriteLock;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        WriteLock:
        begin
        
          RS <= 1;
          E <= 1;
                
          data <= locked[letter_pos];
                
          if (letter_pos == 4) begin 
                
            letter_pos <= 0;
            state <= End2; 
                
          end else begin
          
            state <= WaitLock;
            
          end
        
        end
        
        WaitLock:
        begin
        
          E <= 0;
          
          if (delay_count == 26000) begin
            letter_pos <= letter_pos + 1;
            state <= WriteLock;
            delay_count <= 0;
          end else begin 
            state <= WaitLock;
            delay_count <= delay_count + 1;
          end             
        
        end
        
        Unlocked:
        begin
        
            RGB <= 3'b100; // Red
        
            RS <= 0;
            E <= 1;
            data <= 8'hC8;
          
            state <= Wait6;
        
        end
        
        Wait6:
        begin
          
          E <= 0;
          
          if (delay_count == 40) begin
            state <= WriteUnlock;
            delay_count <= 0;
          end else begin
            delay_count <= delay_count + 1;
          end             
                     
        end
        
        WriteUnlock:
        begin
        
          RS <= 1;
          E <= 1;
                
          data <= unlocked[letter_pos];
                
          if (letter_pos == 6) begin 
                
            letter_pos <= 0;
            state <= End2; 
                
          end else begin
          
            state <= WaitUnlock;
            
          end
        
        end
        
        WaitUnlock:
        begin
        
          E <= 0;
          
          if (delay_count == 26000) begin
            letter_pos <= letter_pos + 1;
            state <= WriteUnlock;
            delay_count <= 0;
          end else begin 
            state <= WaitUnlock;
            delay_count <= delay_count + 1;
          end             
        
        end
        
        End2:
        begin
                
            if (Key_Flag)
                state <= Initialize;
            else 
                state <= End2; 
        
        end
        
      endcase
        
      end
    
    end
    
    assign LED = state;
    
endmodule