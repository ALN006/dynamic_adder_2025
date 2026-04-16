// TODO: ADD documentation in readme.md

// NOTE: time definitation and delays are coded into FA.v

//Ripple Carry Adder with Parametrized width and gate delays
module RCA #(
    parameter N = 8, NAND_D = 1, XOR_D = 1
) (S, P, Cout, A, B, Cin);

    // I/O type specification
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1: 0] P, S;

    //internal ripple carry wiring
    wire [N:1] C;

    //instantiating bitslices
    FA #(.NAND_D(NAND_D), .XOR_D(XOR_D)) instance1 (.a(A[0]),.b(B[0]),.Cin(Cin),.Cout(C[1]),.P(P[0]),.S(S[0]));
    generate
        for (genvar i = 1; i < N; i++) begin : adder
            FA #(.NAND_D(NAND_D), .XOR_D(XOR_D)) bitslice (.a(A[i]),.b(B[i]),.Cin(C[i]),.Cout(C[i+1]),.P(P[i]),.S(S[i]));
        end
    endgenerate

    assign Cout = C[N];

endmodule