// no imports needed for functionality

// this is an ideal register (no hold time or setup time)
module register #(parameter N = 8) (clk, in, out);

    //N is the bitwidth of the register

    // I/O declaration
    input [N-1:0] in;
    input clk;
    output reg [N-1:0] out;
    
    //no internal wiring at this level of abstraction

    //logic: register sets output = input when clk becomes high
    always @(posedge(clk)) begin
        out = in;
    end


endmodule
