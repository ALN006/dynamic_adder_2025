// imports to add in top module
// `include "RCLA.v"
// `include "cla4.v"

//this is a Ripple Carry Adder with CLA bitslices
module RCLA #(parameter N = 8)(Cin, A, B, Cout, S, G);

    // N is the bitwidth of the RCLA, must be atleast 4
    
    // I/O declaration
    input [N-1:0] A, B;
    input Cin;
    output Cout;
    output [N-1:0] S;
    output [3: 1] G; //checks for generate in the cla to the right of every quadrant boundry

    // internal wiring
    wire [N/4 - 1: 0] C;
    wire [N - 1: 0] P;

    cla4 slice0 (.A(A[3:0]), .B(B[3:0]), .C_in(Cin), .S(S[3:0]), .C_out(C[0]), .P(P[3:0]));

    genvar i;
    generate
        for (i = 1; i < N/4; i++) begin : adder
            cla4 u0 (.A(A[4*i+3:4*i]), .B(B[4*i+3:4*i]), .C_in(C[i-1]), .C_out(C[i]), .P(P[4*i+3:4*i]), .S(S[4*i+3:4*i]));
        end
    endgenerate

    assign Cout = C[N/4 -1];

    generate
        for (i = 1; i < 4; i++) begin : gen_group
            assign G[i] = ~&P[(N/4)*i -1 : (N/4)*i -4];
        end
    endgenerate

endmodule