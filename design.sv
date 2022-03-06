`timescale 1ns / 1ps

 module seq_detector(
   input seq_in, clk, reset,
   output logic detect_out
 );

   //one-hot encoding of FSM
   enum logic [3:0] {S0 = 4'b0001, S1 = 4'b0010, S2 = 4'b0100, S3 = 4'b1000}  state, next;

   //state registers
   always_ff @(posedge clk or posedge reset)
     if (reset) state <= S0;   
     else       state <= next;

   // Next state assignment logic
   always_comb begin: set_next_state        
     next = state;
     unique case (state)
       S0 : if (seq_in) next = S1; else next = S0;
       S1 : if (seq_in) next = S1; else next = S2;     
       S2 : if (seq_in) next = S3; else next = S0;
       S3 : if (seq_in) next = S1; else next = S2; 
   endcase  
   $monitor(state);
   end: set_next_state 

   // Registered output logic
   always_ff @(posedge clk, posedge reset)
     if (reset) detect_out <= 1'b0;
     else       detect_out <= (state == S3) && seq_in; 
  
 endmodule
