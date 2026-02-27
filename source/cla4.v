module cla4(
    input [3:0] A, 
    input [3:0] B,
    input C_in, 
    output [3:0] nP,
    output [3:0] S,
    output C_out
);

    wire [3:0] G;
    wire [3:0] P;
    wire [4:0] C;

    assign #1 G[0] = ~(A[0] & B[0]);
    assign #1 G[1] = ~(A[1] & B[1]);
    assign #1 G[2] = ~(A[2] & B[2]);
    assign #1 G[3] = ~(A[3] & B[3]);

    assign #1 P[0] = ~(A[0] | B[0]);
    assign #1 P[1] = ~(A[1] | B[1]);
    assign #1 P[2] = ~(A[2] | B[2]);
    assign #1 P[3] = ~(A[3] | B[3]);

    assign #2 C[0] = ~(~C_in);
    assign #2 C[1] = ~(P[0] | (G[0] & ~C[0]));
    assign #2 C[2] = ~(P[1] | (P[0] & G[1]) | (G[0] & G[1] & ~C[0]));
    assign #2 C[3] = ~(P[2] | (P[1] & G[2]) | (P[0] & G[1] & G[2]) | (G[0] & G[1] & G[2] & ~C[0]));
    assign #2 C[4] = ~(P[3] | (P[2] & G[3]) | (P[1] & G[2] & G[3]) | (P[0] & G[1] & G[2] & G[3]) | (G[0] & G[1] & G[2] & G[3] & ~C[0]));
    assign #2 C_out = C[4];

    assign #2 S[0] = C[0] ^ (G[0] & ~P[0]);
    assign #2 S[1] = C[1] ^ (G[1] & ~P[1]);
    assign #2 S[2] = C[2] ^ (G[2] & ~P[2]);
    assign #2 S[3] = C[3] ^ (G[3] & ~P[3]);

    assign nP = P;

endmodule