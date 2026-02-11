// imports to add in top module
// `include "FA.v"

module RCA #(parameter N = 8) (A, B, Cin, Cout, P, S);

    //N is bitwidth 

    // I/O  declaration
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1: 0] P, S;

    //internal ripple carry wiring
    wire [N-1:0] C;

    //instantiating bitslices
    FA instance1 (A[0],B[0],Cin,C[0],P[0],S[0]);
    genvar i;
    generate
        for ( i = 1; i < N; i++) begin : adder
            FA u0 (A[i],B[i],C[i-1],C[i],P[i],S[i]);
        end
    endgenerate

    //
    assign Cout = C[N-1];


endmodule