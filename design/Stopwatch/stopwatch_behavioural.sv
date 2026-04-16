// TODO: add documentation in readme.md

// NOTE: reset must be called at the start

// behavioural self-driving stopwatch module with internal clk synchronous reset with absolute timing
module stopwatch_behavioural #(
    parameter N = 4, 
    parameter real half_period = 0.5 // "real" allows for fractional delays
) (reset, state);

    // internal clock for absolute timing
    reg clk;
    initial clk = 1'b1;
    always #(half_period) clk = ~clk;

    // I/O type specification
    input reset;
    output reg [N-1:0] state;

    // logic
    always @(posedge clk) state <=  reset ? {N{1'b0}} : state + 1;

endmodule
 