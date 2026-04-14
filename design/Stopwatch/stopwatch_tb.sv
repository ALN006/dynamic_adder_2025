// TODO: convert to allow testing of multiple bitwidths at the same time

//testbench for stopwatch circuit defined in source file included 
`include "stopwatch.sv"

module stopwatch_tb #(
    parameter start = 1, 
    parameter stop  = 9, 
    parameter step  = 1, 
    parameter AND_D = 1, 
    parameter XOR_D = 1
)();

    //time definition
    timeunit 1ns;
    timeprecision 1ns;

    localparam NUM_INSTANCES = (stop - start) / step;

    // Inputs: One F bit per instance
    reg [NUM_INSTANCES-1:0] F;

    // Outputs: Since 'out' width varies per instance, we use an array of wires.
    // We size the second dimension to 'stop' to ensure it's wide enough for the largest N.
    wire [stop-1:0] out_bus [NUM_INSTANCES-1:0];

    genvar i;
    generate
        for (i = start; i < stop; i = i + step) begin : duts
            localparam INST_IDX = (i - start) / step;
            stopwatch #(
                .N(i), 
                .AND_D(AND_D), 
                .XOR_D(XOR_D)
            ) DUT (
                .F(F[INST_IDX]), 
                .out(out_bus[INST_IDX][i-1:0]) // Connect only the required N bits
            );
        end
    endgenerate

    initial begin
        $dumpfile("stopwatch_tb.vcd");
        $dumpvars(0, stopwatch_tb);

        // Standard Verilog way to set all bits to 1 for variable widths
        F = {NUM_INSTANCES{1'b1}};
        #8;
        F = {NUM_INSTANCES{1'b0}};
        
        #200;
        $display("Simulation done, results are in stopwatch_tb.vcd");
        $finish;
    end 
endmodule