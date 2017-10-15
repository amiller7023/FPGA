//`include "led_fsm.v"
//`include "code_reg.v"
////////////////////////////////////////////////////////////////
//  Main File for dassign3 
////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////
//  module dassign3 (also MORSE_ENCODER)
////////////////////////////////////////////////////////////////
module dassign3(
		input 	    btnC,
		input [11:0] sw,
		output[1:0] led,
		input 	    btnU, clk
		);

////////////////////////////////////////////////////////////////
//  Parameter Declarations
////////////////////////////////////////////////////////////////
reg [26:0] counter = 0;
 
 always@(posedge clk) begin
   counter <= counter + 27'b000000000000000000000000001;
 end
 
////////////////////////////////////////////////////////////////
//  Variable Declaration
////////////////////////////////////////////////////////////////

   // Outputs from modules       
   wire       shft_data, sym_done, led_drv; 
   wire [3:0] cntr_data; 
    assign led[0] = led_drv;
    
   // Signals that needs to be generated by this module
   reg 	      char_next, char_load, shft_cnt, sym_strt;
   assign led[1] = char_next;
////////////////////////////////////////////////////////////////
//  Module Instantiation
////////////////////////////////////////////////////////////////

   code_reg codestore0(sw[11:4], sw[3:0], char_load, 
                       sym_done, cntr_data, shft_data, btnU, counter[26]);
  led_fsm ledfsm0(sym_strt, shft_data, led_drv, sym_done, 
                   btnU, counter[26]);
        
/* Some useful pseudo-code (you have to figure out if there are
   timing consideration or sequencing that you would want to do.
   From that, you can choose to build an FSM. You can choose to 
   build it as a separate module).
 
 symbol for led_fsm = shft_data from the shifter
 sym_strt is asserted when btnC or after you've shifted 
    a new data symbol from the shifter

 space symbol is detected when sw[3:0] = 4'b0000      
 shft_cnt is asserted when sym_done is asserted (if using the 
    counter to deal with a space, you'd need to enable shft_cnt for 
    a "space" symbol)

 char_next for encoder = cntr counts down to 0
    (load counter with 4'b0111 when it is a space either in 
    code_reg or here)
 char_ vald input should trigger the char_load to grab the new 
    sw[11:4] and sw[3:0]
 */

 //Using counter[26]] as the clock signal.
  parameter IDLE = 4'b0000;
  parameter LOADED = 4'b0001;
  parameter SHIFTED = 4'b0010;
  parameter SPACE = 4'b0011;
  
  reg [3:0] next_st, curr_st;
  always @(posedge counter[26]) begin
    curr_st <= next_st;
  end 
   
  always @(*) begin
    
     if (btnU) begin
      next_st = IDLE;
      char_load = 1'b0;
      sym_strt = 1'b0;
      char_next = 1'b1;
      shft_cnt = 1'b0;
     end 
    
     else begin 
       case (curr_st)
         IDLE: begin 
           if (btnC) begin
             if(sw[3:0] == 4'b0000)begin
             next_st = SPACE;
             char_load = 1'b1;
             char_next = 1'b0;
             sym_strt = 1'b0;
       		 shft_cnt = 1'b1;
             end
             else begin
             next_st = LOADED;
             char_load = 1'b1;
             char_next = 1'b0;
             sym_strt = 1'b1;
       		 shft_cnt = 1'b1;
             end
           end 
           else if (!btnC && !shft_cnt)begin
             next_st = IDLE;
             char_load = 1'b0;
             sym_strt = 1'b0;
             char_next = 1'b1;
             shft_cnt = 1'b0;
           end 
           else begin
           end 
         end 
    
         LOADED: begin
           if (cntr_data == 0 && sym_done) begin
            next_st = IDLE;
            char_load = 1'b0;
            sym_strt = 1'b0;
            char_next = 1'b1;
            shft_cnt = 1'b0;
           end 
           else if (cntr_data != 0 && sym_done) begin
             next_st = SHIFTED;
             shft_cnt = 1'b1;
             char_next = 1'b0;
             sym_strt = 1'b0;
           end 
           else begin
             next_st = LOADED;
             char_next = 1'b0;
             char_load = 1'b0;
             sym_strt = 1'b0;
             shft_cnt = 1'b1;
           end 
         end
         SHIFTED: begin
           if (cntr_data != 0 ) begin
             next_st = SHIFTED;
             sym_strt = 1'b1;
             shft_cnt = 1'b1;
             char_next = 1'b0;
           end
           else begin
             next_st = IDLE;
             sym_strt = 1'b0; 
             char_next = 1'b1;
             shft_cnt = 1'b0;
           end 
         end 
           SPACE: begin
           if (cntr_data != 0 ) begin
             next_st = SPACE;
             char_load = 1'b0;
             sym_strt = 1'b0;
             shft_cnt = 1'b1;
             char_next = 1'b0;
           end
           else begin
             next_st = IDLE;
             char_load = 1'b0;
             sym_strt = 1'b0; 
             char_next = 1'b1;
             shft_cnt = 1'b0;
           end 
         end
         default: begin
            next_st = IDLE;
            char_load = 1'b0;
            sym_strt = 1'b0;
            shft_cnt = 1'b0;
            char_next = 1'b1;
         end 
       endcase 
     end 
   end
endmodule // dassign3
