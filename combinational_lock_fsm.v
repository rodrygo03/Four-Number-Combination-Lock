`timescale 1ns / 1ps
`default_nettype none


module combination_lock_fsm(
    output reg [2:0] state, // to ease debuggin made an output
    output wire [3:0] Lock, // asserted when locked
    input wire Key1,        // unlock button 0
    input wire Key2,        // unlock button 1
    input wire [3:0] Password,   // indicate number
    input wire Reset,       // reset
    input wire Clk          // clock
);

    // state encoding for state reg
    parameter s0 = 3'b000, s1 = 3'b001,
              s2 = 3'b010, s3 = 3'b011,
              s4 = 3'b100;
              
    // intermeidate nets
    reg [2:0] nextState;
    
    // combinational logic: next state
    always@(*)
        case(state)
            s0: begin
                if (Key1 == 1 && Password == 4'b1101) // password 13
                    nextState = s1;
                else 
                    nextState = s0;
                end
                
            s1: begin
                if (Key2 == 1 && Password == 4'b0111) // 7
                    nextState = s2;
                else if (Key2 == 1)
                    nextState = s0;
                else
                    nextState = s1;
                end
            
            s2: begin
                if (Key1 == 1 && Password == 4'b1001) // 9
                    nextState = s3;
                else if (Key1 == 1)
                    nextState = s0;
                else
                    nextState = s2;
                end
                     
            s3: begin
                if (Key2 == 1 && Password == 4'b0101) // 5
                    nextState = s4;
                else if (Key2 == 1)
                    nextState = s0;
                else 
                    nextState = s3;
                end

            s4: begin
                if (Reset == 1)
                    nextState = s0;
                else
                    nextState = s4;            
                end
            
            endcase


    // sequential logic: state reg
    always@(posedge Clk)
        if (Reset)
            state <= s0;
        else
            state <= nextState;
    
    // lock is assign with 15_base(10) only if state is s3
    assign Lock = (state == s4) ? 4'b1111 : 4'b0000;
            

endmodule

