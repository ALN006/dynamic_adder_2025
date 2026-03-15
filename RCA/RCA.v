// this is an N bit Ripple Carry Adder

// imports to add in top module
// `include "FA.v"

module RCA #(parameter N = 8) (S, P, Cout, A, B, Cin);
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1: 0] P, S;

    //internal ripple carry wiring
    wire [N-1:0] C;

    //instantiating bitslices
    FA instance1 (.a(A[0]),.b(B[0]),.Cin(Cin),.Cout(C[0]),.P(P[0]),.S(S[0]));
    genvar i;
    generate
        for ( i = 1; i < N; i++) begin : adder
            FA u0 (.a(A[i]),.b(B[i]),.Cin(C[i-1]),.Cout(C[i]),.P(P[i]),.S(S[i]));
        end
    endgenerate

    assign Cout = C[N-1];


endmodule