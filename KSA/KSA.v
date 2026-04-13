/*
    this is a Kogge Stone Adder unclocked, it will only work as intended with N = a power of 2
*/

module KSA #(parameter N = 8) (A,B, Cin, Cout,S);
    
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
    // calculating Cin like this is a bit of a heuristic
    // someone could rewrite the tree to include a bit -1
    // to be more realistic
    assign #(1) G[0] = (A & B) | ((A ^ B) & Cin);
    assign #(1) P[0] = A ^ B;

    genvar i, level;
    generate
        // iterate through every level
        for (level = 1; level <= $clog2(N); level++) begin 
            // iterate through every n
            for (i=0; i < N; i++) begin
                // if bit number i greater or equal than 2^(level - 1), then
                // use KSA cell
                // calculates propagate signal even when one isn't strictly
                // necessary
                if (i >= (1 << (level-1))) begin
                    assign #(2) G[level][i] = G[level-1][i] | (P[level-1][i] & G[level-1][i - (1 << (level-1))]);
                    assign #(1) P[level][i] = P[level-1][i] & P[level-1][i - (1 << (level-1))];
                // otherwise use a buffer
                end else begin 
                    assign G[level][i] = G[level-1][i];
                    assign P[level][i] = P[level-1][i];
                end
            end
        end
    endgenerate
    
    assign C[N:1] = G[$clog2(N)];
    // assign #(2) C[N:1] = G[$clog2(N)] | (P[$clog2(N)] & {N{Cin}});
    assign #(1) S = C[N-1:0]^P[0];
    assign Cout = C[N];

endmodule
