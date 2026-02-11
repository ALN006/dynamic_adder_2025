// imports to add in top module
// `include "RCA.v"
// `include "FA.v"
// `include "buffer.v"

//this is a dumb RCA, one clock cycle operation
module DRCA #(parameter N = 8) (enable, clk, A, B, Cin, Cout, P, S);

    //N is the bitwidth of the DRCA

    // I/O declaration
    input [N-1:0] A, B;
    input clk, enable, Cin;
    output Cout;
    output [N-1: 0] P, S;

    //internal wiring 
    wire [N-1:0] RCA_sum;

    //logic: buffer releases sum from an RCA after worst case delay (length of clock cycle)
    RCA #(.N(N)) sum_logic (.A(A), .B(B), .Cin(Cin), .Cout(Cout), .P(P), .S(RCA_sum));
    buffer #(.N(N)) control_logic (.in(RCA_sum), .out(S), .control(~clk & enable));

endmodule
