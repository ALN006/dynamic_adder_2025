// TODO:

//imports 
`include "source/buffer.sv"

// behavioural verilog code for new adder with width and gate delay parameterized
module CRCA #(
    parameter N = 8, NAND_D = 1, NOR_D = 1, XOR_D = 1
) (ready, S, P, Cout, A, B, Cin, first, request);
    
    // time definition
    timeunit 1ns;
    timeprecision 0.5ns;

    // I/O type specification
    input [N-1:0] A, B;
    input Cin, first, request;
    output Cout, ready; 
    output [N-1:0] P, S;

    // wire between RCA and output buffer
    wire [N:0] RCA_out;

    // core logic
    RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.S(RCA_out[N-1:0]), .P(P), .Cout(RCA_out[N], .A(A), .B(B), .Cin(Cin)));

    // encoding of carry chain breaks at quadrants
    wire [2:0] quadrant_breaks; 
    

endmodule