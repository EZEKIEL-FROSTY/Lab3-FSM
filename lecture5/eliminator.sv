
module eliminator(
    input   logic clk,  // clock signal
    input   logic rst,  // async reset
    input   logic in,   // input signal
    output  logic output// output signal
);

    // define our states
    typedef enum  { S_A, S_B, S_C, S_D } my_state;s
    my_state current_state, next_state;

    // state transition
    always_ff @(posedge clk)
        if(rst)         current_state <= S_A;
        else            current_state <= next_state;
    
    // next state logic
    always_comb
        case (current_state)
            S_A:        if(in == 1'b1)      next_state = S_B;
                        else                next_state = current_state;
            S_B:        if(in == 1'b1)      next_state = S_C;
                        else                next_state = S_A;
            S_C:        if(in == 1'b0)      next_state = S_D;
                        else                next_state = current_state;
            S_D:        if(in == 1'b1)      next_state = S_C;
                        else                next_state = S_A;
            default: next_state = S_A;
        endcase
    
    // output logic
    always_comb
    case (current_state)
        S_A:    out = 1'b0;
        S_B:    out = 1'b0;
        S_C:    out = 1'b1;
        S_D:    out = 1'b1;
        default: begin
            out = 1'b0;
        end
    endcase

endmodule