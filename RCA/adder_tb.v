// this is a test_bench for adders
//TODO: at line 22 write code to specify adder under test using command line arguments

`timescale 1ns/1ns 

`include "RCA.v"
`include "FA.v"

module adder_tb;

    // setting default values for parameters
    parameter N = 16;
    parameter NAND_D = 1;
    parameter XOR_D = 1;

    // I/O declaration 
    reg [N-1:0] A, B;
    reg Cin;
    wire Cout;
    wire [N-1:0] P, S;

    //adder under test
    

endmodule