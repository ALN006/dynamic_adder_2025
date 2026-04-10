// TODO: convert to allow testing of multiple bitwidths at the same time

//testbench for stopwatch circuit defined in source file included 
`include "stopwatch.v"

module stopwatch_tb #(Parameter start = 1, stop = 9, step = 1, AND_D = 1, XOR_D=1)();
    timeunit 1ns;
    timeprecision 1ns;

    //input ports
    reg F;
    
    //output ports
    wire out;

    //design under test
    stopwatch #(.N(N), .AND_D(AND_D), .XOR_D(XOR_D)) DUT (.F(F), .out(out));

    genvar i;
    generate
        for (i = start; i < stop; i = i + step) begin : duts

        end
    endgenerate
endmodule