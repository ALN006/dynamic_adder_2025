module cla4(
    input [3:0] A, 
    input [3:0] B,
    input C_in, 
    output [3:0] P,
    output [3:0] S,
    output C_out
);

    wire [3:0] G;
    wire [3:0] O;
    wire [4:0] C;

    assign #1 G[0] = ~(A[0] & B[0]);
    assign #1 G[1] = ~(A[1] & B[1]);
    assign #1 G[2] = ~(A[2] & B[2]);
    assign #1 G[3] = ~(A[3] & B[3]);

    assign #1 O[0] = ~(A[0] | B[0]);
    assign #1 O[1] = ~(A[1] | B[1]);
    assign #1 O[2] = ~(A[2] | B[2]);
    assign #1 O[3] = ~(A[3] | B[3]);

    assign #2 C[0] = ~(~C_in);
    assign #2 C[1] = ~(O[0] | (G[0] & ~C[0]));
    assign #2 C[2] = ~(O[1] | (O[0] & G[1]) | (G[0] & G[1] & ~C[0]));
    assign #2 C[3] = ~(O[2] | (O[1] & G[2]) | (O[0] & G[1] & G[2]) | (G[0] & G[1] & G[2] & ~C[0]));
    assign #2 C[4] = ~(O[3] | (O[2] & G[3]) | (O[1] & G[2] & G[3]) | (O[0] & G[1] & G[2] & G[3]) | (G[0] & G[1] & G[2] & G[3] & ~C[0]));
    assign C_out = C[4];

    assign #1 P = {(G[3] & ~O[3]), (G[2] & ~O[2]), (G[1] & ~O[1]), (G[0] & ~O[0])};

    assign #1 S[0] = C[0] ^ P[0];
    assign #1 S[1] = C[1] ^ P[1];
    assign #1 S[2] = C[2] ^ P[2];
    assign #1 S[3] = C[3] ^ P[3];

endmodule