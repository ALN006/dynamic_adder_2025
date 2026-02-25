module brent_kung_adder #(parameter N = 8) (A, B, C_in, S, C_out);
    input [N-1:0] A;
    input [N-1:0] B;
    input C_in;
    output C_out;
    output [N-1:0] S;

    localparam stages = (2 * $clog2(N)) - 2;
    
    wire[N:0] C;
    assign C[0] = C_in;
    wire [N-1:0] G [stages:0];
    wire [N-1:0] P [stages:0];

    assign #1 P[0] = A ^ B;
    assign #2 G[0][0] = (A[0] & B[0]) | (P[0][0] & C_in);
    assign #1 G[0][N-1:1] = A[N-1:1] & B[N-1:1];

    genvar i, stage;

    generate
        // forward pass
        for (stage = 1; stage < $clog2(N); stage = stage + 1) begin
            localparam step = 2**stage;
            localparam prev_step = 2**(stage - 1);
            for (i = 0; i < N; i = i + 1) begin
                if ((i+1) % step == 0) begin
                    // perform circle operation
                    assign #2 G[stage][i] = G[stage - 1][i] | (P[stage - 1][i] & G[stage - 1][i - prev_step]);
                    assign #1 P[stage][i] = P[stage - 1][i] & P[stage - 1][i - prev_step];
                end else begin
                    // keep previous value
                    assign G[stage][i] = G[stage - 1][i];
                    assign P[stage][i] = P[stage - 1][i];
                end
            end
        end

        // one forward and one backward pass (stage = log2(N))
        for (i = 0; i < N; i = i + 1) begin
            localparam prev_step = i + 1 - N/2;
            localparam stage = $clog2(N);
            if ((i == N - 1) || (i == ((3*N)/4 - 1))) begin
                // perform circle operation
                assign #2 G[stage][i] = G[stage - 1][i] | (P[stage - 1][i] & G[stage - 1][i - prev_step]);
                assign #1 P[stage][i] = P[stage - 1][i] & P[stage - 1][i - prev_step];
            end else begin
                // keep previous value
                assign G[stage][i] = G[stage - 1][i];
                assign P[stage][i] = P[stage - 1][i];
            end
        end

        // backward pass
        for (stage = ($clog2(N) + 1); stage <= stages; stage = stage + 1) begin
            localparam step = 2**(stages - stage + 1);
            localparam prev_step = 2**(stages - stage);
            for (i = 0; i < N; i = i + 1) begin
                if ((i >= step) && (i != (N - 1)) && ((i + 1 - prev_step) % step == 0)) begin
                    // perform circle operation
                    assign #2 G[stage][i] = G[stage - 1][i] | (P[stage - 1][i] & G[stage - 1][i - prev_step]);
                    assign #1 P[stage][i] = P[stage - 1][i] & P[stage - 1][i - prev_step];
                end else begin
                    // keep previous value
                    assign G[stage][i] = G[stage - 1][i];
                    assign P[stage][i] = P[stage - 1][i];
                end
            end
        end
    endgenerate

    assign C[N:1] = G[stages];
    assign #1 S[N-1:0] = C[N-1:0] ^ P[0];

    assign C_out = C[N];

endmodule
