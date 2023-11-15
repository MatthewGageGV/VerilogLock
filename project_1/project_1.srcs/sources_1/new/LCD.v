`timescale 1ns / 1ps

module LCD (clk, reset, data, RS, R_W, E, LED1, LED2, LED3);

    input clk, reset;
    output [7:0] data;
    output E, RS, R_W;
    output [3:0] LED1;
    output LED2;
    output [7:0] LED3;
    
    reg [27:0] clkcount;
    reg clk_divide_1MHz;
    reg [15:0] delay_count;
   
    
    parameter [3:0] Initalize           = 1,
                    Function_Set        = 2,
                    Wait1               = 3,
                    Display_Set         = 4,
                    Wait2               = 5,
                    Display_Clear       = 6,
                    Wait3               = 7,
                    Idle                = 8;
                    
    reg [3:0] cur_state = Initalize, next_state;
    reg E = 0, RS = 0, R_W = 0; 
    reg [7:0] data = 0;
    
    reg delayOK;
    
    reg [7:0] letter_pos;
    reg flag = 0;
    reg [7:0] welcome_ascii [0:13];
    reg [7:0] number_ascii [0:2];

    initial begin
        welcome_ascii[0]  = 8'h57; // 'W'
        welcome_ascii[1]  = 8'h65; // 'e'
        welcome_ascii[2]  = 8'h6C; // 'l'
        welcome_ascii[3]  = 8'h63; // 'c'
        welcome_ascii[4]  = 8'h6F; // 'o'
        welcome_ascii[5]  = 8'h6D; // 'm'
        welcome_ascii[6]  = 8'h65; // 'e'
        welcome_ascii[7]  = 8'h20; // ' '
        welcome_ascii[8]  = 8'h54; // 'T'
        welcome_ascii[9]  = 8'h6F; // 'o'
        welcome_ascii[10] = 8'h20; // ' '
        welcome_ascii[11] = 8'h45; // 'E'
        welcome_ascii[12] = 8'h47; // 'G'
        welcome_ascii[13] = 8'h52; // 'R'

        number_ascii[0] = 8'h32; // '2'
        number_ascii[1] = 8'h32; // '2'
        number_ascii[2] = 8'h34; // '4'
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
    
    // Delay Handler
    always @(posedge clk_divide_1MHz) begin
    
        if (delayOK) begin
            
            delay_count <= 0;
            
            
        end else begin
        
            delay_count <= delay_count + 1;
            
        end
    
    delayOK <= (
        ((cur_state == Initalize) && (delay_count == 20000)) ||
        ((cur_state == Wait1) && (delay_count == 40)) ||
        ((cur_state == Wait2) && (delay_count == 40)) ||
        ((cur_state == Wait3) && (delay_count == 1600)) ||
        ((cur_state == Idle) && (delay_count == 26000))
    ) ? 1 : 0;
        
    end
       
    always @(posedge clk_divide_1MHz or posedge reset) begin
    
        if (reset) begin
        
            cur_state <= Initalize;
            
        end else begin
        
            cur_state <= next_state;
        
        end
    
    end
    
    // State Transition Handler
    always @(cur_state or delayOK) begin
    
        case (cur_state) 
        
         Initalize:
            if (delayOK) begin
             next_state <= Function_Set;
            end else begin
             next_state <= Initalize;
            end
            
         Function_Set:
            next_state <= Wait1;
            
         Wait1:
            if (delayOK) begin
             next_state <= Display_Set;
            end else begin
             next_state <= Wait1;
            end
            
         Display_Set:
            next_state <= Wait2;
            
         Wait2:
            if (delayOK) begin
             next_state <= Display_Clear;
            end else begin
             next_state <= Wait2;
            end
            
         Display_Clear:
            next_state <= Wait3;
            
         Wait3:
            if (delayOK) begin
             next_state <= Idle;
            end else begin
             next_state <= Wait3;
            end
            
         Idle:
            next_state <= Idle;
            
        endcase
        
    end
    
    // State Output Handler
    always @(posedge clk_divide_1MHz) begin
    
        if (next_state == Function_Set) begin
        
            E <= 1;
            data <= 8'h3C;
        
        end else if (next_state == Display_Set) begin
        
            E <= 1;
            data <= 8'h0F;
        
        end else if (next_state == Display_Clear) begin
        
            E <= 1;
            data <= 8'h01;
        
        end else if (next_state == Idle) begin
            
            if ((!flag) && delayOK && (letter_pos != 14)) begin
                
                RS <= 1;
                letter_pos <= letter_pos + 1;
                data <= welcome_ascii[letter_pos];
                E <= 1;
                
            end else if ((!flag) && delayOK && (letter_pos == 14)) begin
                
                RS <= 0;
                data <= 8'hC7;
                E <= 1;
                
                letter_pos <= 0;
                flag <= 1;
                
            end else if (flag && delayOK && (letter_pos != 3)) begin
                
                RS <= 1;
                data <= number_ascii[letter_pos];
                letter_pos <= letter_pos + 1;
                E <= 1;
            
            end else begin
            
                E <= 0; 
                
            end
            
                        
        end else begin
        
            if (E) E <= 0;
        
        end
    
    end
    
    

assign LED1 = letter_pos;
assign LED2 = RS;
assign LED3 = data;


endmodule