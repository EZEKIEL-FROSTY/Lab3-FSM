module f1_starting_light #(
    parameter WIDTH = 8
)(
    input  logic             clk,      // clock 
    input  logic             rst,      // reset
    input  logic             cmd_delay,
    input  logic             cmd_seq,
    input  logic             trigger,   
    input  logic             en,       // cmd_seq
    input  logic [WIDTH-1:0] N,        // clock divided by N+1
    output logic [WIDTH-1:0] data_out      // tick output
);
    logic   K;
    logic   tick;
    logic   time_out;
    logic   mux_out;
    assign mux_out = tick | time_out;

clktick clkdiv(
    .clk(clk),
    .rst(rst),
    .en(cmd_seq),
    .N(N),
    .tick(tick)
);

f1_fsm lights(
    .rst(rst),
    .en(mux_out),
    .trigger(trigger),
    .clk(clk),
    .data_out(data_out),
    .cmd_seq(cmd_seq),
    .cmd_delay(cmd_delay)
);

lfsr_7 shift(
    .clk(clk),
    .data_out(K)
);

delay wait(
    .clk(clk),
    .rst(rst),
    .trigger(cmd_delay),
    .n(K),
    .time_out(time_out)
);

endmodule
