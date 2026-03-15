// this is a test_bench for adders
//TODO: allow for testing of multiple bitwidths in the same run

`timescale 1ns/1ns 

`include "RCA.v"
`include "FA.v"

module adder_tb;

    // declaring parameters, values are set with makefile
    parameter N, NAND_D, XOR_D;

    // I/O declaration 
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //adder selection
    `ifdef RCA
        RCA #(.N(N), .NAND_D(NAND_D), .XOR_D(XOR_D)) adder (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(S));
        initial $display("RCA instantiated as design under test");
    `endif

endmodule