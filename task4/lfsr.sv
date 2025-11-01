module lfsr(
    input   logic       clk,
    input   logic       rst,
    input   logic       en,
    output  logic [4:1] data_out
);

    logic [4:1] sreg;

always_ff @ (posedge clk, posedge rst)
    if(rst)
        sreg <= 4'b1; // any value except 0 to start;
    else if(en) begin // enable = 1
        sreg <= {sreg[3:1], sreg[4]^sreg[3]};
    end

assign data_out = sreg;

endmodule
