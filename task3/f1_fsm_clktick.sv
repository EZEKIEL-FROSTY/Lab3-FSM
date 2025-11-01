module f1_fsm_clktick #(
    parameter WIDTH = 16
)(
    input  logic             clk,      // clock 
    input  logic             rst,      // reset
    input  logic             en,       // enable signal
    input  logic [WIDTH-1:0] N,        // clock divided by N+1
    output logic [7:0]       data_out
);

    logic               tick;

clktick clkdiv(
    .clk(clk),
    .rst(rst),
    .en(en),
    .N(N),
    .tick(tick)
);

f1_fsm lights(
    .rst(rst),
    .en(tick),
    .clk(clk),
    .data_out(data_out)
);

endmodule
