
// this is an N bit Pipelined Tree Adder

// imports to add in top module
// `include "FA.v"


module PTA #(parameter N = 8) (A,B, Cin, Cout,S);
    input [N-1: 0] A, B;
    input Cin;
    output Cout;
    output [N-1:0] S;

    // internal wiring
    wire [N-1:0] G [0:$clog2(N)];
    wire [N-1:0] P [0:$clog2(N)];
    wire [N:0] C;
    assign C[0] = Cin;

    //logic
    assign #(1) G[0] = A & B;
    assign #(1) P[0] = A ^ B;
    assign ready = 0;

    genvar i, level;
    generate
        for (level = 1; level <= $clog2(N); level++) begin 
            for (i=0; i < N; i++) begin
                if (i >= (1 << (level-1))) begin
                    assign #(2) G[level][i] = G[level-1][i] | (P[level-1][i] & G[level-1][i - (1 << (level-1))]);
                    assign #(1) P[level][i] = P[level-1][i] & P[level-1][i - (1 << (level-1))];
                    assign #(0) ready = 0;
                    assign #(2) ready = 1;
                end else begin 
                    assign G[level][i] = G[level-1][i];
                    assign P[level][i] = P[level-1][i];
                end
            end
        end
    endgenerate

    assign #(2) C[N:1] = G[$clog2(N)] | (P[$clog2(N)] & {N{Cin}});
    assign #(1) S = C[N-1:0]^P[0];
    assign Cout = C[N];

endmodule

